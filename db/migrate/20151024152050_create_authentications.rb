class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.string :provider
      t.string :url
      t.string :uid
      t.string :token
      t.references :user, index: true

      t.timestamps null: false
    end
  end
end
