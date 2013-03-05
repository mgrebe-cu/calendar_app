  // $('.timepicker').timepicker({minuteStep: 5});

$(document).ready(function(){ 
    $('.day_cal_div').attr("scrollTop",200);
    $('.event-popover').popover();
    $('#event_start').timepicker({minuteStep: 5, defaultTime: '10:00 AM'});
    $('#event_end').timepicker({minuteStep: 5, defaultTime: '11:00 AM'});
    $('.datepicker').datepicker({autoclose: true, todayBtn: true});
    $('#event_start').change(function() {
        var hoursToAdd = 1;
        var oldTime = Date.parse('Jan 1, 2009 ' + $('#event_start').val());
        var newTime = new Date(oldTime + 1000 * 60 * 60 * hoursToAdd);
        var hours = newTime.getHours();
        var minutes = newTime.getMinutes();
        var designation = 'PM';
        if ((hours == 0 || hours == 24) && minutes == 0) 
            {
            hours = 12;
            designation = 'AM';
            }
        else if (hours == 12 && minutes == 0)
            {
            designation = 'PM';
            }
        else if (hours < 12)
            {
            designation = 'AM';
            }
        else
            {
            hours -= 12;
            }
        hours = (hours < 10) ? ("0" + hours) : hours;
        minutes = (minutes < 10) ? ("0" + minutes) : minutes;
        $('#event_end').val(hours + ':' + minutes + ' ' + designation);
    });

    $('#event_start_date').change(function() {
        $('#event_end_date').val($('#event_start_date').val());
    });
    $('#event_all_day').click(function() {
        if (!this.checked) {
            $('#event_start').attr('disabled',false);
            $('#event_end').attr('disabled',false);
        } else {
            $('#event_start').attr('disabled',true);
            $('#event_end').attr('disabled',true);
            $('#event_start').val('');
            $('#event_end').val('');
        }
    });

}) ;

