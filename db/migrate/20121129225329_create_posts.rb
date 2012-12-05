class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.string :title
      t.string :summoner
      t.string :reddit
      t.string :email
      t.string :token
      t.string :server
      t.string :elo
      t.string :roles_self
      t.string :roles_looking
      t.string :game_type
      t.string :group_type
      t.string :days_played
      t.string :time_start
      t.string :time_end
      t.text :additional_info
      t.boolean :do_not_email
      t.datetime :expiration
      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
