class RenameAndChangeGlyphPrivacyInUsers < ActiveRecord::Migration[7.0]
  def up
    # Rename glyph_privacy to default_glyph_privacy
    rename_column :users, :glyph_privacy, :default_glyph_privacy

    # Remove the default value of the column
    change_column_default :users, :default_glyph_privacy, nil
    
    # Convert all boolean values to integer (assuming: true -> 2, false -> 0)
    User.where(default_glyph_privacy: true).update_all(default_glyph_privacy: 2)
    User.where(default_glyph_privacy: false).update_all(default_glyph_privacy: 0)

    # Convert the column type to integer
    change_column :users, :default_glyph_privacy, 'integer USING CAST(default_glyph_privacy AS integer)'

    # Set the default to 0 (Private)
    change_column_default :users, :default_glyph_privacy, 0
  end

  def down
    # Convert integer values back to boolean
    User.where(default_glyph_privacy: 2).update_all(default_glyph_privacy: true)
    User.where(default_glyph_privacy: 0).update_all(default_glyph_privacy: false)

    # Convert column type back to boolean
    change_column :users, :default_glyph_privacy, 'boolean USING CAST(default_glyph_privacy AS boolean)'

    # Rename default_glyph_privacy back to glyph_privacy
    rename_column :users, :default_glyph_privacy, :glyph_privacy
  end
end
