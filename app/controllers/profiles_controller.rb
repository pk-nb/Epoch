class ProfilesController < ApplicationController
  def show
    @profile = current_user.profile
  end

  def edit
    @profile = current_user.profile
  end

  def update
    current_user.profile.update!(profile_params)
    redirect_to current_user.profile
  end

  private
  def profile_params
    params.require(:profile).permit(:first_name, :last_name, :email, :favorite_cake)
  end
end
