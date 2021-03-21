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












end
