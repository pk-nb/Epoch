require 'rails_helper'

describe User do
  describe 'users with oauth accounts' do
    pending "add oauth examples #{__FILE__}"
  end

  describe 'with Epoch (internal) account' do
    before do
      @epoch_user = User.new(FactoryGirl.attributes_for(:user_internal))
    end

    it {should validate_presence_of(:name)}
    it {should have_many(:timelines)}
    it {should have_many(:events)}
    it {should have_one(:profile)}

    it 'should have a valid factory' do
      expect(@epoch_user).to be_valid
    end

    it 'should have Epoch provider' do
      expect(@epoch_user.provider).to eq('Epoch')
    end

    it 'should require a password of at least 8 characters' do
      user = User.new(FactoryGirl.attributes_for(:user_internal, password: 'test'))
      expect(user).to_not be_valid

      user = User.new(FactoryGirl.attributes_for(:user_internal, password: nil))
      expect(user).to_not be_valid
    end

    it 'should require a valid email address' do
      @epoch_user.email = 'test'
      expect(@epoch_user).to_not be_valid

      @epoch_user.email = nil
      expect(@epoch_user).to_not be_valid
    end

    it 'should generate and remove password reset tokens' do
      expect{@epoch_user.add_reset_token}.to change{@epoch_user.password_reset_token}
      @epoch_user.remove_reset_token
      expect(@epoch_user.password_reset_token).to be_nil
    end
  end
end
