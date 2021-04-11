json.set! :id, @promotion.id
json.set! :name, @promotion.name
json.set! :description, @promotion.description
json.set! :code, @promotion.code
json.set! :coupon_quantity, @promotion.coupon_quantity
json.set! :discount_rate, number_to_percentage(@promotion.discount_rate, precision: 2, separator: ',')
json.set! :expiration_date, I18n.l(@promotion.expiration_date)
json.set! :created_at, I18n.l(@promotion.created_at)
json.set! :updated_at, I18n.l(@promotion.updated_at)
json.set! :creator, @promotion.user_id
