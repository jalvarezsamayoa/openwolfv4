class CleanupDeviseFields < ActiveRecord::Migration

  def change
    begin
    change_table(:usuarios) do |t|
      t.change :email, :string, :default => "", :null => false
      t.change :encrypted_password, :string, :default => "", :null => false
      t.datetime "reset_password_sent_at"
      t.remove :password_salt
    end
  rescue
      puts "Cleanup up devise... skip"
  end
  end

end

