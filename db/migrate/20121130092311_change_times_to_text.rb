class ChangeTimesToText < ActiveRecord::Migration
  def self.up
  	change_column :posts, :times_play, :text
  end

  def self.down
  end
end
