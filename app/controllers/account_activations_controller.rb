class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    check_to_active user
  end

  def check_to_active user
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.update_attribute activated: true, activated_at: Time.zone.now
      log_in user
      flash[:success] = t("static_pages.home.acc_active")
      redirect_to user
    else
      flash[:danger] = t("static_pages.home.invalid_active")
      redirect_to root_url
    end
  end
end
