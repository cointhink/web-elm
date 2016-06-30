
function d3init() {
  let chart = d3.select('#chart');

  resize(chart)

  d3.select(window).on("resize", function(){ resize(chart) })

  chart.append('svg')
}

function resize(chart) {
  let aspect = 3

  // DIV size
  let boundingRect = chart.node().getBoundingClientRect();
  chart.attr("width", boundingRect.width);
  chart.style("height", (boundingRect.width / aspect) +"px");

  // SVG size
  let svg = chart.select("svg")
  svg.style('width', boundingRect.width + 'px')
     .style('height', boundingRect.height + 'px')
}
