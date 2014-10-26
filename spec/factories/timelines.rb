# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :timeline do
    title "MyString"
    content "MyString"
    start_date "2014-10-01 19:19:09"
    end_date "2014-10-01 19:19:09"
    user_id 1
  end
  
  factory :invalid_timeline, parent: :timeline do
    title nil
  end
end
