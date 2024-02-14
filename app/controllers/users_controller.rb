class UsersController < ApplicationController
    def show
        @user = current_user
        puts "Current User ID: #{@user.id}" if @user
        @events = @user.created_events
    end

end
