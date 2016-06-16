require "./db/setup"
require "./lib/all"

class EncryptPasswords < ActiveRecord::Migration
  def change
    User.find_each do |u|
      puts "Encrypting #{u.email}"
      u.encrypt
      u.save!
    end
  end
end
