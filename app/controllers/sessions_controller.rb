# This class is a rails controller for session objects
# Author::    Mark Grebe  
# Copyright:: Copyright (c) 2013 Mark Grebe
# License::   Distributes under the same terms as Ruby
# Developed for Master of Engineering Project
# University of Colorado - Boulder - Spring 2013
class SessionsController < ApplicationController
    def new

    end

    # Create a new user session
    def create
        user = User.find_by_username(params[:session][:username])
        if user && user.authenticate(params[:session][:password])
            sign_in user
            redirect_back_or user
        else
            flash.now[:error] = 'Invalid username/password combination'
            render 'new'
        end
    end

    # Delete an user session
    def destroy
        sign_out
        redirect_to root_url
    end
end
