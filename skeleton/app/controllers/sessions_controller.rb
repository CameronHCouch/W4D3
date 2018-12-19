class SessionsController < ApplicationController

before_action :check_logged_in?, only: [:new, :create]

    def new  
        @user = User.new
        render :new
    end

    def create
        user_name = params[:user][:user_name]
        password = params[:user][:password]
        @user = User.find_by_credentials(user_name, password)
        if @user
            session[:session_token] = @user.reset_session_token!
            redirect_to cats_url
        else
            flash.now[:errors] = ["invalid password"]
            render :new
        end
    end

   def destroy
        current_user.reset_session_token!
        session[:session_token] = nil
        redirect_to new_session_url
    end
  
  
end