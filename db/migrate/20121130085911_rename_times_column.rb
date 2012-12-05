class RenameTimesColumn < ActiveRecord::Migration
  def self.up
  	rename_column :posts, :times, :times_play
  end

  def self.down
  end
end
