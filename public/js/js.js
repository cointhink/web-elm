function d3go(el) {
  let chart = d3.select('#chart');
  chartpants(chart)

  d3.select(window)
  .on("resize", function() {
    chartpants(chart)
  })
}

function chartpants(chart) {
  let aspect = 3
  var targetWidth = chart.node().getBoundingClientRect().width;
  chart.attr("width", targetWidth);
  chart.style("height", (targetWidth / aspect) +"px");
}
