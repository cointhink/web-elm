
function d3init() {
  console.log('d3init')
  let chart = d3.select('#chart');
  chart.append('svg')

  resize(chart)

  d3.select(window).on("resize", function(){ resize(chart) })
}

function d3draw(data) {
  let chart = d3.select('#chart');
  let boundingRect = chart.node().getBoundingClientRect();

  chart
  .select('svg')
  .selectAll('line')
  .data([ [100,100],[100,200] ])
  .enter()
    .append("line")
      .attr("stroke", "white")
      .attr("x1", 0)
      .attr("y1", 0)
      .attr("x2", function(xy){console.log('new line x', xy);return xy[0]})
      .attr("y2", function(xy){console.log('new line y', xy);return xy[1]})
}

function resize(chart) {
  let aspect = 3

  // DIV size
  let boundingRect = chart.node().getBoundingClientRect();
  let aspectHeight = (boundingRect.width / aspect)

  chart.attr("width", boundingRect.width);
  chart.style("height", aspectHeight +"px");

  // SVG size
  let svg = chart.select("svg")
  svg.style('width', boundingRect.width + 'px')
     .style('height', aspectHeight + 'px')
}
