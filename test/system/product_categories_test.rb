require "application_system_test_case"
include LoginMacros

class ProductCategoriesTest < ApplicationSystemTestCase

  test 'no product available with login' do

    login_user
    visit root_path
    click_on 'Produtos'

    assert_text 'Nenhum produto cadastrado'
  end

  test 'view product_categories with login' do
    ProductCategory.create!(name: 'Produto AntiFraude', code:'ANTIFRA')
    ProductCategory.create!(name: 'Produto Computador', code:'COMPUT')

    login_user
    visit root_path
    click_on 'Produtos'
    assert_text 'Produto AntiFraude'
    assert_no_text 'ANTIFRA'
    assert_text 'Produto Computador'
    assert_no_text 'COMPUT'
  end

  test 'visit products and return to home page with login' do

    login_user
    visit root_path
    click_on 'Produtos'
    click_on 'Voltar'
    assert_current_path root_path
  end

  test 'view product details with login' do
    ProductCategory.create!(name: 'Produto AntiFraude', code:'ANTIFRA')

    login_user
    visit root_path
    click_on 'Produtos'
    click_on 'Produto AntiFraude'

    assert_text 'Produto AntiFraude'
    assert_text 'ANTIFRA'
  end

  test 'visit products details and return to products index  with login' do
    product = ProductCategory.create!(name: 'Produto AntiFraude', code:'ANTIFRA')

    login_user
    visit product_category_path(product)
    click_on 'Voltar'

    assert_current_path product_categories_path
  end

  test 'create a new product with login' do

    login_user
    visit product_categories_path
    click_on "Registrar Produto"
    fill_in "Nome", with: 'Produto AntiFraude'
    fill_in "Código", with: 'ANTIFRA'
    click_on 'Criar Produto'

    assert_current_path product_category_path(ProductCategory.last)
    assert_text 'Produto AntiFraude'
    assert_text 'ANTIFRA'
  end

  test "validates a new product: name/code can't be blank with login" do

    login_user
    visit product_categories_path
    click_on "Registrar Produto"
    fill_in "Nome", with: ''
    fill_in "Código", with: ''
    click_on 'Criar Produto'

    assert_text 'não pode ficar em branco', count: 2
  end

  test "validates a new product: code must be unique  with login" do
    ProductCategory.create!(name: 'Produto Novo', code:'ANTIFRA')

    login_user
    visit product_categories_path
    click_on "Registrar Produto"
    fill_in "Nome", with: 'Produto AntiFraude'
    fill_in "Código", with: 'ANTIFRA'
    click_on 'Criar Produto'
    assert_text 'deve ser único'
  end

  test 'edit a product with login' do
    product = ProductCategory.create!(name: 'Produto AntiFraude', code:'ANTIFRA')

    login_user
    visit product_category_path(product)
    click_on "Editar Produto"
    fill_in "Nome", with: 'Novo Produto'
    fill_in "Código", with: 'NOVOPROD'
    click_on "Atualizar Produto"

    assert_current_path product_category_path(product)
    assert_text 'Produto editado com sucesso'
    assert_text "Novo Produto"
    assert_text "NOVOPROD"
  end

  test "validates product edit: name/code can't be blank  with login" do
    product = ProductCategory.create!(name: 'Produto AntiFraude', code:'ANTIFRA')

    login_user
    visit product_category_path(product)
    click_on "Editar Produto"
    fill_in "Nome", with: ''
    fill_in "Código", with: ''
    click_on "Atualizar Produto"

    assert_current_path product_category_path(product)
    assert_text 'não pode ficar em branco', count: 2
  end

  test "validates product edit: code must be unique  with login" do
    ProductCategory.create!(name: 'Produto AntiFraude', code:'ANTIFRA')
    product = ProductCategory.create!(name: 'Produto Novo', code:'NOVOPROD')

    login_user
    visit product_category_path(product)
    click_on "Editar Produto"
    fill_in "Código", with: 'ANTIFRA'
    click_on "Atualizar Produto"

    assert_current_path product_category_path(product)
    assert_text 'deve ser único'
  end


  test 'delete the only product with login' do
    product = ProductCategory.create!(name: 'Computador', code:'PRODCOMP')

    login_user
    visit product_category_path(product)
    click_on 'Apagar Produto'

    assert_current_path product_categories_path
    assert_text "Produto #{product.name} apagado com sucesso"
    assert_no_link 'Computador'
    assert_text 'Nenhum produto cadastrado'
  end

  test 'delete promotion with existing promotion with login' do
    ProductCategory.create!(name: 'Produto AntiFraude', code:'ANTIFRA')
    product = ProductCategory.create!(name: 'Computador', code:'PRODCOMP')

    login_user
    visit product_category_path(product)
    click_on 'Apagar Produto'

    assert_current_path product_categories_path
    assert_text "Produto #{product.name} apagado com sucesso"
    assert_no_link 'Computador'
    assert_link 'Produto AntiFraude'
  end
end