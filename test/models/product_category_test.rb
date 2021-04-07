require 'test_helper'

class ProductCategoryTest < ActiveSupport::TestCase
  test "name/code can't be blank" do
    product = ProductCategory.new
    assert_not product.valid?
    assert_includes product.errors[:name], 'não pode ficar em branco'
    assert_includes product.errors[:code], 'não pode ficar em branco'
  end

  test 'code must be unique' do
    ProductCategory.create!(name: 'Prod1', code: 'PROD1')
    product = ProductCategory.new(name: 'Prod2', code: 'PROD1')

    assert_not product.valid?
    assert_includes product.errors[:code], 'deve ser único'
  end
end
