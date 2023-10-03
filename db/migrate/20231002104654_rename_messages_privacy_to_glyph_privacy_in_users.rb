class RenameMessagesPrivacyToGlyphPrivacyInUsers < ActiveRecord::Migration[7.0]
  def change
    rename_column :users, :messages_privacy, :glyph_privacy
  end
end
