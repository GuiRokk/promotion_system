require 'test_helper'

class PromotionFlowTest < ActionDispatch::IntegrationTest
  test 'cannot view index without login' do
    get promotions_path
    assert_redirected_to new_user_session_path
  end

  test 'cannot view show without login' do
    user = User.create!(email: 'test@iugu.com.br', password: '123123', name: 'Fulano')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal', code: 'NATAL10',
                                  discount_rate: 10, coupon_quantity: 100, expiration_date: '22/12/2033',
                                  user: user)

    get promotion_path(promotion)
    assert_redirected_to new_user_session_path
  end

  test 'edit a promotion' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal', code: 'NATAL10',
                                  discount_rate: 10, coupon_quantity: 100, expiration_date: '22/12/2033',
                                  user: user)

    get edit_promotion_path(promotion)
    assert_response :ok
  end

  test 'cannot edit without login' do
    user = User.create!(email: 'test@iugu.com.br', password: '123123', name: 'Fulano')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal', code: 'NATAL10',
                                  discount_rate: 10, coupon_quantity: 100, expiration_date: '22/12/2033',
                                  user: user)

    get edit_promotion_path(promotion)
    assert_redirected_to new_user_session_path
  end

  test 'cannot get to new without login' do
    get new_promotion_path
    assert_redirected_to new_user_session_path
  end

  test 'can create a promotion' do
    user = login_user
    post promotions_path, params: { promotion: { name: 'Natal', description: 'Promoção de Natal',
                                                 code: 'NATAL10', discount_rate: 15, coupon_quantity: 5,
                                                 expiration_date: '22/12/2033', user: user } }

    assert_redirected_to promotion_path(Promotion.last)
    follow_redirect!
    assert_select 'h3', 'Natal - Promoção de Natal'
  end

  test 'cannot create a promotion without login' do
    post promotions_path, params: { promotion: { name: 'Natal', description: 'Promoção de Natal',
                                                 code: 'NATAL10', discount_rate: 15, coupon_quantity: 5,
                                                 expiration_date: '22/12/2033' } }

    assert_redirected_to new_user_session_path
  end

  test 'can update a promotion' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal', code: 'NATAL10',
                                  discount_rate: 10, coupon_quantity: 100, expiration_date: '22/12/2033',
                                  user: user)

    patch promotion_path(promotion), params: { promotion: {
      name: 'Carnaval', description: 'Promoção de Carnaval', code: 'CARNA20',
      discount_rate: 20, coupon_quantity: 7, expiration_date: '04/06/2055'
    } }

    assert_redirected_to promotion_path(promotion)
    follow_redirect!
    assert_select 'h3', 'Carnaval - Promoção de Carnaval'
  end

  test 'cannot update a promotion with missing param => name' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal', code: 'NATAL10',
                                  discount_rate: 10, coupon_quantity: 100, expiration_date: '22/12/2033',
                                  user: user)

    patch promotion_path(promotion), params: { promotion: { code: 'CARNA20', discount_rate: 20,
                                                            coupon_quantity: 7, expiration_date: '04/06/2055' } }

    assert_response :no_content
  end

  test 'cannot update a promotion without login ' do
    user = User.create!(email: 'test@iugu.com.br', password: '123123', name: 'Fulano')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal', code: 'NATAL10',
                                  discount_rate: 10, coupon_quantity: 100, expiration_date: '22/12/2033',
                                  user: user)

    patch promotion_path(promotion), params: { promotion: {
      name: 'Carnaval', description: 'Promoção de Carnaval', code: 'CARNA20',
      discount_rate: 20, coupon_quantity: 7, expiration_date: '04/06/2055'
    } }

    assert_redirected_to new_user_session_path
  end

  test 'can destroy a promotion' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal', code: 'NATAL10',
                                  discount_rate: 10, coupon_quantity: 100, expiration_date: '22/12/2033',
                                  user: user)

    delete promotion_path(promotion)

    assert_redirected_to promotions_path
    assert_not Promotion.last
  end

  test 'cannot destroy a promotion without login' do
    user = User.create!(email: 'test@iugu.com.br', password: '123123', name: 'Fulano')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal', code: 'NATAL10',
                                  discount_rate: 10, coupon_quantity: 100, expiration_date: '22/12/2033',
                                  user: user)

    delete promotion_path(promotion)

    assert_redirected_to new_user_session_path
    assert Promotion.last
  end

  test 'cannot generate coupons without login' do
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
    assert_not promotion.reload.approved?
    assert_equal 'Não pode ser aprovado pelo criador da promoção', flash[:notice]
  end

  test 'cannot approve without login' do
    user = User.create!(email: 'test@iugu.com.br', password: '123123', name: 'Fulano')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)

    post approve_promotion_path(promotion)
    assert_redirected_to new_user_session_path
    assert_not promotion.reload.approved?
  end

  test 'cannot approve if creator' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)

    post approve_promotion_path(promotion)
    assert_not promotion.reload.approved?
    assert_equal 'Não pode ser aprovado pelo criador da promoção', flash[:notice]
  end

  test 'approver login to approve promotion' do
    user = User.create!(email: 'test@iugu.com.br', password: '123123', name: 'Fulano')
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)

    login_approver
    post approve_promotion_path(promotion)
    assert promotion.reload.approved?
    assert_equal 'Promoção aprovada com sucesso', flash[:notice]
  end

  test 'cannot delete promotion with ative coupons' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    Coupon.create!(code: 'NATAL10-0001', promotion: promotion, status: 0)

    delete promotion_path(promotion)
    assert Promotion.last
    assert_equal 'Falhou - A promoção possui cupons ativos', flash[:notice]
  end
end
