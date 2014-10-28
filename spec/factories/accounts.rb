# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :account do
    name 'My Name'
  end

  factory :account_oauth, parent: :account do
    provider 'MyString'
    uid 'MyString'
    oauth_token 'MyString'
    oauth_expires_at '2014-09-03 21:01:29'
  end

  factory :account_internal, parent: :account do
    provider 'Epoch'
    password 'testtest'
    email 'testtest@test.com'
  end
end
