class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def hello
    render html: "D-WOLRD: POWER SHOP"
  end
end
