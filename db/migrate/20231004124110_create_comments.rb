class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.text :content
      t.references :user, null: false, foreign_key: true
      t.references :glyph, null: false, foreign_key: true
      t.references :parent_comment, foreign_key: { to_table: :comments }  # reference to the same table

      t.timestamps
    end
  end
end
