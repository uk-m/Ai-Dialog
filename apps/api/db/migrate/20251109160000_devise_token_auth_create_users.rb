# frozen_string_literal: true

class DeviseTokenAuthCreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table(:users) do |t|
      ## Required
      t.string :provider, null: false, default: "email"
      t.string :uid, null: false, default: ""
      t.string :email, null: false, default: ""

      ## Database authenticatable
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email

      ## Tokens
      t.jsonb :tokens, default: {}

      ## Profile
      t.string :name
      t.string :nickname
      t.string :avatar_url
      t.string :time_zone, default: "Asia/Tokyo"
      t.jsonb :preferences, default: {}

      t.timestamps null: false
    end

    add_index :users, :email, unique: true
    add_index :users, %i[uid provider], unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token, unique: true
  end
end
