require "test_helper"

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
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')
    
    
    post generate_coupons_promotion_path(promotion)
    
    assert_redirected_to new_user_session_path
  end



  #TODO: UPDATE
  #TODO DESTROY
end