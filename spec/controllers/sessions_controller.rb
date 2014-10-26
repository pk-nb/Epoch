require 'rails_helper'

describe SessionsController do
  let(:session_create) do
    user = create(:user, password: 'testtest', password_confirmation: 'testtest',
                  email: 'isaac.hermens@gmail.com', )
    post :crease, session: {login: 'isaac.hermens@gmail.com', password: 'testtest'}
    expect(session[:user_id]).to eq(user.id)
  end

  it 'creates a session using internal authentication' do
    session_create
  end

  it 'destroys a session' do
    session_create
    get :destroy
    expect(session[:user_id]).to be_nil
  end
end
