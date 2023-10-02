class CreateGlyphs < ActiveRecord::Migration[7.0]
  def change
    create_table :glyphs do |t|
      t.string :title
      t.text :content
      t.integer :what3words_address_id
      t.integer :user_id

      t.timestamps
    end
  end
end
