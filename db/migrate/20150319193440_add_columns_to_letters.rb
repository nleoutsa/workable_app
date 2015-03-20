class AddColumnsToLetters < ActiveRecord::Migration
  def change
    add_column :letters, :co_city_state_zip, :string
    add_column :letters, :ap_city_state_zip, :string
    add_column :letters, :start_date, :date
    add_column :letters, :supervisor, :string
    add_column :letters, :expiry_date, :date
  end
end
