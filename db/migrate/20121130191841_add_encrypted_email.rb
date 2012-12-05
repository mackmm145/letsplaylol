class AddEncryptedEmail < ActiveRecord::Migration
  def self.up
  	add_column :posts, :encrypted_e, :string
  	add_column :posts, :encrypted_iv, :string
  	remove_column :posts, :email
  end

  def self.down
  end
end
