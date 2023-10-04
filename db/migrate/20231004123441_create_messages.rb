class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.text :content
      t.references :user, null: false, foreign_key: true  # sender
      t.references :recipient, null: false, foreign_key: { to_table: :users }  # recipient

      t.timestamps
    end
  end
end
