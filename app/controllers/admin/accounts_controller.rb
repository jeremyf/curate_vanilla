class Admin::AccountsController < ApplicationController
  with_themed_layout('1_column')

  def index
    @users = User.search(params[:q]).page(params[:page])
  end


  def toggle_approval
    user = User.find(params[:id])
    user.toggle!(:approved)
    flash[:notice] = "#{user.email} is now #{user.approved? ? 'approved' : 'not approved'} to use the application."
    redirect_to :back
  end

end