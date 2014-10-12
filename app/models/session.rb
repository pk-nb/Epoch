class Session
  include ActiveModel::Model
  attr_accessor :login, :password

  validates :login, :password, presence: true
  validate :credentials_valid

  def user
    @user ||= User.find_by_email(login.downcase)
  end

  private
  def credentials_valid
    if !self.user || !self.user.authenticate(password)
      errors.add(:base, 'Credentials are invalid')
    end
  end
end
