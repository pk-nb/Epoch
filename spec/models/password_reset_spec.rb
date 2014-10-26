require 'rails_helper'

RSpec.describe PasswordReset, :type => :model do
  describe 'creation validation' do
    before do
      @user = User.create(FactoryGirl.attributes_for :user_internal)
    end
    it 'should not be valid with an invalid email address' do
      p = PasswordReset.new(email: 'junk@junk.com')
      expect(p).to_not be_valid
    end

    it 'should be valid with a valid user email' do
      p = PasswordReset.new(email: @user.email)
      expect(p).to be_valid
    end

    it 'should correctly find by token' do
      @user.add_reset_token
      p = PasswordReset.find(@user.password_reset_token)
      expect(p).to_not be_nil
    end

    after do
      @user.destroy
    end
  end

  describe 'an object created by #new' do
    before do
      @user = User.create(FactoryGirl.attributes_for :user_internal)
      @reset = PasswordReset.new({email: @user.email})
    end

    it 'creates token and sends an email' do
      expect (@reset.save).to change {ActionMailer::Base.deliveries.count}.by(1)
    end

    describe '#expired?' do
      before do
        @reset.save
      end

      it 'returns false if the reset has not expired' do
        expect(@reset).to_not be_expired
      end
      it 'returns true if expired' do
        @reset.user.password_reset_sent_at = 3.hours.ago
        expect(@reset).to be_expired
      end
    end

    after do
      @user.destroy
    end
  end

  describe 'an object instantiated by #find' do
    before do
      @user = User.create(FactoryGirl.attributes_for :user_internal)
      @new_password = 'testtesttest'
      @user.add_reset_token
      @reset = PasswordReset.find(@user.password_reset_token)
    end

    it 'should not be valid without a password' do
      expect(@reset).to_not be_valid
    end

    describe 'with a password' do
      before do
        @reset.password = @new_password
        @reset.password_confirmation = @new_password
      end

      it 'should be valid when a password is set after being found' do
        expect(@reset).to be_valid
      end

      it 'should update the user\'s password with #update_user' do
        expect{@reset.update_user}.to change{@reset.user.password_digest}
      end
    end

    after do
      @user.destroy
    end
  end
end
