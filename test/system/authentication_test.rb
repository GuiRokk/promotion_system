require 'application_system_test_case'

class AuthenticationTest < ApplicationSystemTestCase
  test 'user register' do
    visit root_path
    click_on 'Cadastrar'
    fill_in 'Email', with: 'jane.doe@iugu.com.br'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirmação de Senha', with: 'password'
    within 'form' do
      click_on 'Cadastrar'
    end

    assert_text 'Boas Vindas! Cadastrou e entrou com sucesso'
    assert_text 'jane.doe@iugu.com.br'
    assert_link 'Sair'
    assert_no_link 'Cadastrar'
    assert_current_path root_path
  end

  test 'user sign in' do
    user = User.create!(email: 'jane.doe@iugu.com.br', password: 'password')

    visit root_path
    click_on 'Entrar'
    fill_in 'Email', with: user.email
    fill_in 'Senha', with: user.password
    within 'form' do
      click_on 'Entrar'
    end

    assert_text 'Login efetuado com sucesso'
    assert_text user.email
    assert_link 'Sair'
    assert_current_path root_path
    assert_no_link 'Entrar'
  end

  test 'user sign out' do
    user = User.create!(email: 'jane.doe@iugu.com.br', password: 'password')

    visit root_path
    click_on 'Entrar'
    fill_in 'Email', with: user.email
    fill_in 'Senha', with: user.password
    within 'form' do
      click_on 'Entrar'
    end
    click_on 'Sair'

    assert_current_path root_path
    assert_text 'Saiu com sucesso'
    assert_no_link 'Promoção'
    assert_no_link 'Produtos'
    assert_no_link 'Sair'
    assert_link 'Cadastrar'
    assert_link 'Entrar'
  end

  test 'user fails to register: blanks' do
    visit root_path
    click_on 'Cadastrar'
    fill_in 'Email', with: ''
    fill_in 'Senha', with: ''
    within 'form' do
      click_on 'Cadastrar'
    end

    assert_text 'Não foi possível salvar'
    assert_text 'não pode ficar em branco', count: 2
  end

  test 'user fails to register: email must be unique' do
    user = User.create!(email: 'jane.doe@iugu.com.br', password: 'password')

    visit root_path
    click_on 'Cadastrar'
    fill_in 'Email', with: user.email
    fill_in 'Senha', with: 'password'
    fill_in 'Confirmação de Senha', with: 'password'
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
    fill_in 'Confirmação de Senha', with: '12345'
    within 'form' do
      click_on 'Cadastrar'
    end

    assert_text 'Não foi possível salvar'
    assert_text 'Senha é muito curto (mínimo: 6 caracteres)'
  end

  test "user fails to register: password confirmation doen't match password" do
    visit root_path
    click_on 'Cadastrar'
    fill_in 'Email', with: 'john.doe@iugu.com.br'
    fill_in 'Senha', with: '12345'
    fill_in 'Confirmação de Senha', with: '1234'
    within 'form' do
      click_on 'Cadastrar'
    end

    assert_text 'Não foi possível salvar'
    assert_text 'Confirmação de Senha não é igual a Senha'
  end

  test 'user fails to login' do
    visit root_path
    click_on 'Entrar'
    fill_in 'Email', with: ''
    fill_in 'Senha', with: ''
    within 'form' do
      click_on 'Entrar'
    end

    assert_text 'Email ou senha inválida'
    assert_current_path new_user_session_path
  end

  test 'cannot validate register user with domain not @iugu.com.br' do
    visit root_path
    click_on 'Cadastrar'
    fill_in 'Email', with: 'jane.doe@gmail.com.br'
    fill_in 'Senha', with: 'password'
    fill_in 'Confirmação de Senha', with: 'password'
    within 'form' do
      click_on 'Cadastrar'
    end

    assert_text 'Não foi possível salvar'
    assert_text 'Email não é válido'
    assert_current_path user_registration_path
  end
end
# TODO: não logar e ir pra login?
# TODO:mandar email?
# TODO:validar a qualidade da senha?
# TODO:captcha não sou um robo?
# TODO: recuperar senha?
