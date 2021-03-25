require 'application_system_test_case'

class PromotionsTest < ApplicationSystemTestCase
  test 'view promotions' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')
    Promotion.create!(name: 'Cyber Monday', description: 'Promoção de Cyber Monday',
                      code: 'CYBER15',discount_rate: 15,coupon_quantity: 90,
                      expiration_date: '22/12/2033')

    visit root_path
    click_on 'Promoções'
    
    assert_text 'Natal'
    assert_text 'Promoção de Natal'
    assert_text '10,00%'
    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
  end

  test 'view promotion details' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')
    Promotion.create!(name: 'Cyber Monday', description: 'Promoção de Cyber Monday',
                      code: 'CYBER15',discount_rate: 15,coupon_quantity: 90,
                      expiration_date: '22/12/2033')

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

  test 'no promotion are available' do
    visit root_path
    click_on 'Promoções'

    assert_text 'Nenhuma promoção cadastrada'
  end

  test 'view promotions and return to home page' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')

    visit root_path
    click_on 'Promoções'
    click_on 'Voltar'

    assert_current_path root_path
  end

  test 'view details and return to promotions page' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')

    visit root_path
    click_on 'Promoções'
    click_on 'Natal'
    click_on 'Voltar'

    assert_current_path promotions_path
  end

  test 'create promotion' do
    visit root_path
    click_on 'Promoções'
    click_on 'Registrar uma promoção'
    fill_in 'Nome', with: 'Cyber Monday'
    fill_in 'Descrição', with: 'Promoção de Cyber Monday'
    fill_in 'Código', with: 'CYBER15'
    fill_in 'Desconto', with: '15'
    fill_in 'Quantidade de cupons', with: '90'
    fill_in 'Data de término', with: '12/22/2033'
    click_on 'Criar Promoção'

    assert_current_path promotion_path(Promotion.last)
    assert_text 'Cyber Monday'
    assert_text 'Promoção de Cyber Monday'
    assert_text '15,00%'
    assert_text 'CYBER15'
    assert_text '22/12/2033'
    assert_text '90'
    assert_link 'Voltar'
  end

  test 'create and attributes cannot be blank' do
    visit root_path
    click_on 'Promoções'
    click_on 'Registrar uma promoção'
    click_on 'Criar Promoção'

    assert_text 'não pode ficar em branco', count: 5
  end

  test 'create and name/code must be unique' do
    Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033')

    visit root_path
    click_on 'Promoções'
    click_on 'Registrar uma promoção'
    fill_in 'Nome', with: 'Natal'
    fill_in 'Código', with: 'NATAL10'
    click_on 'Criar Promoção'

    assert_text 'já está em uso', count: 2
  end

  test "generate coupons for a promotion" do

    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033')

    visit promotion_path(promotion)
    click_on 'Gerar cupons'

    assert_text 'Cupons gerados com sucesso'
    assert_no_link 'Gerar cupons'
    assert_no_text 'NATAL10-0000'
    assert_text    'NATAL10-0001'
    assert_text    'NATAL10-0100'
    assert_no_text 'NATAL10-0101'
    assert_no_link 'Editar promoção'
  end

  test 'user edits a promotion' do
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033')

    visit promotion_path(promotion)
    click_on "Editar promoção"
    fill_in 'Nome', with: 'Halloween'
    click_on 'Atualizar Promoção'

    assert_text 'Promoção editada com sucesso'
    assert_text 'Halloween'
    assert_no_link 'Natal'
  end

  test 'user edits a promotion with blanks' do
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033')

    visit promotion_path(promotion)
    click_on "Editar promoção"
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
    Promotion.create!(name: 'Cyber Monday', description: 'Promoção de Cyber Monday',
                      code: 'CYBER15',discount_rate: 15,coupon_quantity: 90,
                      expiration_date: '22/12/2033')

    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033')

    visit promotion_path(promotion)
    click_on "Editar promoção"
    fill_in 'Nome', with: 'Cyber Monday'
    fill_in 'Código', with: 'CYBER15'

    click_on 'Atualizar Promoção'
    assert_text 'já está em uso', count: 2
  end

  test 'delete promotion' do
    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033')

    visit promotion_path(promotion)
    click_on 'Apagar promoção'

    assert_current_path promotions_path
    assert_text "Promoção #{promotion.name} apagada com sucesso"
    assert_text "Nenhuma promoção cadastrada"
    assert_no_link 'Natal'
  end

  test 'delete promotion with existing promotion' do
    Promotion.create!(name: 'Cyber Monday', description: 'Promoção de Cyber Monday',
                      code: 'CYBER15',discount_rate: 15,coupon_quantity: 90,
                      expiration_date: '22/12/2033')

    promotion = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033')

    visit promotion_path(promotion)
    click_on 'Apagar promoção'

    assert_current_path promotions_path
    assert_text "Promoção #{promotion.name} apagada com sucesso"
    assert_no_link 'Natal'
    assert_link 'Cyber Monday'
  end

  test 'delete promotion with coupons' do
    promotion1 = Promotion.create!(name: 'Cyber Monday', description: 'Promoção de Cyber Monday',
                      code: 'CYBER15',discount_rate: 15,coupon_quantity: 90,
                      expiration_date: '22/12/2033')

    promotion2 = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                                  code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                                  expiration_date: '22/12/2033')

    visit promotion_path(promotion1)
    click_on 'Gerar cupons'
    visit promotion_path(promotion2)
    click_on 'Gerar cupons'
    click_on 'Apagar promoção'

    assert_current_path promotions_path
    assert_text "Promoção #{promotion2.name} apagada com sucesso"
    assert_no_link 'Natal'
    refute Coupon.exists?(promotion_id: promotion2.id)
  end

  test "don't view promotion link without login" do
    visit root_path
    
    assert_no_link 'Promoções'
  end

  #test 'view promotions without login' do
 # 
 # end
end