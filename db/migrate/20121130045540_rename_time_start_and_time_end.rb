class RenameTimeStartAndTimeEnd < ActiveRecord::Migration
  def self.up
  	rename_column :posts, :time_start, :time_zone
  	rename_column :posts, :time_end, :times
  end

  def self.down
  end
end
