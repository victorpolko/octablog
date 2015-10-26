class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name_en, default: '', null: false
      t.string :name_ru, default: '', null: false

      t.timestamps null: false
    end
  end
end
