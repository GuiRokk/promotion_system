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
    assert_link 'Voltar'
  end

  test 'visit products details and return to products index' do
    product = ProductCategory.create!(name: 'Produto AntiFraude', code:'ANTIFRA')
    
    visit product_category_path(product)
    click_on 'Voltar'
    
    assert_current_path product_categories_path
    assert_text
  end
  






end
