class AddUniquenessNameToPromotion < ActiveRecord::Migration[6.1]
  def change
    add_index :promotions, :name, unique: true
  end
end
