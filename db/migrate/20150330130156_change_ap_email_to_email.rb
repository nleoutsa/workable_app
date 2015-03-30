class ChangeApEmailToEmail < ActiveRecord::Migration
  def change
    rename_column :letters, :ap_email, :email
  end
end
