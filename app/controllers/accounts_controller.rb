class AccountsController < ApplicationController
  #before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    redirect_to user_path current_user
  end

  def new
    @account = Account.new
  end

  def edit
    unless current_user.epoch_account.nil?
      @account = current_user.epoch_account
    else
      redirect_to root_path
    end
  end

  # POST /users
  def create
    @account = current_user.accounts.new(account_params.merge(provider: 'Epoch'))
    if @account.save
      self.current_user = @account.user
      redirect_to root_path
    else
      flash.now[:error] = 'Unable to create account. Please correct the fields below'
      render :new
    end
  end
  #TODO FIXME
  def update
    @user = current_user
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  # TODO FIX ME
  def destroy
    current_user.destroy
    binding.pry
    respond_to do |format|
      format.html { redirect_to logout_path, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def account_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
