class CreateArticles < ActiveRecord::Migration
  class << self
    def up
      create_table :articles do |t|
        t.string :name_en, default: '', null: false
        t.string :name_ru, default: '', null: false

        t.integer :rating, default: 0, null: false
        t.text :text, default: '', null: false

        t.references :user, index: true
        t.references :category, index: true

        t.timestamps null: false
      end

      add_attachment :articles, :cover
    end

    def down
      remove_attachment :articles, :cover

      drop_table :articles
    end
  end
end
