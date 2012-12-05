class AddIndexToToken < ActiveRecord::Migration
  def self.up
  	add_index :posts, :token
  end

  def self.down
  end
end
