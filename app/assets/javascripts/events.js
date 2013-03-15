// ------------------------------------------------------------------
// getDateFromFormat( date_string , format_string )
//
// This function takes a date string in format:
//   MM/DD/YYYY hh:mm aa
// and converts it to a date, then returns the getTime() of the date.
// ------------------------------------------------------------------
function getDate(val) {
    var month;
    var day;
    var year;
    var hh;
    var mm;
    var ampm;

    if (val.length !== 19 ){
        return 0;
    }

    month = parseInt(val.substring(0,2));
    day = parseInt(val.substring(3,5));
    year = parseInt(val.substring(6,10));
    hh = parseInt(val.substring(11,13));
    mm = parseInt(val.substring(14,16));
    ampm = val.substring(17,19);
    console.debug(month, day, year, hh, mm, ampm);
    // Correct hours value
    if (hh<12 && ampm=="PM") { hh=hh-0+12; }
    else if (hh>11 && ampm=="AM") { hh-=12; }
    var newdate=new Date(year,month-1,day,hh,mm,0);
    return newdate.getTime();
}
// Attach jQuery functions after document loads
$(document).ready(function(){ 
    var DEFAULT_START_TIME = '10:00 AM';
    var DEFAULT_END_TIME = '11:00 AM';
    // Enable bootstrap popovers
    $('.event-popover').popover();
    // Set the time fields to be time pickers
    $('#event_start_time').timepicker({minuteStep: 5, defaultTime: DEFAULT_START_TIME});
    $('#event_end_time').timepicker({minuteStep: 5, defaultTime: DEFAULT_END_TIME});
    // Set the date fields to be date pickers
    $('.datepicker').datepicker({autoclose: true, todayBtn: true});
    // Set end time to an hour after start time when exiting start time
    $('#event_start_time').change(function() {
        var hoursToAdd = 1;
        var oldTime = Date.parse('Jan 1, 2009 ' + $('#event_start_time').val());
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
        $('#event_end_time').val(hours + ':' + minutes + ' ' + designation);
    });
    $('#event_start_date').change(function() {
        $('#event_end_date').val($('#event_start_date').val());
    });
    // En/Disable start/end time based on state of All Day checkbox
    $('#event_all_day').click(function() {
        if (!this.checked) {
            $('#event_start_time').attr('disabled',false);
            $('#event_end_time').attr('disabled',false);
        } else {
            $('#event_start_time').attr('disabled',true);
            $('#event_end_time').attr('disabled',true);
            $('#event_start_time').val('');
            $('#event_end_time').val('');
        }
    });
    // Set scroll bar position in day view to start at 8am
    $('.day_div').scrollTop(340);
    // Client side validation for event form
    // Add method
    $.validator.addMethod("lowerTime", function(value) {
        var startDateString = $("#event_start_date").val();
        var endDateString = $("#event_end_date").val();
        var startTimeString = $("#event_start_time").val();
        var endTimeString = $("#event_end_time").val();
        if (endTimeString.length != 8 || startDateString.length != 10 ||
            endDateString.length != 10 || 
            startTimeString.length != 8) {
            console.debug("Ratsss");
            return false;
        }
        var startString = startDateString + ' ' + startTimeString;
        var endString = endDateString + ' ' + endTimeString;
        var startDatetime = getDate(startString);
        var endDatetime = getDate(endString);
        console.debug(startDatetime < endDatetime);
        return startDatetime < endDatetime;
        }, $.validator.format("End Date/Time must be later than Start Date/Time")); 

    var eventValidator = $("#event-form").validate({
        errorContainer: "#event_errorbox",
        errorLabelContainer: "#event_errorbox ul",
        wrapper: "li",
        rules: {
           "event[title]": {
                required:true
            },
           "event[start_date]": {
                required:true,
                lowerTime:true
           },
           "event[end_date]": {
                required:true,
                lowerTime:true
           },
           "event[start_time]": {
                required:true,
                lowerTime:true
            },
           "event[end_time]": {
                required:true,
                lowerTime:true
            }},
        messages: {
           "event[title]": {
                required:"Title is required"
            },
           "event[start_date]": {
                required:"Start Date is required"
            },
           "event[end_date]": {
                required:"End Date is required"
            },
           "event[start_time]": {
                required:"Start Time is required"
            },
           "event[end_time]": {
                required:"End Time is required"
            }
            }
    });

    // Clearing the event form for new event
    $("#new_event").click(function() {
        $('#event_title').val("");
        $('#event_location').val("");
        $('#event_calendar_id').val("0");
        $('#event_start_date').val("");
        $('#event_end_date').val("");
        $('#event_all_day').attr('checked', false);
        $('#event_start_time').attr('enabled',true);
        $('#event_end_time').attr('enabled',true);
        $('#event_start_time').val(DEFAULT_START_TIME);
        $('#event_end_time').val(DEFAULT_END_TIME);
        $('#message_area').val("");
        eventValidator.resetForm();
        eventValidator.submit = {};
    });
    // Clear any validation warnings if the form is cancelled.
    $("#event_close").click(function() {
        eventValidator.resetForm();
        eventValidator.submit = {};
    });
}) ;

