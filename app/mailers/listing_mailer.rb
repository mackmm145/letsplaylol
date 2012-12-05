class ListingMailer < ActionMailer::Base
  default :from => "LetsPlayLoL messenger <donotreply@LetsPlayLoL.com>"
  
  def listing_saved(p, status)
    @post = p
    @status = status
    set_host_address
    mail(:to => "#{p.summoner} <#{p.email}>", :subject => "Your listing has been #{status} at #{@host_name}")
  end

  def listing_about_to_expire(p)
  	@post = p
  	set_host_address
  	mail(:to => "#{p.summoner} <#{p.email}>", :subject => "Your listing is about to expire at #{@host_name}")
  end

  def listing_deleted(p)
  	@post=p
  	set_host_address
  	mail(:to => "#{p.summoner} <#{p.email}>", :subject => "Your Listing has been permanently deleted at #{@host_name}")
  end

  def test_mail(t, emails_sent, expired_listings)
    @emails_sent = emails_sent
    @expired_listings = expired_listings
    mail(:to => ENV['MY_EMAIL'], :subject => "scheduled maintenance task has #{t}")
  end

private

	def set_host_address
    @host_name = "LetsPlayLoL.net"
		if Rails.env.development?
			@host = "http://127.0.0.1:3000"
		elsif Rails.env.production?
			@host = "http://www.letsplaylol.net"
		else
			@host = "http://127.0.0.1:3000"
		end
	end
end