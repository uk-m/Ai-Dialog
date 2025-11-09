# frozen_string_literal: true

class CreateDiaryEntries < ActiveRecord::Migration[8.1]
  def change
    create_table :diary_entries do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false
      t.text :body
      t.text :ai_summary
      t.string :mood
      t.string :status, null: false, default: "draft"
      t.date :journal_date, null: false
      t.datetime :published_at
      t.text :extracted_text
      t.jsonb :labels, default: []
      t.jsonb :metadata, default: {}
      t.string :source_filename
      t.string :language, default: "ja"
      t.string :timezone, default: "Asia/Tokyo"

      t.timestamps
    end

    add_index :diary_entries, %i[user_id journal_date]
    add_index :diary_entries, :status
  end
end
