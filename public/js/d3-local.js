let chartData
let exchanges
let maxPriceMin
let maxPriceMax
let timeMin
let x

function d3init(params) {
  console.log('d3init', 'params', params)
  chartData = []
  exchanges = []
  maxPriceMin = Number.MAX_SAFE_INTEGER
  maxPriceMax = 0
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
  let draw = d3.select('#draw')
  let drawbox = draw.select('rect')
  // let boundingRect = draw.node().getBoundingClientRect();
  let boundingRect = {width: drawbox.attr('width'),
                      height: drawbox.attr('height') }
  const radius = boundingRect.width * 0.003

  // iso8601 to js date
  data.date = new Date(data.date)
  // ignore the string-decimal format
  data.bids = data.bids.map(function(offer){return [ parseFloat(offer[0]), offer[1] ] })
  data.asks = data.asks.map(function(offer){return [ parseFloat(offer[0]), offer[1] ] })

  if(!exchanges.includes(data.exchange)) {
    exchanges.push(data.exchange)
  }

  chartData.push(data)

  const timeMax = chartData[0].date
  if (chartData.length == 1) {
    // one-shot time calcs
    timeMin =  new Date(timeMax - 1000*60*60*4) // fixed four hours
    x = d3.scaleTime()
      .domain([timeMin, timeMax])
      .range([0+radius, boundingRect.width-(radius*2)])

    // Populate the x-axis
    let timeFormatter = d3.timeFormat('%-I:%M %p')
    let dateFormatter = d3.timeFormat('%b %d')

    let xLabels = flatten([new Date(timeMin), x.ticks(4)])

    let xLabelData = d3
      .select('#xaxis')
      .selectAll('g')
        .data(xLabels, function(d){ return d} )

    xLabelData.exit().remove()
    var labelBar = xLabelData.enter()
                         .append('g')
                           .attr('transform', function(d,i){return 'translate('+x(d)+', 13)'})
    labelBar
          .append('text')
            .style('fill', '#333')
            .style('font-size', '14px')
            .style('font-family', 'Calibri, Candara, Arial, sans-serif')
            .style('font-weight', 300)
            .attr('y', 20)
            .text(function(d, i) {return i == xLabels.length-1 ? dateFormatter(d) : ''})
    labelBar
          .append('text')
            .style('fill', '#333')
            .style('font-size', '13px')
            .text(function(d) { return timeFormatter(d) })

  }

  const priceMax = data.asks[0][0]
  const priceMin = data.bids[0][0]

  let redraw = false
  if(maxPriceMax < priceMax) {
    maxPriceMax = priceMax * (1+0.005)
    redraw = true
  }
  if(maxPriceMin > priceMin) {
    maxPriceMin = priceMin * (1-0.005)
    redraw = true
  }


  const y = d3.scaleLinear()
    .domain([maxPriceMax, maxPriceMin])
    .range([0+(radius*3), boundingRect.height-(radius*3)]);

  const color = d3.scaleLinear()
    .domain([0, exchanges.length])
    .range(["blue", "yellow"])
    .interpolate(d3.interpolateHcl)

  // add new point
  const circleData = draw
    .selectAll('g.ob-parent')
    .data(chartData)

  const circleDataEnter = circleData.enter()

  // ask circle
  const circleGroup = circleDataEnter.append('g')
                                      .attr('class', 'ob-parent')
  circleGroup
    .append('circle')
      .attr('fill', '#eee')
      .attr('class', 'ob-ask')
      .attr('stroke', d3.hsl(color(exchanges.indexOf(data.exchange))))
      .attr('r', radius)
      .attr('data-exchange', data.exchange)
      .attr('cx', d => x(data.date))
      .attr('cy', d => y(data.asks[0][0]))
  circleGroup
    .append('circle')
      .attr('fill', '#eee')
      .attr('class', 'ob-bid')
      .attr('r', radius)
      .attr('stroke', d3.hsl(color(exchanges.indexOf(data.exchange))).darker(2))
      .attr('data-exchange', data.exchange)
      .attr('cx', d => x(data.date))
      .attr('cy', d => y(data.bids[0][0]))

  if(redraw) {
    // reposition/resize all points
    draw
      .selectAll('g')
        .select('circle.ob-ask')
          .attr('cy', d => y(d.asks[0][0]))

    draw
      .selectAll('g')
        .select('circle.ob-bid')
          .attr('cy', d => y(d.bids[0][0]))
  }

  let yLabels = flatten([maxPriceMin, y.ticks(2), maxPriceMax])

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
          .text(function(d) { return d.toFixed(4) })

  // Position the y-axis labels
  d3
    .select('#yaxis')
    .selectAll('text')
    .data(yLabels)
      .attr('x', 1)
      .attr('y', function(d,i){ return y(d)+radius})


  // populate the legend
  let legendData = d3
    .select('#chartZone .legend')
    .selectAll('li')
    .data(exchanges)

  legendData
    .enter()
      .append('li')
        .style('color', (d,i) => d3.hsl(color(i)))
        .text(e => e)
        .on("mouseover", d => {
          d3
            .selectAll('circle[data-exchange='+d+']')
              .attr('r', radius*1.5)
        })
        .on("mouseout", d => {
          d3
            .selectAll('circle[data-exchange='+d+']')
              .attr('r', radius)
        })
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


