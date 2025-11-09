# frozen_string_literal: true

class CreateWeeklyDigests < ActiveRecord::Migration[8.1]
  def change
    create_table :weekly_digests do |t|
      t.references :user, null: false, foreign_key: true
      t.date :week_of, null: false
      t.text :summary, null: false
      t.jsonb :highlights, default: []
      t.jsonb :mood_trends, default: {}
      t.datetime :published_at

      t.timestamps
    end

    add_index :weekly_digests, %i[user_id week_of], unique: true
  end
end
