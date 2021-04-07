require 'application_system_test_case'

class PromotionsTest < ApplicationSystemTestCase
  include LoginMacros

  test 'visit user profile' do
    user = Fabricate(:user)
    visit root_path
    click_on 'Entrar'
    fill_in 'Email', with: user.email
    fill_in 'Senha', with: user.password
    within 'form' do
      click_on 'Entrar'
    end
    click_on user.email

    assert_current_path user_path(user)
    assert_text 'Perfil do Usuário'
    assert_text 'Nome'
    assert_text user.name
    assert_text 'Email'
    assert_text user.email
    assert_link 'Voltar'
    assert_link 'Editar Usuário'
  end

  test 'edit user data' do
    user = User.create!(email: 'test@iugu.com.br', password: '123123', name: '')

    visit root_path
    click_on 'Entrar'
    fill_in 'Email', with: user.email
    fill_in 'Senha', with: user.password
    within 'form' do
      click_on 'Entrar'
    end
    click_on user.email
    click_on 'Editar Usuário'
    fill_in 'Nome', with: 'Peter Parker'
    fill_in 'Email', with: 'peter_parker@iugu.com.br'
    fill_in 'Senha', with: '12341234'
    fill_in 'Confirmação de Senha', with: '12341234'
    fill_in 'Senha atual', with: user.password
    click_on 'Atualizar Usuário'

    assert_current_path user_path(user)
    assert_text 'Sua conta foi atualizada com sucesso'
    assert_text 'Peter Parker'
    assert_text 'peter_parker@iugu.com.br'
  end

  test 'edit user data with blank email' do
    user = User.create!(email: 'test@iugu.com.br', password: '123123', name: '')

    visit root_path
    click_on 'Entrar'
    fill_in 'Email', with: user.email
    fill_in 'Senha', with: user.password
    within 'form' do
      click_on 'Entrar'
    end
    click_on user.email
    click_on 'Editar Usuário'
    fill_in 'Email', with: ''
    fill_in 'Senha atual', with: user.password
    click_on 'Atualizar Usuário'

    assert_text 'Não foi possível salvar usuário: 1 erro'
    assert_text 'Email não pode ficar em branco'
  end

  test 'edit user data with invalid email' do
    user = User.create!(email: 'test@iugu.com.br', password: '123123')

    login_user(user)
    visit root_path
    click_on user.email
    click_on 'Editar Usuário'
    fill_in 'Email', with: 'test@gmail.com'
    fill_in 'Senha atual', with: user.password
    click_on 'Atualizar Usuário'

    assert_text 'Não foi possível salvar usuário: 1 erro'
    assert_text 'Email não é válido'
  end

  test 'edit user data with blank current password' do
    user = User.create!(email: 'test@iugu.com.br', password: '123123')

    login_user(user)
    visit root_path
    click_on user.email
    click_on 'Editar Usuário'
    fill_in 'Senha atual', with: ''
    click_on 'Atualizar Usuário'

    assert_text 'Não foi possível salvar usuário: 1 erro'
    assert_text 'Senha atual não pode ficar em branco'
  end

  test 'edit user data with invalid new password and password confirmation not matching' do
    user = User.create!(email: 'test@iugu.com.br', password: '123123')

    login_user(user)
    visit root_path
    click_on user.email
    click_on 'Editar Usuário'
    fill_in 'Senha', with: '123'
    fill_in 'Confirmação de Senha', with: '1234'
    fill_in 'Senha atual', with: user.password
    click_on 'Atualizar Usuário'

    assert_text 'Não foi possível salvar usuário: 2 erros'
    assert_text 'Senha é muito curto (mínimo: 6 caracteres)'
    assert_text 'Confirmação de Senha não é igual a Senha'
  end
end
