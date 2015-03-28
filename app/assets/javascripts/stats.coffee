$ ->
  $.getJSON '/api/page/' + document.getElementById("page_title").textContent + '?callback=?', (data) ->
    # create the chart
    $('#container').highcharts 'StockChart',
      title: text: 'Page views by the hour'
      subtitle: text: 'source: Wikipedia page views'
      xAxis: gapGridLineWidth: 0
      yAxis: min: 0
      rangeSelector:
        buttons: [
          {
            type: 'week'
            count: 1
            text: '1W'
          }
          {
            type: 'month'
            count: 1
            text: '1M'
          }
          {
            type: 'month'
            count: 3
            text: '3M'
          }
          {
            type: 'all'
            count: 1
            text: 'All'
          }
        ]
        selected: 3
        inputEnabled: false
      series: [ {
        name: document.getElementById("page_title").textContent
        type: 'areaspline'
        data: data
        gapSize: 5
        tooltip: valueDecimals: 0
        fillColor:
          linearGradient:
            x1: 0
            y1: 0
            x2: 0
            y2: 2
          stops: [
            [
              0
              Highcharts.getOptions().colors[0]
            ]
            [
              1
              Highcharts.Color(Highcharts.getOptions().colors[0]).setOpacity(0).get('rgba')
            ]
          ]
        threshold: null
      } ]
    return
  return
