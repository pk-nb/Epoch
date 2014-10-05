require 'rails_helper'

describe Event do
  it 'has a valid factory' do
    event = Event.new(FactoryGirl.attributes_for :event)
    expect(event).to be_valid
  end

  it 'requires a title' do
    event = Event.new(FactoryGirl.attributes_for :event, title: nil)
    expect(event).to_not be_valid
  end

  it 'requires content' do
    event = Event.new(FactoryGirl.attributes_for :event, content: nil)
    expect(event).to_not be_valid
  end

  it 'requires a start_date' do
    event = Event.new(FactoryGirl.attributes_for :event, start_date: nil)
    expect(event).to_not be_valid
  end

  it 'requires a valid start date' do
    event = Event.new(FactoryGirl.attributes_for :event, start_date: 'This isn\'t a date')
    expect(event).to_not be_valid
  end

  it 'requires end_date to be on or after start_date' do
    # Can not be before
    event = Event.new(FactoryGirl.attributes_for :event, start_date: '2014-10-01', end_date: '2013-10-01')
    expect(event).to_not be_valid
    # But can be the same
    event = Event.new(FactoryGirl.attributes_for :event, start_date: '2014-10-01 19:19:09', end_date: '2014-10-01 19:19:09')
    expect(event).to be_valid
    # But can be the same
    event = Event.new(FactoryGirl.attributes_for :event, start_date: '2014-10-01 19:19:09', end_date: '2015-10-01 19:19:09')
    expect(event).to be_valid
  end

  it 'only accepts valid end dates' do
    event = Event.new(FactoryGirl.attributes_for :event, start_date: 'Haha, not a date!')
    expect(event).to_not be_valid
  end

  it 'does not require an end date' do
    event = Event.new(FactoryGirl.attributes_for :event, end_date: nil)
    expect(event).to be_valid
  end
end
