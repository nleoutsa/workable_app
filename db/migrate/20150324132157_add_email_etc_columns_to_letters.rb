class AddEmailEtcColumnsToLetters < ActiveRecord::Migration
  def change
    add_column :letters, :ap_email, :string
    add_column :letters, :co_rep, :string
    add_column :letters, :ap_wage, :string
  end
end
