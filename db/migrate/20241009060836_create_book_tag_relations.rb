class CreateBookTagRelations < ActiveRecord::Migration[6.1]
  def change
    create_table :book_tag_relations do |t|
      t.references :book, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
    add_index :book_tag_relations, [:book_id, :tag_id], unique: true
  end
end
