require 'application_system_test_case'

class ViewPromotionsTest < ApplicationSystemTestCase
  include LoginMacros

  test 'view promotions' do
    user = login_user
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
    Promotion.create!(name: 'Cyber Monday', description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15, coupon_quantity: 90,
                      expiration_date: '22/12/2033', user: user)

    visit root_path
    click_on 'Promoções'
    assert_text 'Aguardando aprovação'
    refute_text 'Promoções aprovadas'
    assert_text 'Natal'
    assert_text 'Cyber Monday'
    refute_text 'Carnaval'
  end

  test 'view approved promotions' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)
    Promotion.create!(name: 'Cyber Monday', description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15, coupon_quantity: 90,
                      expiration_date: '22/12/2033', user: user)
    approver = login_approver
    PromotionApproval.create!(promotion: promotion, user: approver)

    visit root_path
    click_on 'Promoções'
    assert_text 'Aguardando aprovação'
    assert_text 'Promoções aprovadas'
    assert_text 'Natal'
    assert_text 'Cyber Monday'
    refute_text 'Carnaval'
  end
  test 'view promotion details' do
    user = login_user
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
    Promotion.create!(name: 'Cyber Monday', description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15, coupon_quantity: 90,
                      expiration_date: '22/12/2033', user: user)

    visit root_path
    click_on 'Promoções'
    click_on 'Cyber Monday'

    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
    assert_text 'CYBER15'
    assert_text '22/12/2033'
    assert_text '90'
  end

  test 'view no promotion are available' do
    login_user
    visit root_path
    click_on 'Promoções'

    assert_text 'Nenhuma promoção cadastrada'
  end

  test 'view promotions and return to home page' do
    user = login_user
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)

    visit root_path
    click_on 'Promoções'
    click_on 'Voltar'

    assert_current_path root_path
  end
  test 'view details and return to promotions page ' do
    user = login_user
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)

    visit root_path
    click_on 'Promoções'
    click_on 'Natal'
    click_on 'Voltar'

    assert_current_path promotions_path
  end

  test "don't view promotion link without login" do
    visit root_path

    refute_link 'Promoções'
  end

  test "don't view promotions using route without login" do
    visit promotions_path

    assert_current_path new_user_session_path
  end

  test "don't view promotions details using route without login" do
    user = User.create!(email: 'test@iugu.com.br', password: '123123', name: 'Fulano')
    promotion = Promotion.create!(name: 'Cyber Monday', description: 'Promoção de Cyber Monday',
                                  code: 'CYBER15', discount_rate: 15, coupon_quantity: 90,
                                  expiration_date: '22/12/2033', user: user)

    visit promotion_path(promotion)

    assert_current_path new_user_session_path
  end

  test 'view approved and pending approval promotions' do
    user = login_user
    promotion1 = Promotion.create!(name: 'Cyber Monday', description: 'Promoção de Cyber Monday',
                                   code: 'CYBER15', discount_rate: 15, coupon_quantity: 90,
                                   expiration_date: '22/12/2033', user: user)

    promotion2 = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                   code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                   expiration_date: '22/12/2033', user: user)
    approver = login_approver
    PromotionApproval.create!(promotion: promotion1, user: approver)

    visit promotions_path

    within 'div#approved' do
      assert_text 'Promoções aprovadas'
      assert_link promotion1.name
      refute_link promotion2.name
    end
    within 'div#pending' do
      assert_text 'Aguardando aprovação'
      assert_link promotion2.name
      refute_link promotion1.name
    end
  end
end
