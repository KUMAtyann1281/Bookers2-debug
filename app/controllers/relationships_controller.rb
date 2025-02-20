class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    user = User.find(params[:user_id])
    current_user.follow(params[:user_id])
    redirect_to request.referer
  end

  def destroy
    user = User.find(params[:user_id])
    current_user.unfollow(params[:user_id])
    redirect_to request.referer
  end

  def followers
    user = User.find(params[:user_id])
    @users = user.followers
  end

  def following
    user = User.find(params[:user_id])
    @users = user.following
  end

end
