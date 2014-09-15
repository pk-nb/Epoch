class User < ActiveRecord::Base

  def self.from_omniauth(auth)
   where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
     user.update_with_remote_data(user, auth)
   end
  end

  def update_with_remote_data(user, auth)
    user.provider = auth.provider
    user.uid      = auth.uid
    user.name     = auth.info.name
    user.oauth_token = auth.credentials.token
    user.oauth_expires_at = Time.at(auth.credentials.expires_at)
    user.picture = auth.info.image
    user.save!
  end
end
