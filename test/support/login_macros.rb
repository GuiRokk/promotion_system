module LoginMacros
  def login_user(user = User.create!(email: 'jane.doe@iugu.com.br', password: '123456'))
    login_as user, scope: :user
    user
  end

  def login_approver(user = User.create!(email: 'peter.parker@iugu.com.br', password: '123456'))
    login_as user, scope: :user
    user
  end
end