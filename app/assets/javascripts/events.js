$(document).ready(function(){ 
    // Enable bootstrap popovers
    $('.event-popover').popover();
    // Set the time fields to be time pickers
    $('#event_start_time').timepicker({minuteStep: 5, defaultTime: '10:00 AM'});
    $('#event_end_time').timepicker({minuteStep: 5, defaultTime: '11:00 AM'});
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
    $('.day_div').scrollTop(340);
    // Client side validation for event form
    var eventValidator = $("#event-form").validate({
        errorContainer: "#event_errorbox",
        errorLabelContainer: "#event_errorbox ul",
        wrapper: "li",
        rules: {
           "event[title]": {
                required:true
            },
           "event[start_date]": {
                required:true
            },
           "event[end_date]": {
                required:true
            }},
        messages: {
           "event[title]": "Title is required",
           "event[start_date]": "Start Date is required",
           "event[end_date]": "End Date is required"
            }
    });
    // Clearing the event form for new event
    $("#new_event").click(function() {
        $('#event_title').val("");
        $('#event_location').val("");
        $('#event_start_date').val("");
        $('#event_end_date').val("");
        $('#event_all_day').attr('checked', false);
        $('#event_start_time').attr('enabled',true);
        $('#event_end_time').attr('enabled',true);
        //$('#event_start_time').val("");
        //$('#event_end_time').val("");
        $('#message_area').val("");
        eventValidator.resetForm();
        eventValidator.submit = {};
    });

}) ;

