class AddCoNameToLetters < ActiveRecord::Migration
  def change
    add_column :letters, :co_name, :string
    add_column :letters, :co_address_1, :string
    add_column :letters, :co_address_2, :string
    add_column :letters, :ap_name, :string
    add_column :letters, :ap_address_1, :string
    add_column :letters, :ap_address_2, :string
    add_column :letters, :pos_title, :string
  end
end
