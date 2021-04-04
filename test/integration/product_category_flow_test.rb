require "test_helper"
include LoginMacros

class ProductCategoryFlowTest < ActionDispatch::IntegrationTest
  test 'view index' do
    login_user
    get product_categories_path
    assert_response :ok
  end

  test 'cannot view index without login' do
    get product_categories_path
    assert_redirected_to new_user_session_path
  end

  test 'view show' do
    login_user
    ProductCategory.create!(name: 'Calça', code: 'ROUPA')
    get product_category_path(ProductCategory.last)
    assert_select 'th', 'Calça'
    assert_select 'th', 'ROUPA'
  end

  test 'cannot view show without login' do
    ProductCategory.create!(name: 'Calça', code: 'ROUPA')
    get product_category_path(ProductCategory.last)
    assert_redirected_to new_user_session_path
  end

  test 'view new' do
    login_user
    get new_product_category_path
    assert_response :ok
  end

  test 'cannot view new without login' do
    get new_product_category_path
    assert_redirected_to new_user_session_path
  end

  test 'can create a product' do
    login_user
    post product_categories_path, params:{product_category:{name: 'Calça', code: 'ROUPA'}}

    assert_redirected_to product_category_path(ProductCategory.last)
    follow_redirect!
    assert_select 'th', 'Calça'
    assert_select 'th', 'ROUPA'
  end

  test 'cannot create a product without login' do
    post product_categories_path, params:{product_category:{name: 'Calça', code: 'ROUPA'}}

    assert_redirected_to new_user_session_path
  end

  test 'edit a product' do
    login_user
    ProductCategory.create!(name: 'Calça', code: 'ROUPA')
    get edit_product_category_path(ProductCategory.last)
    assert_response :ok
  end

  test 'cannot edit a product without login' do
    ProductCategory.create!(name: 'Calça', code: 'ROUPA')
    get edit_product_category_path(ProductCategory.last)
    assert_redirected_to new_user_session_path
  end

  test 'update a product' do
    login_user
    product = ProductCategory.create!(name: 'Calça', code: 'ROUPA')
    patch product_category_path(product), params:{product_category:{name: 'Eletronico', code: 'ELETRO'}}

    assert_redirected_to product_category_path(product)
    follow_redirect!
    assert_select 'th', 'Eletronico'
    assert_select 'th', 'ELETRO'
  end

  test 'cannot update a product without login' do
    product = ProductCategory.create!(name: 'Calça', code: 'ROUPA')
    patch product_category_path(product), params:{product_category:{name: 'Eletronico', code: 'ELETRO'}}

    assert_redirected_to new_user_session_path
  end

  test 'destroy a product' do
    login_user
    product = ProductCategory.create!(name: 'Calça', code: 'ROUPA')
    delete product_category_path(product)
    assert_redirected_to product_categories_path
    refute ProductCategory.last
  end

  test 'cannot destroy a product without login' do
    product = ProductCategory.create!(name: 'Calça', code: 'ROUPA')
    delete product_category_path(product)
    assert_redirected_to new_user_session_path
    assert ProductCategory.last
  end
end