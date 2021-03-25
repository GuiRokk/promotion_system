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


  test 'user sign out' do
    user = User.create!(email:'jane.doe@iugu.com.br', password:'password')

    visit root_path
    click_on 'Entrar'
    fill_in 'Email', with: user.email
    fill_in 'Senha', with: user.password
    click_on 'Log in'
    click_on 'Sair'

    assert_current_path root_path
    assert_text 'Saiu com sucesso'
    assert_no_link "Promoção"
    assert_no_link "Produtos"
    assert_no_link "Sair"
    assert_link 'Cadastrar'
    assert_link 'Entrar'
  end

  test 'user fails to register: blanks' do
    visit root_path
    click_on 'Cadastrar'
    fill_in 'Email', with:''
    fill_in 'Senha', with: ''
    within 'form' do
      click_on 'Cadastrar'
    end

    assert_text 'Não foi possível salvar'
    assert_text 'não pode ficar em branco', count:2
  end

  test 'user fails to register: email must be unique' do
    user = User.create!(email:'jane.doe@iugu.com.br', password:'password')
    
    visit root_path
    click_on 'Cadastrar'
    fill_in 'Email', with: user.email
    fill_in 'Senha', with: 'password'
    fill_in 'Confirmação de senha', with: 'password'
    within 'form' do
      click_on 'Cadastrar'
    end

    assert_text 'Não foi possível salvar'
    assert_text 'Email já está em uso'
  end

  test 'user fails to register: password must be 6 characters minimun' do

    visit root_path
    click_on 'Cadastrar'
    fill_in 'Email', with: 'john.doe@iugu.com.br'
    fill_in 'Senha', with: '12345'
    fill_in 'Confirmação de senha', with: '12345'
    within 'form' do
      click_on 'Cadastrar'
    end

    assert_text 'Não foi possível salvar'
    assert_text 'Password é muito curto (mínimo: 6 caracteres)'
  end

  test "user fails to register: password confirmation doen't match password" do

    visit root_path
    click_on 'Cadastrar'
    fill_in 'Email', with: 'john.doe@iugu.com.br'
    fill_in 'Senha', with: '12345'
    fill_in 'Confirmação de senha', with: '1234'
    within 'form' do
      click_on 'Cadastrar'
    end

    assert_text 'Não foi possível salvar'
    assert_text 'Password confirmation não é igual a Password'
  end

  #TODO: TESTE FALHA AO LOGAR
  #TODO: TESTE EDITAR USUARIO
  #TODO: I18n USER
  #TODO: INCLUIR NAME NO USER
end
