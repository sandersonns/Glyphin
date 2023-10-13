class AddGlyphPrivacyToGlyphs < ActiveRecord::Migration[7.0]
  def change
    # Add glyph_privacy column to glyphs table with default 0 ("Private")
    add_column :glyphs, :glyph_privacy, :integer, default: 0
  end
end
