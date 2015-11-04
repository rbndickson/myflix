class RelationshipsController < ApplicationController
  before_action :require_user

  def index
    @relationships = current_user.leaders
  end

  def create
    other_user = User.find(params[:id])

    if current_user.can_follow?(other_user)
      current_user.follow!(other_user)
      flash[:success] = "You have followed #{other_user.full_name}"
      redirect_to people_path
    else
      redirect_to root_path
    end
  end

  def destroy
    other_user = User.find(params[:id])
    current_user.unfollow!(other_user)
    flash[:info] = "You have unfollowed #{other_user.full_name}"
    redirect_to people_path
  end
end
