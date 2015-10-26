class CreateUsers < ActiveRecord::Migration
  class << self
    def up
      create_table(:users) do |t|
        t.string :first_name, default: '', null: false
        t.string :last_name,  default: '', null: false

        ## Database authenticatable
        t.string :email,              default: '', null: false
        t.string :encrypted_password, default: '', null: false

        ## Recoverable
        t.string   :reset_password_token
        t.datetime :reset_password_sent_at

        ## Rememberable
        t.datetime :remember_created_at

        # For OAuth tracking
        t.string :last_sign_in_via

        t.timestamps
      end

      add_index :users, :email,                unique: true
      add_index :users, :reset_password_token, unique: true

      add_attachment :users, :avatar
    end

    def down
      remove_attachment :users, :avatar

      drop_table :users
    end
  end
end
