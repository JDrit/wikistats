$(function() {
    
    var create_chart = function(series) {
        $('#view-graph').highcharts('StockChart', {
            title: {
                text: 'Page views by the hour'
            },
            subtitle: {
                text: 'source: Wikipedia page views'
            },
            xAxis: {
                gapGridLineWidth: 0
            },
            yAxis: {
                min: 0
            },
            rangeSelector: {
                buttons: [
                    {
                        type: 'week',
                        count: 1,
                        text: '1W'
                    }, {
                        type: 'month',
                        count: 1,
                        text: '1M'
                    }, {
                        type: 'month',
                        count: 3,
                        text: '3M'
                    }, {
                        type: 'all',
                        count: 1,
                        text: 'All'
                    }
                ],
                selected: 3,
                inputEnabled: false
            },
            legend: {
                enabled: true    
            },
            series: series
        });     
    }

    var series = [];
    var count = 0;

    $.each(page_titles, function(i, title) {
         $.getJSON('/api/page/' + encodeURIComponent(title).replace(/[!'()]/g, escape).replace(/\*/g, "%2A") + '?callback=?', function(data) {
            count += 1;
            series[i] = {
                name: decodeURIComponent(title).replace(/_/g, " "),
                data: data,
                type: 'areaspline',
                dataGrouping: {
                    approximation: 'sum'  
                },
                gapSize: 0,
                tooltip: {
                    valueDecimals: 0
                },
                fillColor: {
                    linearGradient: {
                        x1: 0,
                        y1: 0,
                        x2: 0,
                        y2: 1
                    },
                    stops: [[0, Highcharts.getOptions().colors[i]], [1, Highcharts.Color(Highcharts.getOptions().colors[i]).setOpacity(0).get('rgba')]]
                },
                threshold: null
            };
            if (count == page_titles.length) {
                create_chart(series);
            }
         });
    });
    
    $("#group-none").click(function(){
        var series_length = $("#view-graph").highcharts().series.length;
        for (var i = 0 ; i < series_length ; i++) {
            $("#view-graph").highcharts().series[i].update({
                dataGrouping: {
                    enabled: false
                }
            });
        }
    });
    $("#group-month").click(function(){
        var series_length = $("#view-graph").highcharts().series.length;
        for (var i = 0 ; i < series_length ; i++) {
            $("#view-graph").highcharts().series[i].update({
                dataGrouping: {
                    enabled: true,
                    forced: true,
                    units: [ ['month', [1]] ]   
                }
            });
        }
    });
    
    $("#group-day").click(function(){
        var series_length = $("#view-graph").highcharts().series.length;
        for (var i = 0 ; i < series_length ; i++) {
            $("#view-graph").highcharts().series[i].update({
                dataGrouping: {
                    enabled: true,
                    forced: true,
                    units: [ ['day', [1]] ]   
                }
            });
        }
     });    
    
    // for the page selector
    $(document).on('click', '.btn-add', function(e) {
        e.preventDefault();

        var controlForm = $('.controls form:first'),
            currentEntry = $(this).parents('.entry:first'),
            newEntry = $(currentEntry.clone()).appendTo(controlForm);

        newEntry.find('input').val('');
        controlForm.find('.entry:not(:last) .btn-add')
            .removeClass('btn-add').addClass('btn-remove')
            .removeClass('btn-success').addClass('btn-danger')
            .html('<span class="glyphicon glyphicon-minus"></span>');
    }).on('click', '.btn-remove', function(e) {
		$(this).parents('.entry:first').remove();
		e.preventDefault();
		return false;
	});
});
