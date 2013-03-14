// Attach jQuery functions after document loads
$(document).ready(function(){ 
     // Client side validation for calendar form
    var calendarValidator = $("#calendar-form").validate({
        errorContainer: "#calendar_errorbox",
        errorLabelContainer: "#calendar_errorbox ul",
        wrapper: "li",
        rules: {
           "calendar[title]": {
                required:true
            }},
        messages: {
           "calendar[title]": "Title is required"
           }
    });
    // Clearing the calendar form for new calendar
    $("#new_calendar").click(function() {
        $('#calendar_title').val("");
        $('#calendar_description').val("");
        $('#calendar_color').val("0");
        calendarValidator.resetForm();
        calendarValidator.submit = {};
    });
    // Clear any validation warnings if the form is cancelled.
    $("#calendar_close").click(function() {
        calendarValidator.resetForm();
        calendarValidator.submit = {};
    });
}) ;

