# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name 'My Name'
  end

  factory :user_oauth, parent: :user do
    provider 'MyString'
    uid 'MyString'
    oauth_token 'MyString'
    oauth_expires_at '2014-09-03 21:01:29'
  end

  factory :user_internal, parent: :user do
    provider 'Epoch'
    password 'testtest'
    email 'testtest@test.com'
  end
end
