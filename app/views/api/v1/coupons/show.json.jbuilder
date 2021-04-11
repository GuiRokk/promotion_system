json.set! :code, @coupon.code
json.set! :discount_rate, number_to_percentage(@coupon.discount_rate, precision: 2, separator: ',')
json.set! :expiration_date, I18n.l(@coupon.expiration_date)
json.set! :status, @coupon.status
