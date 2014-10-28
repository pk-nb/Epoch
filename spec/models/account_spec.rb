require 'rails_helper'

RSpec.describe Account, :type => :model do
  describe 'oauth accounts' do
    before do
      @user = User.create()
    end

    it 'should not allow duplicate email addresses' do
      account1 = @user.accounts.create(FactoryGirl.attributes_for(:account_oauth).merge(email: 'isaac.hermens@gmail.com'))
      expect(account1).to be_valid
      account2 = @user.accounts.create(FactoryGirl.attributes_for(:account_oauth).merge(email: 'isaac.hermens@gmail.com'))
      expect(account2).to_not be_valid
    end

    after do
      @user.destroy
    end

    pending "add more oauth examples #{__FILE__}"
  end

  it {should validate_presence_of(:name)}
  it {should validate_presence_of(:user_id)}

  describe 'Epoch accounts' do
    before do
      @user = User.create()
      @epoch_account = @user.accounts.new(FactoryGirl.attributes_for(:account_internal))
    end

    it 'should have a valid factory' do
      expect(@epoch_account).to be_valid
    end

    it 'should have Epoch provider' do
      expect(@epoch_account.provider).to eq('Epoch')
    end

    it 'should require a password of at least 8 characters' do
      account = Account.new(FactoryGirl.attributes_for(:account_internal, password: 'test'))
      expect(account).to_not be_valid

      account = Account.new(FactoryGirl.attributes_for(:account_internal, password: nil))
      expect(account).to_not be_valid
    end

    it 'should require a valid email address' do
      @epoch_account.email = 'test'
      expect(@epoch_account).to_not be_valid

      @epoch_account.email = nil
      expect(@epoch_account).to_not be_valid
    end

    it 'should generate and remove password reset tokens' do
      expect{@epoch_account.add_reset_token}.to change{@epoch_account.password_reset_token}
      @epoch_account.remove_reset_token
      expect(@epoch_account.password_reset_token).to be_nil
    end

    after do
      @user.destroy
    end
  end
end
