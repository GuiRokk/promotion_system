require 'application_system_test_case'
include LoginMacros

class DeletePromotionsTest < ApplicationSystemTestCase

  test 'delete a promotion' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)

    visit promotion_path(promotion)
    click_on 'Apagar Promoção'

    assert_current_path promotions_path
    assert_text "Promoção #{promotion.name} apagada com sucesso"
    assert_text "Nenhuma promoção cadastrada"
    refute_link 'Natal'
  end

  test 'delete promotion with a remaining promotion' do
    user = login_user
    Promotion.create!(name: 'Cyber Monday', description: 'Promoção de Cyber Monday',
                      code: 'CYBER15',discount_rate: 15,coupon_quantity: 90,
                      expiration_date: '22/12/2033', user: user)

    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)

    visit promotion_path(promotion)
    click_on 'Apagar Promoção'

    assert_current_path promotions_path
    assert_text "Promoção #{promotion.name} apagada com sucesso"
    refute_link 'Natal'
    assert_link 'Cyber Monday'
  end

  test 'cannot delete promotion with active coupons ' do
    user = login_user
    promotion = Promotion.create!(name: 'Cyber Monday', description: 'Promoção de Cyber Monday',
                      code: 'CYBER15',discount_rate: 15,coupon_quantity: 90,
                      expiration_date: '22/12/2033', user: user)
    approver = login_approver
    PromotionApproval.create!(promotion: promotion, user: approver)

    visit promotion_path(promotion)
    click_on 'Gerar cupons'

    assert_current_path promotion_path(promotion)
    refute_link 'Apagar'
    assert_text 'Ativo', count: promotion.coupon_quantity
  end

  test 'delete promotion with no active coupons ' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 2,
                                  expiration_date: '22/12/2033', user: user)
    approver = login_approver
    PromotionApproval.create!(promotion: promotion, user: approver)

    visit promotion_path(promotion)
    click_on 'Gerar cupons'
    within 'td#action-natal10-0001' do
      click_on "Desativar"
    end
    within 'td#action-natal10-0002' do
      click_on "Desativar"
    end
    click_on 'Apagar Promoção'

    assert_current_path promotions_path
    assert_text "Promoção #{promotion.name} apagada com sucesso"
    refute_link 'Natal'
    refute Coupon.exists?(promotion_id: promotion.id)
  end
end