# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :event do
    title "MyString"
    content "MyString"
    start_date "2014-09-16 09:14:17"
    end_date "2014-09-16 09:14:17"
    user_id 1
  end
end
