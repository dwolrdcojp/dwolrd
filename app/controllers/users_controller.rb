class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  rescue_from ActiveRecord::RecordNotFound, with: :deny_access

  def index

  end

  def show
    @user = User.find(params[:id])
  end

  def deny_access
    redirect_to :back, notice: 'Nothing happened.'
  end

end
