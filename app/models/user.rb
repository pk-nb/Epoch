class User < ActiveRecord::Base

  has_many :timelines
  has_many :events
  has_many :accounts
  has_many :twitter_friends

  # Create/initialize a new user from an oauth provider
  # If an account already exists with the provided email address, a new account will be created for the new provider
  def self.retrieve_or_create_from_omniauth(auth)
    user = Account.user_from_email(auth) || User.create
    user.update_with_remote_data(auth)
    user
  end

  # Add an oauth account for a new provider to an existing user
  # If the user already has an oauth account for this provider, the account will be updated instead of a new account being created
  def add_or_update_oauth_account(auth)
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

  def twitter_account
    self.accounts.find_by_provider('twitter')
  end

  # Get a list of auth providers for which this user has linked accounts
  # possible options are: github, google_oauth2, twitter, facebook, & Epoch
  def providers
    self.accounts.map{|a| a.provider}
  end
  
  def first_account
    self.accounts.sort_by {|a| a.date_added}.first
  end

  # Only give client what it needs to know
  def as_json(options={})
    options[:only] ||= []
    options[:methods] ||= [:name, :picture, :providers] #include results of name and picture methods
    super(options)
  end
end
