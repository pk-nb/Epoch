class UsersController < ApplicationController
  #before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    redirect_to user_path current_user
  end

  def show
    @user = current_user
  end

  # GET /users/new
  def new
    @user = User.new
    @account = Account.new
  end

  # GET /users/1/edit
  def edit
    if current_user.provider_is_epoch?
      @user = current_user
    else
      redirect_to root_path
    end
  end

  # POST /users
  def create
    @user = User.new()
    error = false
    if @user.save
      @account = @user.accounts.new(account_params.merge(provider: 'Epoch'))
      if @account.save
        self.current_user = @user
      else
        @user.destroy
        error = true
      end
    else
      error = true
    end

    unless error
      redirect_to root_path
    else
      flash.now[:error] = 'Unable to create account. Please correct the fields below'
      render :new
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
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

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    current_user.destroy
    respond_to do |format|
      format.html { redirect_to logout_path, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def account_params
      params.require(:account).permit(:name, :email, :password, :password_confirmation)
    end
end
