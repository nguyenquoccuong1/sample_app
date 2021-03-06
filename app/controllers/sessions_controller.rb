class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase
    if user && user.authenticate(params[:session][:password])
      check_activated user
    else
      flash.now[:danger] = t("static_pages.home.mess_danger")
      render :new
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

  def check_remember user
    params[:session][:remember_me] == Settings.check_remember ? remember(user) : forget(user)
  end

  def check_activated user
    if user.activated?
      log_in user
      check_remember user
      redirect_back_or user
    else
      flash[:warning] = t("static_pages.home.acc_not_active")
      redirect_to root_url
    end
  end
end
