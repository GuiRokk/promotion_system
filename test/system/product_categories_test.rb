require "application_system_test_case"

class ProductCategoriesTest < ApplicationSystemTestCase

  test 'no product available' do
    visit root_path
    click_on 'Produtos'

    assert_text 'Nenhum produto cadastrado'
  end

  test 'view product_categories' do
    ProductCategory.create!(name: 'Produto AntiFraude', code:'ANTIFRA')
    ProductCategory.create!(name: 'Produto Computador', code:'COMPUT')

    visit root_path
    click_on 'Produtos'
    assert_text 'Produto AntiFraude'
    assert_no_text 'ANTIFRA'
    assert_text 'Produto Computador'
    assert_no_text 'COMPUT'
  end

  test 'visit products and return to home page' do
    visit root_path
    click_on 'Produtos'
    click_on 'Voltar'
    assert_current_path root_path
  end

  test 'view product details' do
    ProductCategory.create!(name: 'Produto AntiFraude', code:'ANTIFRA')

    visit root_path
    click_on 'Produtos'
    click_on 'Produto AntiFraude'

    assert_text 'Produto AntiFraude'
    assert_text 'ANTIFRA'
  end

  test 'visit products details and return to products index' do
    product = ProductCategory.create!(name: 'Produto AntiFraude', code:'ANTIFRA')

    visit product_category_path(product)
    click_on 'Voltar'

    assert_current_path product_categories_path
  end

  test 'create a new product' do
    visit product_categories_path
    click_on "Registrar produto"
    fill_in "Nome", with: 'Produto AntiFraude'
    fill_in "Código", with: 'ANTIFRA'
    click_on 'Criar produto'

    assert_current_path product_category_path(ProductCategory.last)
    assert_text 'Produto AntiFraude'
    assert_text 'ANTIFRA'
  end

  test "validates a new product: name/code can't be blank" do
    visit product_categories_path
    click_on "Registrar produto"
    fill_in "Nome", with: ''
    fill_in "Código", with: ''
    click_on 'Criar produto'

    assert_text 'Encontramos alguns erros...'
    assert_text 'não pode ficar em branco', count: 2
  end

  test "validates a new product: code must be unique" do
    ProductCategory.create!(name: 'Produto Novo', code:'ANTIFRA')

    visit product_categories_path
    click_on "Registrar produto"
    fill_in "Nome", with: 'Produto AntiFraude'
    fill_in "Código", with: 'ANTIFRA'
    click_on 'Criar produto'

    assert_text 'Encontramos alguns erros...'
    assert_text 'deve ser único'
  end

  test 'edit a product' do
    product = ProductCategory.create!(name: 'Produto AntiFraude', code:'ANTIFRA')

    visit product_category_path(product)
    click_on "Editar produto"
    fill_in "Nome", with: 'Novo Produto'
    fill_in "Código", with: 'NOVOPROD'
    click_on "Salvar mudanças"

    assert_current_path product_category_path(product)
    assert_text 'Produto editado com sucesso'
    assert_text "Novo Produto"
    assert_text "NOVOPROD"
  end

  test "validates product edit: name/code can't be blank" do
    product = ProductCategory.create!(name: 'Produto AntiFraude', code:'ANTIFRA')

    visit product_category_path(product)
    click_on "Editar produto"
    fill_in "Nome", with: ''
    fill_in "Código", with: ''
    click_on "Salvar mudanças"

    assert_current_path product_category_path(product)
    assert_text 'Encontramos alguns erros...'
    assert_text 'não pode ficar em branco', count: 2
  end

  test "validates product edit: code must be unique" do
    ProductCategory.create!(name: 'Produto AntiFraude', code:'ANTIFRA')
    product = ProductCategory.create!(name: 'Produto Novo', code:'NOVOPROD')

    visit product_category_path(product)
    click_on "Editar produto"
    fill_in "Código", with: 'ANTIFRA'
    click_on "Salvar mudanças"

    assert_current_path product_category_path(product)
    assert_text 'Encontramos alguns erros...'
    assert_text 'deve ser único'
  end


  test 'delete the only product' do
    product = ProductCategory.create!(name: 'Computador', code:'PRODCOMP')

    visit product_category_path(product)
    click_on 'Apagar produto'

    assert_current_path product_categories_path
    assert_text "Produto #{product.name} apagado com sucesso"
    assert_no_link 'Computador'
    assert_text 'Nenhum produto cadastrado'
  end

  test 'delete promotion with existing promotion' do
    ProductCategory.create!(name: 'Produto AntiFraude', code:'ANTIFRA')
    product = ProductCategory.create!(name: 'Computador', code:'PRODCOMP')

    visit product_category_path(product)
    click_on 'Apagar produto'

    assert_current_path product_categories_path
    assert_text "Produto #{product.name} apagado com sucesso"
    assert_no_link 'Computador'
    assert_link 'Produto AntiFraude'
  end
end