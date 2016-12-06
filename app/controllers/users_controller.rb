class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  rescue_from ActiveRecord::RecordNotFound, with: :deny_access
  rescue_from ActionView::MissingTemplate, with: :template_not_found

  def index

  end

  def create
    # Create the user from params
    @user = User.new(params[:user])
    if @user.save
      # Deliver the signup email
      UserNotifier.send_signup_email(@user).deliver
      redirect_to(@user, :notice => 'User created')
    else
      render :action => 'new'
    end
  end


  def show
    @user = User.find(params[:id])
  end

  def deny_access
    redirect_to :back
  rescue ActionController::RedirectBackError
    redirect_to root_path
  end

  def template_not_found
    redirect_to :back
  rescue ActionView::MissingTemplate
    redirect_to root_path
  end

end
