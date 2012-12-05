class Post < ActiveRecord::Base
      cattr_reader :per_page
      @@per_page = 10

      serialize :game_type
      serialize :group_type
      serialize :days_played
      serialize :times_play
      serialize :roles_self
      serialize :roles_looking

      attr_accessible :email, :summoner, :reddit, :elo, :title, :server, :roles_self, 
                      :roles_looking, :game_type, :group_type, :days_played, :time_zone, :times_play, :additional_info, :do_not_email, :token
      
      
      iv_key = 'Ee2ivX0'
      attr_encrypted :iv, :key => iv_key
      attr_encrypted :e, :key => 'mgE+elQ5cfG2XqmgE+elQ5hPbYz1Ad3Dv'
     
      validates :email, :email_format => {:message => 'you entered is not valid'}
      validates :summoner, :server, :email, :presence => true

  def email; get_encrypt_field(self.e) end
  def email=(e); self.e = set_encrypt_field(e) end

  def self.not_expired
    where("expiration >= ?", Time.now)
  end

  def self.all_about_to_expire
    where("expiration >= ? AND expiration < ?", Time.now + 1.days, Time.now + 2.days)
  end

  def self.all_expired_for_30
    where("expiration <= ?", Time.now - 30.days)
  end

private
  def two_random
      ActiveSupport::SecureRandom.base64(4)[0,5]
  end
  
  def get_encrypt_field(val)
      val[5..(val.length-1)] unless val.nil?
  end

  def set_encrypt_field(val)
      self.iv = self.iv || ActiveSupport::SecureRandom.base64(10)
      two_random + val.to_s
  end
end