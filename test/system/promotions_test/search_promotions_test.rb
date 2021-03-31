require 'application_system_test_case'
include LoginMacros

class SearchPromotionsTest < ApplicationSystemTestCase
  test 'search promotion by term and find results' do
    user = login_user
    xmas = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)
    cyber = Promotion.create!(name: 'Cyber Monday', description: 'Promoção de Cyber Monday',
                      code: 'CYBER15',discount_rate: 15,coupon_quantity: 90,
                      expiration_date: '22/12/2033', user: user)
    christmassy = Promotion.create!(name: 'Natalina', description: 'Promoção de natal',
                      code: 'NATAL11', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)

    visit root_path
    click_on 'Promoções'
    within 'form' do
      fill_in 'query', with: 'natal'
      click_on 'Buscar'
    end

    assert_text xmas.name
    assert_text christmassy.name
    refute_text cyber.name
  end

  test 'search and find no results' do
    user = login_user
    xmas = Promotion.create!(name: 'Natal', description: 'Promoção de Natal',
                      code: 'NATAL10', discount_rate: 10, coupon_quantity: 100,
                      expiration_date: '22/12/2033', user: user)

    visit root_path
    click_on 'Promoções'
    query = 'gggggg'
    within 'form' do
      fill_in 'query', with: query
      click_on 'Buscar'
    end

    assert_text 'Item buscado não encontrado'
    assert_current_path promotions_path(query: query)
    refute_text xmas.name
  end


end