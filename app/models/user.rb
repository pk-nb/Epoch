class User < ActiveRecord::Base

  has_many :timelines
  has_many :events
  has_many :accounts

  # Create/initialize a new user from an oauth provider
  def self.from_omniauth(auth)
    user = Account.user_from_omniauth(auth) || User.create
    user.update_with_remote_data(auth)
    user
  end

  # Add an oauth account for a new provider to an existing user
  def add_oauth_account(auth)
    update_with_remote_data(auth)
  end

  def update_with_remote_data(auth)
    account = self.accounts.find_by_provider(auth.provider) || self.accounts.new
    account.update_with_remote_data(auth)
  end

  def name
    first_account.name
  end

  def picture
    first_account.picture
  end

  def email
    first_account.email
  end

  def epoch_account
    @epoch_account ||= self.accounts.find_by_provider('Epoch')
  end

  def github_account
    self.accounts.find_by_provider('github')
  end

  def first_account
    self.accounts.sort_by {|a| a.date_added}.first
  end

end
