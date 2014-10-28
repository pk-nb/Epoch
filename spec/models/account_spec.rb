require 'rails_helper'

RSpec.describe Account, :type => :model do
  describe 'oauth accounts' do
    pending "add oauth examples #{__FILE__}"
  end

  describe 'Epoch accounts' do
    before do
      @epoch_account = Account.new(FactoryGirl.attributes_for(:account_internal))
    end

    it {should validate_presence_of(:name)}

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
  end
end
