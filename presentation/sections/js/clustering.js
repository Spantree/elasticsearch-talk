var svg = null;

function init() {
    console.log(svg);

    if(svg == null || svg.length < 1) {
        svg = d3.select(".shard-illustration")
        .append("svg")
        .attr("width", '100%')
        .attr("height", 400);

        var title = svg.append("text")
        .attr("class", "title")
        .attr("dy", "0.71em")
        .text("Test");
    }
}

function onShow() {
    init();  
}

document.addEventListener( 'shard-illustration-show', onShow, false );