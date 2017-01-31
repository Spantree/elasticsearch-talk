  ## Securing Elasticsearch

---

### By default, Elasticsearch trusts you

* Out the box, systems that have access to port 9200 can basically do whatever they want
* Do not allow direct access to port 9200
* Elastic offers robust security through its [X-Pack](https://www.elastic.co/products/x-pack) (commericial support)
* For simple authentication, there's also [Search Guard](https://floragunn.com/searchguard/)

---

### X-Pack Security

* Protects data from unauthorized Users

* Use built-in native authentication or integrate with other authentication systems (i.e. LDAP, Active Directory, build a custom realm)

* Allows permissions to be defined through Users and Roles
* Previously known as Shield

---

### X-Pack Security

* Create a PUT/POST request to add a Role

```json
POST /_xpack/security/role/my_admin_role
{
  "cluster": ["all"],
  "indices": [
    {
      "names": [ "index1", "index2" ],
      "privileges": ["all"],
      "field_security" : { // optional
        "grant" : [ "title", "body" ]
      },
      "query": "{\"match\": {\"title\": \"foo\"}}" // optional
    }
  ],
  "run_as": [ "other_user" ], // optional
  "metadata" : { // optional
    "version" : 1
  }
}
```

---

### X-Pack Security

* Create a PUT/POST request to add a User

```json
POST /_xpack/security/user/jacknich
{
  "password" : "j@rV1s",
  "roles" : [ "admin", "other_role1" ],
  "full_name" : "Jack Nicholson",
  "email" : "jacknich@example.com",
  "metadata" : {
    "intelligence" : 7
  }
}
```

---

### Scripting

* Elasticsearch provides robust scripting support
* Dynamic scripting is disabled by default in 2.x
* [Remote code execution is possible](http://blog.liftsecurity.io/2013/11/30/elasticsearch-command-execution-using-script)

---

### Disabling dynamic scripts on older versions

```yaml
script.disable_dynamic: false
```

---

### Use preloaded scripts instead

```bash
$ cat config/scripts/scoring/recency_boost.groovy
(0.08 / ((3.16*10.power(-11)) * (now - doc['timestamp'].date.getMillis()).abs() + 0.05)) + 1.0
```

```json
{
  "script": "scoring_recency_boost",
  "params": {
    "now": 1386176910000
  }
}
 ```

---

### Segregate different tenants/users into separate indexes

* This allows you to create some high-level URL rules to eliminate cross-polination
* Some apis like multi-search, multi-get and bulk allow take indexes as URL parameters or in the request body
* Lock this down with `allow_explicit_index: false`

---

### Sample nginx proxy rules

```nginx
server {
  listen                *:80 ;
  server_name           kibana.myhost.org;

  location / {
    root  /var/www/myappregin;
    index  index.html  index.htm;
  }

  location ~ ^/(\S+)?_(aliases|nodes|search|mapping)$ {
    proxy_pass http://127.0.0.1:9200;
    proxy_read_timeout 90;
  }
}
```

---

### Include ACLs in document body

```json
{
  "title": "Elasticsearch in Action",
  "price": 34.99,
  "visible_to_groups": ["spantree", "strangeloop"],
  "visible_to_users": ["george_smith", "jane_jones"]
}
```

---

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
