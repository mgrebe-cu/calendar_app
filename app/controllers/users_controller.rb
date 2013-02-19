class UsersController < ApplicationController
    before_filter :signed_in_user, 
                only: [:edit, :show, :update]
    before_filter :correct_user,   
                only: [:edit, :show, :update]

    def new
        @user = User.new
    end

    def show
        @user = User.find(params[:id])
    end

    def create
        @user = User.new(params[:user])
        if @user.save
            sign_in @user
            flash[:success] = "Welcome to Calendaring!"
            redirect_to @user
        else
            render 'new'
        end
    end

    def edit
    end

    def update
        params[:user].each do |name, value|
            @user.update_column(name, value)
        end
        flash[:success] = "Settings updated"
        redirect_to @user
    end

  private

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

end
