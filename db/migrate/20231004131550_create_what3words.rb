class CreateWhat3words < ActiveRecord::Migration[7.0]
  def change
    create_table :what3words do |t|
      t.string :address
      t.decimal :latitude
      t.decimal :longitude

      t.timestamps
    end
  end
end
