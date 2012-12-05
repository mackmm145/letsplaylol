class AddEmailUnique < ActiveRecord::Migration
  def self.up
  	add_column :posts, :confirmed, :boolean, :default => false
  end

  def self.down
  end
end
