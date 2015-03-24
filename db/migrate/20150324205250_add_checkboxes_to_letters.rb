class AddCheckboxesToLetters < ActiveRecord::Migration
  def change
    add_column :letters, :medical, :boolean
    add_column :letters, :dental, :boolean
    add_column :letters, :bonus, :boolean
    add_column :letters, :commission, :boolean
    add_column :letters, :equity, :boolean
    add_column :letters, :drug_test, :boolean
    add_column :letters, :bg_check, :boolean
  end
end
