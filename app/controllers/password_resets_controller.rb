class PasswordResetsController < ApplicationController
  def new
    @password_reset = PasswordReset.new
  end

  def create
    @password_reset = PasswordReset.new(reset_params)
    if @password_reset.save
      redirect_to root_path, :notice => 'A password reset email has been sent to your registered email address'
    else
      flash.now[:error] = message = @password_reset.errors.full_messages.first
      render :new
    end
  end

  def edit
    @password_reset = PasswordReset.find(params[:id])
    if @password_reset.nil? || @password_reset.expired?
      flash[:error] = 'Password reset link expired'
      redirect_to root_path
    end
  end

  def update
    @password_reset = PasswordReset.find(params[:id])
    binding.pry
    if @password_reset.update_attributes(reset_params)
      self.current_user = @password_reset.epoch_user
      flash[:notice] = 'Password successfully changed'
      redirect_to root_path
    else
      flash.now[:error] = 'Password was not changed due to errors below'
      render 'edit'
    end
  end

  private
  def reset_params
    params.require(:password_reset).permit(:email, :password, :password_confirmation)
  end
end
