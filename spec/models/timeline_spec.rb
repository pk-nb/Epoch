require 'rails_helper'

describe Timeline do
  it "has a valid factory" do
    t = Timeline.new(FactoryGirl.attributes_for :timeline)
    expect(t).to be_valid
  end
  
  it "requires a title" do
    t = Timeline.new(FactoryGirl.attributes_for :timeline, title: nil)
    expect(t).to_not be_valid
  end
  
  it "requires content" do
    t = Timeline.new(FactoryGirl.attributes_for :timeline, content: nil)
    expect(t).to_not be_valid
  end
  
  it "requires a start_date" do
    t = Timeline.new(FactoryGirl.attributes_for :timeline, start_date: nil)
    expect(t).to_not be_valid
  end
  
  it "requires end_date to be on or after start_date" do
    # Should not be before
    t = Timeline.new(FactoryGirl.attributes_for :timeline, start_date: "2014-10-01 19:19:09", end_date: "2013-10-01 19:19:09")
    expect(t).to_not be_valid
    # But can be the same
    t = Timeline.new(FactoryGirl.attributes_for :timeline, start_date: "2014-10-01 19:19:09", end_date: "2014-10-01 19:19:09")
    expect(t).to be_valid
    # But can be the same
    t = Timeline.new(FactoryGirl.attributes_for :timeline, start_date: "2014-10-01 19:19:09", end_date: "2015-10-01 19:19:09")
    expect(t).to be_valid
  end
  
  it "doesn't mind if end_date is nil" do
    t = Timeline.new(FactoryGirl.attributes_for :timeline, end_date: nil)
    expect(t).to be_valid
  end
end
