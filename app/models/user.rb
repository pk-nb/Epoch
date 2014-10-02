class User < ActiveRecord::Base
  has_many :timelines
  has_many :events

  def self.from_omniauth(auth)
   where(provider: auth.provider, uid: auth.uid.to_s).first_or_initialize.tap do |user|
     user.update_with_remote_data(user, auth)
   end
  end

  def update_with_remote_data(user, auth)
    user.provider = auth.provider
    user.uid      = auth.uid.to_s
    user.name     = auth.info.name
    user.oauth_token = auth.credentials.token
    user.oauth_expires_at = auth.credentials.expires_at ?
        Time.at(auth.credentials.expires_at) :
        Time.new() + (60*60*24) # 1 day
    user.picture = auth.info.image || auth.extra.raw_info.avatar_url
    user.save!
  end
end
