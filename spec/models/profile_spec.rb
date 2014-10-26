require 'rails_helper'

describe Profile do
  it {should validate_presence_of(:user_id)}

  it 'has a valid factory' do
    p = Profile.new(FactoryGirl.attributes_for :profile)
  end
end
