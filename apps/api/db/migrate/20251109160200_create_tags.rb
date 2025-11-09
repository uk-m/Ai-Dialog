# frozen_string_literal: true

class CreateTags < ActiveRecord::Migration[8.1]
  def change
    create_table :tags do |t|
      t.string :name, null: false
      t.string :category
      t.text :description

      t.timestamps
    end

    add_index :tags, :name, unique: true
  end
end
