class SessionsController < ApplicationController
  def new
    @session = Session.new
  end

  def create
    unless params[:provider].nil?
      user = User.from_omniauth(env['omniauth.auth'])
      session[:user_id] = user.id
    else
      @session = Session.new(session_params)
      if @session.valid?
        self.current_user = @session.user
        redirect_to root_path
      else
        # todo how do I make this error show up?
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
