class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  rescue_from ActiveRecord::RecordNotFound, with: :deny_access

  def index

  end

  def show
    @user = User.find(params[:id])
  end

  def deny_access(default = root_url)
    if request.env["HTTP_REFERER"].present? and request.env["HTTP_REFERER"] != request.env["REQUEST_URI"]
      redirect_to :back, notice: 'Nothing happened.'
    else
      redirect_to default, notice: 'Nothing happened.'
    end
  end

end
