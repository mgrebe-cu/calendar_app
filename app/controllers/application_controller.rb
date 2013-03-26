# This module is a rails controller for the calendar application
# Author::    Mark Grebe  
# Copyright:: Copyright (c) 2013 Mark Grebe
# License::   Distributes under the same terms as Ruby
# Developed for Master of Engineering Project
# University of Colorado - Boulder - Spring 2013
class ApplicationController < ActionController::Base
    before_filter :set_user_time_zone

    protect_from_forgery
    include SessionsHelper

private
    # Set the time zone for the user before access
    def set_user_time_zone
        Time.zone = current_user.time_zone if signed_in?
    end

end
