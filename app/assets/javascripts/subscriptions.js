// Attach jQuery functions after document loads
$(document).ready(function(){ 
     // Client side validation for subscription form
    var subscriptionValidator = $("#subscription-form").validate({
        errorContainer: "#subscription_errorbox",
        errorLabelContainer: "#subscription_errorbox ul",
        wrapper: "li",
        rules: {
           "subscription[title]": {
                required:true,
                remote: {
                    url: "/subscriptioncheck",
                    data: {
                        subcheck: function() {
                        return $('#subscription-form').attr('action');
                        }
                    }
                }
            }},
        messages: {
           "subscription[title]": {
                required:"Title is required",
                remote: "Calendar title is already in use"
           }}
    });

     // Client side validation for share form
    var shareValidator = $("#share-form").validate({
        errorContainer: "#share_errorbox",
        errorLabelContainer: "#share_errorbox ul",
        wrapper: "li",
        rules: {
           "subscription[username]": {
                required:true,
                remote: "/userverify"
                }
            },
        messages: {
           "subscription[username]": {
                required:"Title is required",
                remote: "Not a valid user"
           }}
    });

    // Clear any validation warnings if the form is cancelled.
    $("#subscription_close").click(function() {
        subscriptionValidator.resetForm();
        subscriptionValidator.submit = {};
    });

        // Clearing the calendar form for new calendar
    $("#new_calendar").click(function() {
        $('#calendar_title').val("");
        $('#calendar_description').val("");
        $('#calendar_color').val("0");
        $('#calendar_public').attr('checked', false);
        $('#calendar_model_title').text('Create Calendar');
        $('#calendar_shared').html("");
        calendarValidator.resetForm();
        calendarValidator.submit = {};
    });

    $("#share_save").click(function(event) {
        $("#shareModal").modal('hide');
    });
}) ;

