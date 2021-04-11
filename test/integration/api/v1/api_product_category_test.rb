require 'test_helper'

class ApiProductCategoryTest < ActionDispatch::IntegrationTest
  test 'show product' do
    prod = ProductCategory.create!(name: 'Computer', code: 'COMP')

    get "/api/v1/product_categories/#{prod.code}", as: :json

    assert_response :ok
    body = JSON.parse(response.body, symbolize_names: true)
    assert_equal prod.name, body[:name]
    assert_equal prod.code, body[:code]
  end

  test 'cannot show product' do
    get '/api/v1/product_categories/qwerty', as: :json

    assert_response :not_found
  end

  test 'show index' do
    comp = ProductCategory.create!(name: 'Computer', code: 'COMP')
    cloth = ProductCategory.create!(name: 'Pants', code: 'CLOTH')

    get '/api/v1/product_categories', as: :json

    assert_response :ok
    body = JSON.parse(response.body, symbolize_names: true)
    assert_equal comp.name,  body[0][:name]
    assert_equal comp.code,  body[0][:code]
    assert_equal cloth.name, body[1][:name]
    assert_equal cloth.code, body[1][:code]
  end

  test 'nothing to show index' do
    get '/api/v1/product_categories', as: :json

    assert_response :no_content
  end

  test 'create a product category' do
    post '/api/v1/product_categories', params: { product_category: { name: 'Computer', code: 'COMP' } }, as: :json

    assert_response :ok
    body = JSON.parse(response.body, symbolize_names: true)
    assert_equal 'Computer', body[:name]
    assert_equal 'COMP', body[:code]
  end

  test 'cannot create a product category with blanks' do
    post '/api/v1/product_categories', params: { product_category: { name: '', code: '' } }, as: :json

    assert_response :unprocessable_entity
    assert_not ProductCategory.last
  end

  test 'cannot create a product category, name and code must be unique' do
    ProductCategory.create!(name: 'Computer', code: 'COMP')

    post '/api/v1/product_categories', params: { product_category: { name: 'Computer', code: 'COMP' } }, as: :json

    assert_response :unprocessable_entity
  end

  test 'update a product category' do
    prod = ProductCategory.create!(name: 'Computer', code: 'COMP')

    patch "/api/v1/product_categories/#{prod.code}", params: { product_category: { name: 'Headset', code: 'AUDIO' } },
                                                     as: :json

    assert_response :ok
    body = JSON.parse(response.body, symbolize_names: true)
    assert_equal 'Headset', body[:name]
    assert_equal 'AUDIO', body[:code]
  end

  test 'cannot update a product category with blanks' do
    prod = ProductCategory.create!(name: 'Computer', code: 'COMP')

    patch "/api/v1/product_categories/#{prod.code}", params: { product_category: { name: '', code: '' } }, as: :json

    assert_response :unprocessable_entity
  end

  test 'cannot update a product category name and code must be unique' do
    comp = ProductCategory.create!(name: 'Computer', code: 'COMP')
    ProductCategory.create!(name: 'Pants', code: 'CLOTH')

    patch "/api/v1/product_categories/#{comp.code}", params: { product_category: { name: 'Pants', code: 'CLOTH' } },
                                                     as: :json

    assert_response :unprocessable_entity
  end

  test 'destroy a product category' do
    prod = ProductCategory.create!(name: 'Computer', code: 'COMP')

    delete "/api/v1/product_categories/#{prod.code}", as: :json

    assert_response :no_content
  end
end
