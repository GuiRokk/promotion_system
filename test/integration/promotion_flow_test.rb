require "test_helper"
include LoginMacros

class PromotionFlowTest < ActionDispatch::IntegrationTest
  test 'can create a promotion' do
    login_user
    post '/promotions', params: {promotion:{name: 'Natal', description: 'Promoção de Natal', 
                                            code:'NATAL10',discount_rate: 15, coupon_quantity: 5, 
                                            expiration_date: '22/12/2033'}}

    assert_redirected_to promotion_path(Promotion.last)
    follow_redirect!
    assert_select 'h3', 'Natal - Promoção de Natal'

  end

test 'cannot create a promotion without login' do
    post '/promotions', params: {promotion:{name: 'Natal', description: 'Promoção de Natal', 
                                            code:'NATAL10',discount_rate: 15, coupon_quantity: 5, 
                                            expiration_date: '22/12/2033'}}

    assert_redirected_to new_user_session_path
  end


  test 'cannot create coupons without login' do
    user = User.create!(email: 'test@iugu.com.br', password: '123123', name: 'Fulano')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)

    post generate_coupons_promotion_path(promotion)
    assert_redirected_to new_user_session_path
  end

  test 'promotion creator cannot approve promotion by route' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                    code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                     expiration_date: '22/12/2033', user: user)

    post approve_promotion_path(promotion)
    assert_redirected_to promotion_path(promotion)
    refute promotion.reload.approved?
    assert_equal 'Não pode ser aprovado pelo criador da promoção', flash[:notice]
  end

  test 'cannot approve without login' do
    user = User.create!(email: 'test@iugu.com.br', password: '123123', name: 'Fulano')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                    code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                     expiration_date: '22/12/2033', user: user)

    post approve_promotion_path(promotion)
    assert_redirected_to new_user_session_path
    refute promotion.reload.approved?
  end

  #TODO: UPDATE
  #TODO DESTROY
end