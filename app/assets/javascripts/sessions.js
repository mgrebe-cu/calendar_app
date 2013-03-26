$(document).ready(function(){ 
     // Client side validation for signin form
    var signinValidator = $("#signin-form").validate({
        errorContainer: "#signin_errorbox",
        errorLabelContainer: "#signin_errorbox ul",
        wrapper: "li",
        rules: {
           "session[username]": {
                required:true
            },
           "session[password]": {
                required:true
            }
         },
         messages: {
           "session[username]": {
                required:"Username is required"
           },
           "session[password]": {
                required:"Password is required"
           }
       }
    });
}) ;
