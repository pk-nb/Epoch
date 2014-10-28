class User < ActiveRecord::Base
  has_secure_password

  has_many :timelines
  has_many :events
  has_one :profile

  validates :email, presence: true, uniqueness: {case_sensitive: false},
            email: true, if: :provider_is_epoch?
  validates :password, length: { minimum: 8 }, if: :provider_is_epoch?
  validates_presence_of :name

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
        Time.new() + (60*60*24) # 1 day from present
    user.picture = auth.info.image || auth.extra.raw_info.avatar_url
    # todo test this against Facebook and Github...will need to do in production or modify our accounts
    user.email = auth.info.email # todo email things need work
    user.password = 'testtest' # How to avoid password validation problems?
    user.profile ||= Profile.new()
    user.save!
  end

  def add_reset_token
    self.password_reset_token = generate_token
    self.password_reset_sent_at = Time.zone.now
    save validate: false
  end

  def provider_is_epoch?
    self.provider  == 'Epoch'
  end


  def remove_reset_token
    self.password_reset_token = nil
    self.password_reset_sent_at = nil
    save validate: false
  end

  # Only give client what it needs to know
  def as_json(options={})
    options[:only] ||= [:name, :picture]
    super(options)
  end

  private
  def generate_token
    SecureRandom.urlsafe_base64
  end
end
