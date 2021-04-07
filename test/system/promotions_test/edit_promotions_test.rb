require 'application_system_test_case'

class EditPromotionsTest < ApplicationSystemTestCase
  include LoginMacros

  test 'user edits a promotion' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)

    visit promotion_path(promotion)
    click_on 'Editar Promoção'
    fill_in 'Nome', with: 'Halloween'
    click_on 'Atualizar Promoção'

    assert_text 'Promoção editada com sucesso'
    assert_text 'Halloween'
    refute_link 'Natal'
  end

  test 'user edits a promotion with blanks' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)

    visit promotion_path(promotion)
    click_on 'Editar Promoção'
    fill_in 'Nome', with: ''
    fill_in 'Descrição', with: ''
    fill_in 'Código', with: ''
    fill_in 'Desconto', with: ''
    fill_in 'Quantidade de cupons', with: ''
    fill_in 'Data de término', with: ''
    click_on 'Atualizar Promoção'

    assert_text 'não pode ficar em branco', count: 5
  end

  test 'user edits a promotion with repeated name/code' do
    user = login_user
    Promotion.create!(name: 'Cyber Monday', description: 'Promoção de Cyber Monday',
                      code: 'CYBER15', discount_rate: 15, coupon_quantity: 90,
                      expiration_date: '22/12/2033', user: user)

    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033', user: user)

    visit promotion_path(promotion)
    click_on 'Editar Promoção'
    fill_in 'Nome', with: 'Cyber Monday'
    fill_in 'Código', with: 'CYBER15'

    click_on 'Atualizar Promoção'
    assert_text 'já está em uso', count: 2
  end

  test 'user reactivates coupon' do
    user = login_user
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 2,
                                  expiration_date: '22/12/2033', user: user)
    approver = login_approver
    PromotionApproval.create!(promotion: promotion, user: approver)

    visit promotion_path(promotion)
    click_on 'Gerar cupons'
    within 'td#action-natal10-0001' do
      click_on 'Desativar'
    end
    within 'td#action-natal10-0002' do
      click_on 'Desativar'
    end
    within 'td#action-natal10-0001' do
      click_on 'Reativar'
    end

    within 'td#action-natal10-0001' do
      assert_link 'Desativar'
      refute_link 'Reativar'
    end
    assert_text 'Ativo', count: 1
    assert_text 'Desativado', count: 1
  end
end
