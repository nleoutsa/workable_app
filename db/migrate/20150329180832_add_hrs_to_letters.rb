class AddHrsToLetters < ActiveRecord::Migration
  def change
    add_column :letters, :hrs, :string
  end
end
