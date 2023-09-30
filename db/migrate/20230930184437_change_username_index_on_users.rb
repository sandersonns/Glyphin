class ChangeUsernameIndexOnUsers < ActiveRecord::Migration[7.0]
  def change
    # Remove the current case-sensitive index
    remove_index :users, :username

    # Add a new case-insensitive index
    add_index :users, "lower(username)", unique: true, name: "index_users_on_lower_username"
  end
end
