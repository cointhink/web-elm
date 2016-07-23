let chartData = []
let exchanges = []

function d3init(params) {
  console.log('d3init', 'params', params)
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
  // ignore the string-decimal format
  data.bids = data.bids.map(function(offer){return [ parseFloat(offer[0]), offer[1] ] })
  data.asks = data.asks.map(function(offer){return [ parseFloat(offer[0]), offer[1] ] })

  if(!exchanges.includes(data.exchange)) {
    exchanges.push(data.exchange)
  }

  console.log('plot', data.exchange, data.date, data.market.base, data.market.quote,
    data.bids[0][0], data.asks[0][0])
  // todo: insert in-place
  chartData.push(data)
  chartData = chartData.sort(function(a, b) { return a.date > b.date })

  const timeMin = chartData[0].date
  const timeMax = chartData[chartData.length-1].date

  const chartBidPrices = chartData.map(function(d){return d.bids[0][0]})
  const bidPriceMax = Math.max(...chartBidPrices)
  const bidPriceMin = Math.min(...chartBidPrices)

  const chartAskPrices = chartData.map(function(d){return d.asks[0][0]})
  const askPriceMax = Math.max(...chartAskPrices)
  const askPriceMin = Math.min(...chartAskPrices)

  const priceMax = Math.max(bidPriceMax, askPriceMax)
  const priceMin = Math.min(bidPriceMin, askPriceMin)

  const radius = boundingRect.width * 0.003

  const x = d3.scaleTime()
    .domain([new Date(timeMin), new Date(timeMax)])
    .range([0+radius, boundingRect.width-radius])

  const y = d3.scaleLinear()
    .domain([priceMax, priceMin])
    .range([0+(radius*3), boundingRect.height-radius]);

  const color = d3.scaleLinear()
    .domain([0, exchanges.length])
    .range(["blue", "yellow"])
    .interpolate(d3.interpolateHcl)

  // add new point
  const circleData = draw
    .selectAll('circle')
    .data(chartData)

  const circleDataEnter = circleData.enter()

  // ask circle
  circleDataEnter
    .append('circle')
      .attr('fill', '#eee')
      .attr('class', 'ob-ask')

  // bid circle
  circleDataEnter
    .append('circle')
      .attr('fill', '#eee')
      .attr('class', 'ob-bid')

  // reposition/resize all points
  circleData
    .attr('r', radius)

  draw
  .selectAll('circle.ob-ask')
    .attr('cx', d => x(d.date))
    .attr('cy', d => y(d.asks[0][0]))
    .attr('stroke', d => d3.hsl(color(exchanges.indexOf(d.exchange))))

  draw
  .selectAll('circle.ob-bid')
    .attr('cx', d => x(d.date))
    .attr('cy', d => y(d.bids[0][0]))
    .attr('stroke', d => d3.hsl(color(exchanges.indexOf(d.exchange))).darker(2))

  let yLabels = flatten([priceMin, y.ticks(2), priceMax])

  // Populate the y-axis
  let yLabelData = d3
    .select('#yaxis')
    .selectAll('text')
      .data(yLabels, function(d){return d})

  yLabelData.exit().remove()
  yLabelData
      .enter()
        .append('text')
          .style('fill', '#333')
          .style('font-size', '13px')
          .text(function(d) { return d })

  // Position the y-axis labels
  d3
    .select('#yaxis')
    .selectAll('text')
    .data(yLabels)
      .attr('x', 1)
      .attr('y', function(d,i){ return y(d)+radius})


  let timeFormatter = d3.timeFormat('%I:%M %p')
  let dateFormatter = d3.timeFormat('%d/%m')

  let xLabels = flatten([new Date(timeMin), x.ticks(3), new Date(timeMax)])

  // Populate the x-axis
  let xLabelData = d3
    .select('#xaxis')
    .selectAll('g')
      .data(xLabels, function(d){ return d} )

  xLabelData.exit().remove()
  var labelBar = xLabelData.enter()
                       .append('g')
  labelBar
        .append('text')
          .style('fill', '#333')
          .style('font-size', '14px')
          .style('font-family', 'Calibri, Candara, Arial, sans-serif')
          .style('font-weight', 300)
          .attr('y', 20)
          .text(function(d) {return dateFormatter(d) })
  labelBar
        .append('text')
          .style('fill', '#333')
          .style('font-size', '13px')
          .text(function(d) { return timeFormatter(d) })

  // Rebind the x-axis labels to include the new member, then position the members
  d3
    .select('#xaxis')
    .selectAll('g')
    .data(xLabels)
      .attr('transform', function(d,i){console.log('xtrans', x(d), d); return 'translate('+x(d)+', 10)'})

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

function flatten(arr) {
  return arr.reduce(function (flat, toFlatten) {
    return flat.concat(Array.isArray(toFlatten) ? flatten(toFlatten) : toFlatten);
  }, []);
}
