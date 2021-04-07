require 'test_helper'

class UserFlowTest < ActionDispatch::IntegrationTest
  include LoginMacros

  test 'cannot access user profile without login' do
    user = User.create!(email: 'test@iugu.com.br', password: '123123', name: 'Fulano')
    get user_path(user)
    assert_redirected_to new_user_session_path
  end
end
