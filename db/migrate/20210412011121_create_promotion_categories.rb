class CreatePromotionCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :promotion_categories do |t|
      t.references :promotion, null: false, foreign_key: true
      t.references :product_category, null: false, foreign_key: true

      t.timestamps
    end
  end
end
