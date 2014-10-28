class SessionsController < ApplicationController
  def new
    @session = Session.new
  end

  def create
    # Handle oauth callbacks
    unless params[:provider].nil?
      user = User.from_omniauth(env['omniauth.auth'])
      session[:user_id] = user.id
      redirect_to root_path
    else
      @session = Session.new(session_params)
      if @session.valid? && @session.epoch_account
        self.current_user = @session.epoch_account.user
        redirect_to root_path
      else
        # todo This error isn't currently showing up on the form
        flash.now[:error] = 'The email or password is invalid'
        render :new
      end
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

  private
  def session_params
    params.require(:session).permit(:login, :password)
  end
end
