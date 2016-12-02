class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  rescue_from ActiveRecord::RecordInvalid, with: :deny_access

  def index
    redirect_to :back
  end

  def show
    @user = User.find(params[:id])
  end

end
