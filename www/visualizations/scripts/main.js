define(['scripts/d3.v3', 'scripts/elasticsearch'], function(d3, elasticsearch) {

    "use strict";
    var client = new elasticsearch.Client({
        host: 'esdemo.local:9200'
    });

    client.search({
        index: 'divvy',
        size: 5,
        body: {
            aggs: {
                gender: {
                    terms: {
                        field: "gender"
                    }
                }
            }
        }
    }).then(function(resp) {
        console.log(resp);

        // D3 code goes here.
        var genders = resp.aggregations.gender.buckets;

        // d3 donut chart
        var width = 600,
            height = 300,
            radius = Math.min(width, height) / 2;

        var color = ['#00A9E0', '#D70060', '#61AE24'];

        var arc = d3.svg.arc()
            .outerRadius(radius - 60)
            .innerRadius(120);

        var pie = d3.layout.pie()
            .sort(null)
            .value(function(d) {
                return d.doc_count;
            });

        var svg = d3.select("#donut-chart").append("svg")
            .attr("width", width)
            .attr("height", height)
            .append("g")
            .attr("transform", "translate(" + width / 1.4 + "," + height / 2 + ")");

        var g = svg.selectAll(".arc")
            .data(pie(genders))
            .enter()
            .append("g")
            .attr("class", "arc");

        g.append("path")
            .attr("d", arc)
            .style("fill", function(d, i) {
                return color[i];
            });

        g.append("text")
            .attr("transform", function(d) {
                return "translate(" + arc.centroid(d) + ")";
            })
            .attr("dy", ".35em")
            .style("text-anchor", "middle")
            .style("fill", "black")
            .text(function(d) {
                return d.data.key;
            });
    });
});
