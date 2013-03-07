$(document).ready(function(){ 
    var settingsValidator = $("#settings-form").validate({
        errorContainer: "#settings_errorbox",
        errorLabelContainer: "#settings_errorbox ul",
        wrapper: "li",
        rules: {
           "user[full_name]": {
                required:true,
                maxlength: 50
            }},
         messages: {
           "user[full_name]": {
                required:"Full Name is required",
                maxlength:"Full Name must be less than 50 characters"
           }}
    });

    $.validator.addMethod("validPassword", function(value) {
        var passRe = /^.*(?=.*\d)(?=.*[a-zA-Z]).*$/;
        return myRe.test(value);
        }, $.validator.format("Password must contain a letter and a number")); 

    var passwordValidator = $("#password-form").validate({
        errorContainer: "#password_errorbox",
        errorLabelContainer: "#password_errorbox ul",
        wrapper: "li",
        rules: {
           "user[password]": {
                required:true,
                //minlength: 6,
                maxlength: 20,
                validPassword: true
            },
           "user[password_confirmation]": {
                required:true,
                equalTo: $("#user_password")
            }
         },
         messages: {
           "user[password]": {
                required:"Password is required",
                minlength:"Password must be greater than 6 characters",
                maxlength:"Password must be less than 20 characters",
                validPassword:"Password must contain a letter and a number"
           },
           "user[password_confirmation]": {
                required:"Password Confirmation is required",
                equalTo:"Password and Password Confirmation must match"
           }
       }
    });
}) ;
