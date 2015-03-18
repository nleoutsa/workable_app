class CreateLetters < ActiveRecord::Migration
  def change
    create_table :letters do |t|

      t.timestamps null: false
    end
  end
end
