let chartData = []

function d3init() {
  console.log('d3init')
  let chart = d3.select('#chart');
  let svg = chart.append('svg')
  svg
    .append('g')
      .attr('id', 'draw')
      .append('rect')
        .attr('stroke', '#333')
        .attr('fill', '#eee')
  svg
    .append('g')
      .attr('id', 'yaxis')
      .append('rect')
        .attr('fill', 'white')
  svg
    .append('g')
      .attr('id', 'xaxis')
      .append('rect')
        .attr('fill', 'white')

  resize(chart)

  d3.select(window).on("resize", function(){ resize(chart) })
}

function d3draw(data) {
  // let svg = d3.select('svg');
  // let boundingRect = draw.node().getBoundingClientRect();
  let draw = d3.select('#draw')
  let drawbox = draw.select('rect')
  let boundingRect = {width: drawbox.attr('width'),
                      height: drawbox.attr('height') }

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

  let radius = boundingRect.width * 0.005

  let x = d3.scaleTime()
    .domain([new Date(timeMin), new Date(timeMax)])
    .range([0+radius, boundingRect.width-radius])

  let y = d3.scaleLinear()
    .domain([bidPriceMax, bidPriceMin])
    .range([0+radius+radius, boundingRect.height-radius]);

  // add new point
  draw
  .selectAll('circle')
  .data(chartData)
  .enter()
    .append('circle')
      .attr('stroke', 'blue')
      .attr('fill', '#eee')

  // reposition/resize all points
  draw
  .selectAll('circle')
  .data(chartData)
    .attr('r', radius)
    .attr('cx', calcx)
    .attr('cy', calcy)

  function calcx(d) {
    console.log('x', x(d.date))
    return x(d.date)
  }

  function calcy(d) {
    console.log('y', y(d.bids[0][0]), d.bids[0][0])
    return y(d.bids[0][0])
  }

  let yLabels = [bidPriceMax, bidPriceMin]
  // Populate the y-axis
  d3
    .select('#yaxis')
    .selectAll('text')
      .data(yLabels)
      .enter()
        .append('text')
          .style('fill', '#333')
          .style('font-size', '13px')
          .text(function(d) { return d })

  // Position the members
  d3
    .select('#yaxis')
    .selectAll('text')
    .data(yLabels)
      .attr('x', 1)
      .attr('y', function(d,i){return y(d)+radius})


  let timeFormatter = d3.timeFormat('%I:%M:%S %p')
  let dateFormatter = d3.timeFormat('%d/%m')

  let xLabels = [new Date(timeMin), new Date(timeMax)]
  console.log('xLabels', xLabels)
  // Populate the x-axis
  let xLabel = d3
    .select('#xaxis')
    .selectAll('text')
      .data(xLabels)

  var labelBar = xLabel.enter()
                       .append('g')
  labelBar
        .append('text')
          .style('fill', '#333')
          .style('font-size', '14px')
          .style('font-family', 'Calibri, Candara, Arial, sans-serif')
          .style('font-weight', 300)
          .attr('y', 20)
          .text(function(d) { return dateFormatter(d) })
  labelBar
        .append('text')
          .style('fill', '#333')
          .style('font-size', '13px')
          .text(function(d) { return timeFormatter(d) })

  // Position the members
  d3
    .select('#xaxis')
    .selectAll('g')
    .data(xLabels)
      .attr('transform', function(d,i){return 'translate('+x(d)+', 10)'})

}

function resize(chart) {
  let aspect = 3

  // DIV size DOM style
  let boundingRect = chart.node().getBoundingClientRect();
  let aspectHeight = (boundingRect.width / aspect)

  chart.style("width", boundingRect.width);
  chart.style("height", aspectHeight +"px");

  // SVG size *DOM style*
  let svg = chart.select("svg")
  svg.style('width', boundingRect.width + 'px')
     .style('height', aspectHeight + 'px')

  // set draw area size
  let drawWidth = boundingRect.width * 0.9
  let drawHeight = aspectHeight * 0.9
  let draw = chart.select("#draw")
  draw
    .select('rect')
      .attr('width', drawWidth)
      .attr('height', drawHeight)

  // set yaxis legend size
  let yAxisWidth = boundingRect.width * 0.1
  let yAxis = chart.select("#yaxis")
  yAxis
     .attr('transform', function(d) {
       return 'translate(' + drawWidth + ')';
     })
    .select('rect')
      .attr('width', yAxisWidth)
      .attr('height', aspectHeight)

  // set xaxis legend size
  let xAxisWidth = boundingRect.width
  let xAxisHeight = aspectHeight * 0.1
  let xAxis = chart.select("#xaxis")
  xAxis
    .attr('transform', function(d) {
      return 'translate(0,' + drawHeight + ')';
    })
    .select('rect')
      .attr('width', xAxisWidth)
      .attr('height', xAxisHeight)
}
