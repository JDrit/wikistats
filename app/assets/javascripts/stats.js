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
         $.getJSON('/api/page?page_title=' + title + '&callback=?', function(data) {
            count += 1;
            series[i] = {
                name: title,
                data: data,
                type: 'areaspline',
                dataGrouping: {
                    approximation: 'sum'  
                },
                gapSize: 5,
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
                    stops: [[0, Highcharts.getOptions().colors[0]], [1, Highcharts.Color(Highcharts.getOptions().colors[0]).setOpacity(0).get('rgba')]]
                },
                threshold: null
            };
            if (count == page_titles.length) {
                create_chart(series);
            }
         });
    });

    $("#group-by-hour").click(function(){
        //TODO update all series
        $("#view-graph").highcharts().series[0].update({
            dataGrouping: {
                units: [ ['hour', [1]] ]   
            }
        });
    });
    
    $("#group-by-day").click(function(){
        //TODO update all series
        $("#view-graph").highcharts().series[0].update({
            dataGrouping: {
                units: [ ['day', [1]] ]   
            }
        });
    });
    
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
