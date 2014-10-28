require 'rails_helper'

describe User do
  pending "Add more things"

  it {should have_many(:timelines)}
  it {should have_many(:events)}
  it {should have_many(:accounts)}
end
