class PagesController < ApplicationController
	#before_filter :delete_flash

	def home
		p = Post.not_expired
		@posts = p.paginate :page => params[:page], :order => 'updated_at DESC'
	end

	def search_listing
		p = Post.not_expired

		if params[:commit]=="Search"
			p = p.search(params)
		end

		@posts = p.paginate :page => params[:page], :order => 'updated_at DESC'
		render :action => :home
	end

	def search
		@post = Post.new
		@post.server = "NA"
		@post.time_zone = "Pacific Time (US & Canada)"
		@post.game_type = []
		@post.group_type = []
		@post.days_played = []
		@post.times_play = []
		@post.roles_self = []
		@post.roles_looking = []
	end

	def new_listing
		@post = Post.new
		@post.server = "NA"
		@post.time_zone = "Pacific Time (US & Canada)"
		@post.game_type = []
		@post.group_type = []
		@post.days_played = []
		@post.times_play = []
		@post.roles_self = []
		@post.roles_looking = []
		@post.token = random_token

		while @post.token.nil? || (Post.where("token=?", @post.token).first!=nil)
			@post.token = random_token
		end
	end

	def save_listing
		@post = Post.where("token=?", params[:token]).first
		@post = Post.new if @post.nil?
		
		@post.email = params[:email]
		@post.summoner = params[:summoner]
		@post.reddit = params[:reddit]
		@post.elo = params[:elo]
		params[:server] = "NA" if params[:server].blank?
		@post.server = params[:server].upcase
        @post.additional_info = params[:additional_info]

        @post.game_type = game_type_arrayize(params)
        @post.group_type = group_type_arrayize(params)
        @post.roles_self = my_roles_arrayize(params)
        @post.roles_looking = looking_roles_arrayize(params)
        @post.days_played = days_played_arrayize(params)

        @post.time_zone = params[:time_zone]
        @post.times_play = times_arrayize(params)
        @post.token = params[:token]
        @post.expiration = Time.now + 7.days
        if @post.save
        	if @post.created_at == @post.updated_at
	        	flash[:success]="Listing has been created."
	        	ListingMailer.listing_saved(@post, "created").deliver unless Rails.env.development?
	        else
	        	flash[:success]="Listing has been updated."
	        	ListingMailer.listing_saved(@post, "updated").deliver unless Rails.env.development?
	        end
        else
        	flash[:error]="Something went wrong."
        	render :action=> :edit_listing
        end
	end

	def edit_listing
		delete_flash

		if params[:commit]=="Edit" || params[:commit].blank?
			@post = Post.where("token=?", params[:token]).first
			if @post.nil?
				@post = Post.new
				@post.server = "NA"
				@post.game_type = []
				@post.group_type = []
				@post.days_played = []
				@post.times_play = []
				@post.roles_self = []
				@post.roles_looking = []
				@post.token = random_token

				while @post.token.nil? || (Post.where("token=?", @post.token).first!=nil)
					@post.token = random_token
				end

				flash[:error]="Something went wrong. Listing was not found. Please create a new listing."		
			end
		elsif params[:commit]=="Delete"
			@post = Post.where("token=?", params[:token]).first
			unless @post.nil?
				@post.destroy
				ListingMailer.listing_deleted(@post).deliver unless Rails.env.development?
				flash[:success]="#{@post.summoner}, your listing has been permanently deleted. You will shortly recieve a confirmation email."
				redirect_to "/delete_listing"
			else
				flash[:error]="Something went wrong. Listing was not deleted."
				redirect_to "/delete_listing"
			end
		else
			redirect_to "/"
		end


	end

	def examine_listing
		@post = Post.where("id=?", params[:id]).first
	end

	def prolong_listing
		unless params[:token].nil?
			@post = Post.where("token=?", params[:token]).first

			unless @post.nil?
				@post.expiration = Time.now + 7.days
				if @post.save
					flash[:success]="Listing has been extended for another 7 days!"
				else
					flash[:error]="Something went wrong. Your listing has not been extended"
				end
			else
				flash[:error]="Listing not found"
			end
		else
			flash[:error]="Wrong parameters"
		end

		redirect_to "/"
	end


	def run_sweep
	end

	def disclaimer
	end

private

	def random_token 
		SecureRandom.hex
	end

	def delete_flash
		flash.delete(:error)
		flash.delete(:success)
	end

	def game_type_arrayize(p)
		a = []
		a << "sr" if p[:sr]
		a << "tt" if p[:tt]
		a << "dom" if p[:dom]

		return a
	end

	def group_type_arrayize(p)
		a = []

		a << "duoq" if p[:duoq]
		a << "normals" if p[:normals]
		a << "team" if p[:team]

		return a
	end

	def my_roles_arrayize(p)
		a = []

		a << "top" if p[:my_role_top]
		a << "jungle" if  p[:my_role_jungle]
		a << "mid" if p[:my_role_mid]
		a << "adc" if  p[:my_role_adc]
		a << "support" if p[:my_role_support]

		return a
	end

	def looking_roles_arrayize(p)
		a = []

		a << "top" if p[:looking_role_top]
		a << "jungle" if  p[:looking_role_jungle]
		a << "mid" if p[:looking_role_mid]
		a << "adc" if  p[:looking_role_adc]
		a << "support" if p[:looking_role_support]

		return a
	end

	def days_played_arrayize(p)
		a = []
		["mon", "tue", "wed", "thu", "fri", "sat", "sun"].each do |d|
			a << d if p[d.to_sym]
		end 
		return a
	end

	def times_arrayize(p)
		offset = ActiveSupport::TimeZone[@post.time_zone].utc_offset / 3600
		a = []
		(0..23).each do |t|
			a << t if p[ ("time"+t.to_s).to_sym ]
		end

		b = []
		a.each do |t|
			t = t - offset

			t = t - 24 if t > 23  #adjusts the times so that it's always saved GMT
			t = t + 24 if t < 0
			b << t
		end

		return b
	end
end
