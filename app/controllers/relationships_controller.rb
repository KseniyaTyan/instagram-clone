class RelationshipsController < ApplicationController
    
    def create
       current_user.follow(params[:user_id])
    #   @user = User.find(params[:user_id])
       respond_to do |format|
           format.js
        end 
    end
    
    def destroy
        current_user.unfollow(params[:user_id])
        # @user = User.find(params[:user_id])
        respond_to do |format|
           format.js
       end
    end
end
