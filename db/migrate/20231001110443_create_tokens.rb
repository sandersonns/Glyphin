class CreateTokens < ActiveRecord::Migration[7.0]
  def change
    create_table :tokens do |t|
      t.string :token_value
      t.references :issuer, references: :users, null: false, foreign_key: { to_table: :users }
      t.references :recipient, references: :users, null: false, foreign_key: { to_table: :users }      
      t.datetime :expires_at

      t.timestamps
    end
    add_index :tokens, :token_value
  end
end
