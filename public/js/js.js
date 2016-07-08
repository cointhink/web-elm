let chartData = []

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

  // iso8601 to js date
  data.date = new Date(data.date)
  data.bids = data.bids.map(function(offer){return [ parseFloat(offer[0]), offer[1] ] })
  console.log(data.date, data.bids[0])

  // todo: insert in-place
  console.log('push', data)
  chartData.push(data)
  chartData = chartData.sort(function(a, b) { return a.date > b.date })

  let chartDates = chartData.map(function(d){return d.date})
  let timeMax = Math.max(...chartDates)
  let timeMin = Math.min(...chartDates)

  let chartBidPrices = chartData.map(function(d){return d.bids[0][0]})
  let bidPriceMax = Math.max(...chartBidPrices)
  let bidPriceMin = Math.min(...chartBidPrices)
  console.log('bidPriceMin', bidPriceMin, 'bidPriceMax', bidPriceMax)

  let x = d3.scaleTime()
    .domain([new Date(timeMin), new Date(timeMax)])
    .range([0, boundingRect.width])

  let y = d3.scaleLinear()
    .domain([bidPriceMax, bidPriceMin])
    .range([0, boundingRect.height]);
  console.log('ymin', 0, 'ymax', boundingRect.height)

  chart
  .select('svg')
  .selectAll('line')
  .data(chartData)
  .enter()
    .append("line")
      .attr("stroke", "white")
      .attr("x1", 0)
      .attr("y1", boundingRect.height)
      .attr("x2", function(d){console.log('x', x(d.date));return x(d.date)})
      .attr("y2", function(d){console.log('y', y(d.bids[0][0]), d.bids[0][0]);return y(d.bids[0][0])})
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
