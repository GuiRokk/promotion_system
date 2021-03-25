require 'application_system_test_case'

class AuthenticationTest < ApplicationSystemTestCase

  test 'user sign up' do
    
    visit root_path
    click_on "Cadastrar"
    fill_in 'Email', with: 'jane.doe@iugu.com.br'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirmação de senha', with: 'password'
    within 'form' do
      click_on 'Cadastrar'
    end
    
    assert_text "Boas Vindas! Cadastrou e entrou com sucesso"
    assert_text 'jane.doe@iugu.com.br'
    assert_link 'Sair'
    assert_no_link 'Cadastrar'
    assert_current_path root_path

    #não logar e ir pra login?
    #mandar email?
    #validar a qualidade da senha?
    #captcha não sou um robo?
  end

  test 'user sign in' do
    user = User.create!(email:'jane.doe@iugu.com.br', password:'password')
    
    visit root_path
    click_on 'Entrar'
    fill_in 'Email', with: user.email
    fill_in 'Senha', with: user.password
    click_on 'Log in'

    assert_text "Login efetuado com sucesso"
    assert_text user.email
    assert_link 'Sair'
    assert_current_path root_path
    assert_no_link 'Entrar'
  end


  #TODO: TESTE LOGOUT
  #TODO: TESTE FALHA AO REGISTRAR
  #TODO: TESTE FALHA AO LOGAR
  #TODO: TESTE EDITAR USUARIO
  #TODO: I18n USER
  #TODO: INCLUIR NAME NO USER
end
