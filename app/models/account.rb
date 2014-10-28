class Account < ActiveRecord::Base
  has_secure_password
  belongs_to :user

  validates :email, presence: true, uniqueness: {case_sensitive: false, scope: :provider},
            email: true, if: :provider_is_epoch?
  validates :password, length: { minimum: 8 }, if: :provider_is_epoch?
  validates_presence_of :name, :provider

  def self.user_from_omniauth(auth)
    account = find_by_provider_and_uid(auth.provider, auth.uid.to_s)
    if account.nil?
      nil
    else
      account.user
    end
  end

  def update_with_remote_data(auth)
    self.provider = auth.provider
    self.uid      = auth.uid.to_s
    self.name     = auth.info.name
    self.oauth_token = auth.credentials.token
    self.oauth_expires_at = auth.credentials.expires_at ?
        Time.at(auth.credentials.expires_at) :
        Time.new() + (60*60*24) # 1 day from present
    self.picture = auth.info.image || auth.extra.raw_info.avatar_url
    # todo test this against Facebook and Github...will need to do in production or modify our accounts
    self.email = auth.info.email # todo email things need checking
    self.password = 'testtest' # How to avoid password validation problems?
    self.login = auth.extra.raw_info.login
    save!
  end

  def provider_is_epoch?
    self.provider  == 'Epoch'
  end

  def add_reset_token
    self.password_reset_token = generate_token
    self.password_reset_sent_at = Time.zone.now
    save validate: false
  end

  def remove_reset_token
    self.password_reset_token = nil
    self.password_reset_sent_at = nil
    self.save validate: false
  end

  private
  def generate_token
    SecureRandom.urlsafe_base64
  end
end
