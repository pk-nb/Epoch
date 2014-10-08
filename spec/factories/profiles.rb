# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :profiles do
    first_name "MyString"
    last_name "MyString"
    email "MyString"
    favorite_cake "MyString"
  end
end
