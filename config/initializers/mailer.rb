
if Rails.env.development?
	ActionMailer::Base.delivery_method = :smtp
	ActionMailer::Base.smtp_settings = {
	 :address               => "mail.letsplaylol.net",
	 :port 					=> 25,
	 :domain                => "letsplaylol.net",
	 :user_name             => "donotreply@letsplaylol.net",
	 :password              => ENV['PASSWORD_MAILER_LETSPLAYLOL'],
	 :authentication		=> :login,
	 :enable_starttls_auto	=> false
	}
end

if Rails.env.production?
	ActionMailer::Base.delivery_method = :smtp
	ActionMailer::Base.smtp_settings = {
	 :address               => "mail.letsplaylol.net",
	 :port 					=> 25,
	 :domain                => "letsplaylol.net",
	 :user_name             => "donotreply@letsplaylol.net",
	 :password              => ENV['PASSWORD_MAILER_LETSPLAYLOL'],
	 :authentication		=> :login,
	 :enable_starttls_auto	=> false
	}
end