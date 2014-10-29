class PasswordReset
  include ActiveModel::Model
  attr_accessor :email, :password
  attr_writer :user

  validates :email, email: true, if: :new_record?
  validates :password, length: {minimum: 8}, confirmation: true, unless: :new_record?
  validate :user_exists

  def user
    @user ||= user_from_email
  end

  def save
    valid? && user.epoch_account.add_reset_token && deliver_email
  end

  def self.find(token)
    return nil if token.blank?
    user = Account.find_by(password_reset_token: token).user
    user.present? ? new(user: user) : nil
  end

  def attributes=(attributes)
    attributes.each{|k,v| send("#{k}=", v) }
  end

  def update_attributes(attributes)
    self.attributes = attributes
    valid? && update_user
  end

  def expired?
    user.epoch_account.password_reset_sent_at.nil? ||
        user.epoch_account.password_reset_sent_at <= 2.hours.ago
  end

  def update_user
    if user.epoch_account.
        update_attributes(password: password, password_confirmation: password_confirmation)
      user.epoch_account.remove_reset_token
      true
    else
      false
    end
  end

  private
  def user_exists
    errors.add(:user, 'not found') unless user.present?
  end

  def user_from_token
    account = Account.find_by(password_reset_token: token) if token.present? else nil
    account.nil? ? nil : account.user
  end

  def user_from_email
    account = Account.find_by_email_and_provider(email, 'Epoch') if email.present? else nil
    account.nil? ? nil : account.user
  end

  def new_record?
    @user.blank?
  end

  def deliver_email
    UserMailer.password_reset(user).deliver
  end
end
