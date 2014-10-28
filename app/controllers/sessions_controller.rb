class SessionsController < ApplicationController
  def new
    @session = Session.new
  end

  def create
    # Handle oauth callbacks
    unless params[:provider].nil?
      auth = env['omniauth.auth']
      # todo handle add account callbacks here
      if current_user.nil?
        # todo compare email addresses to add to an existing account
        user = User.new_from_omniauth(auth)
      else # user was already logged in
        user = current_user
        user.add_or_update_oauth_account(auth)
      end
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
