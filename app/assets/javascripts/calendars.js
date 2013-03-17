// Attach jQuery functions after document loads
$(document).ready(function(){ 
     // Client side validation for calendar form
    var calendarValidator = $("#calendar-form").validate({
        errorContainer: "#calendar_errorbox",
        errorLabelContainer: "#calendar_errorbox ul",
        wrapper: "li",
        rules: {
           "calendar[title]": {
                required:true,
                remote: {
                    url: "/calendarcheck",
                    data: {
                        calcheck: function() {
                        return $('#calendar-form').attr('action');
                        }
                    }
                }
            }},
        messages: {
           "calendar[title]": {
                required:"Title is required",
                remote: "Calendar title is already in use"
           }}
    });

    // Clearing the calendar form for new calendar
    $("#new_calendar").click(function() {
        $('#calendar_title').val("");
        $('#calendar_description').val("");
        $('#calendar_color').val("0");
        $('#calendar_public').attr('checked', false);
        calendarValidator.resetForm();
        calendarValidator.submit = {};
    });
    // Clear any validation warnings if the form is cancelled.
    $("#calendar_close").click(function() {
        calendarValidator.resetForm();
        calendarValidator.submit = {};
    });
}) ;

