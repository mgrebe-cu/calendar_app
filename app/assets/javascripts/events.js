// ------------------------------------------------------------------
// getDateFromFormat( date_string , format_string )
//
// This function takes a date string and a format string. It matches
// If the date string matches the format string, it returns the 
// getTime() of the date. If it does not match, it returns 0.
// ------------------------------------------------------------------
function getDateFromFormat(val,format) {
    val=val+"";
    format=format+"";
    var i_val=0;
    var i_format=0;
    var c="";
    var token="";
    var token2="";
    var x,y;
    var now=new Date();
    var year=now.getYear();
    var month=now.getMonth()+1;
    var date=1;
    var hh=now.getHours();
    var mm=now.getMinutes();
    var ss=now.getSeconds();
    var ampm="";
    
    while (i_format < format.length) {
        // Get next token from format string
        c=format.charAt(i_format);
        token="";
        while ((format.charAt(i_format)==c) && (i_format < format.length)) {
            token += format.charAt(i_format++);
            }
        // Extract contents of value based on format token
        if (token=="yyyy" || token=="yy" || token=="y") {
            if (token=="yyyy") { x=4;y=4; }
            if (token=="yy")   { x=2;y=2; }
            if (token=="y")    { x=2;y=4; }
            year=_getInt(val,i_val,x,y);
            if (year==null) { return 0; }
            i_val += year.length;
            if (year.length==2) {
                if (year > 70) { year=1900+(year-0); }
                else { year=2000+(year-0); }
                }
            }
        else if (token=="MMM"||token=="NNN"){
            month=0;
            for (var i=0; i<MONTH_NAMES.length; i++) {
                var month_name=MONTH_NAMES[i];
                if (val.substring(i_val,i_val+month_name.length).toLowerCase()==month_name.toLowerCase()) {
                    if (token=="MMM"||(token=="NNN"&&i>11)) {
                        month=i+1;
                        if (month>12) { month -= 12; }
                        i_val += month_name.length;
                        break;
                        }
                    }
                }
            if ((month < 1)||(month>12)){return 0;}
            }
        else if (token=="EE"||token=="E"){
            for (var i=0; i<DAY_NAMES.length; i++) {
                var day_name=DAY_NAMES[i];
                if (val.substring(i_val,i_val+day_name.length).toLowerCase()==day_name.toLowerCase()) {
                    i_val += day_name.length;
                    break;
                    }
                }
            }
        else if (token=="MM"||token=="M") {
            month=_getInt(val,i_val,token.length,2);
            if(month==null||(month<1)||(month>12)){return 0;}
            i_val+=month.length;}
        else if (token=="dd"||token=="d") {
            date=_getInt(val,i_val,token.length,2);
            if(date==null||(date<1)||(date>31)){return 0;}
            i_val+=date.length;}
        else if (token=="hh"||token=="h") {
            hh=_getInt(val,i_val,token.length,2);
            if(hh==null||(hh<1)||(hh>12)){return 0;}
            i_val+=hh.length;}
        else if (token=="HH"||token=="H") {
            hh=_getInt(val,i_val,token.length,2);
            if(hh==null||(hh<0)||(hh>23)){return 0;}
            i_val+=hh.length;}
        else if (token=="KK"||token=="K") {
            hh=_getInt(val,i_val,token.length,2);
            if(hh==null||(hh<0)||(hh>11)){return 0;}
            i_val+=hh.length;}
        else if (token=="kk"||token=="k") {
            hh=_getInt(val,i_val,token.length,2);
            if(hh==null||(hh<1)||(hh>24)){return 0;}
            i_val+=hh.length;hh--;}
        else if (token=="mm"||token=="m") {
            mm=_getInt(val,i_val,token.length,2);
            if(mm==null||(mm<0)||(mm>59)){return 0;}
            i_val+=mm.length;}
        else if (token=="ss"||token=="s") {
            ss=_getInt(val,i_val,token.length,2);
            if(ss==null||(ss<0)||(ss>59)){return 0;}
            i_val+=ss.length;}
        else if (token=="a") {
            if (val.substring(i_val,i_val+2).toLowerCase()=="am") {ampm="AM";}
            else if (val.substring(i_val,i_val+2).toLowerCase()=="pm") {ampm="PM";}
            else {return 0;}
            i_val+=2;}
        else {
            if (val.substring(i_val,i_val+token.length)!=token) {return 0;}
            else {i_val+=token.length;}
            }
        }
    // If there are any trailing characters left in the value, it doesn't match
    if (i_val != val.length) { return 0; }
    // Is date valid for month?
    if (month==2) {
        // Check for leap year
        if ( ( (year%4==0)&&(year%100 != 0) ) || (year%400==0) ) { // leap year
            if (date > 29){ return 0; }
            }
        else { if (date > 28) { return 0; } }
        }
    if ((month==4)||(month==6)||(month==9)||(month==11)) {
        if (date > 30) { return 0; }
        }
    // Correct hours value
    if (hh<12 && ampm=="PM") { hh=hh-0+12; }
    else if (hh>11 && ampm=="AM") { hh-=12; }
    var newdate=new Date(year,month-1,date,hh,mm,ss);
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
    //Add method
    $.validator.addMethod("lowerTime", function(value, element, params) {
        var startString = params[0] + ' ' + value;
        var endString = params[1] + ' ' + params[2];
        var startDatetime = getDateFromFormat(startString,"M/d/y h:m a");
        var endDatetime = getDateFromFormat(endString,"M/d/y h:m a");
        return false; //startDatetime < endDatetime;
        }, $.validator.format("Start must be earlier than End")); 

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
            },
           "event[start_time]": {
                required:true,
                lowerTime:[4]
            },
           "event[end_time]": {
                required:true
            }},
        messages: {
           "event[title]": "Title is required",
           "event[start_date]": "Start Date is required",
           "event[end_date]": "End Date is required",
           "event[start_time]": "Start Time is required",
           "event[end_time]": "End Time is required"
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

