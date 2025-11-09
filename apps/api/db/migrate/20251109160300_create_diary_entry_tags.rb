# frozen_string_literal: true

class CreateDiaryEntryTags < ActiveRecord::Migration[8.1]
  def change
    create_table :diary_entry_tags do |t|
      t.references :diary_entry, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end

    add_index :diary_entry_tags, %i[diary_entry_id tag_id], unique: true, name: "idx_diary_entry_tags_uniqueness"
  end
end
