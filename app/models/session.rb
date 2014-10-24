class Session
  include ActiveModel::Model
  attr_accessor :login, :password

  validates :login, :password, presence: true
  validate :credentials_valid

  def epoch_user
    @user ||= User.find_by_email_and_provider(login.downcase, 'Epoch')
  end

  private
  def credentials_valid
    if !self.epoch_user || !self.epoch_user.authenticate(password)
      errors.add(:base, 'Credentials are invalid')
    end
  end
end
