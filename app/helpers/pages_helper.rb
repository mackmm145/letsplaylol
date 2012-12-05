module PagesHelper

	def game_type_to_readable(post)
		s = ""

		unless post.game_type.nil?
			s = s + "Summoner's Rift" if post.game_type.include? "sr"
			s = s + " / " unless s == ""
			s = s + "Twisted Treeline" if post.game_type.include? "tt"
			s = s + " / " unless s == ""
			s = s + "Dominion" if post.game_type.include? "dom"
			s = s.chomp(' / ').chomp(' / ').gsub("/  /", "/")
		end
		return s
	end

	def group_type_to_readable(post)
		s = ""

		unless post.group_type.nil?
			s = s + "DuoQ" if post.group_type.include? "duoq"
			s = s + " / " unless s == ""
			s = s + "Normals" if post.group_type.include? "normals"
			s = s + " / " unless s == ""
			s = s + "Team" if post.group_type.include? "team"
			s = s.chomp(' / ').chomp(' / ').gsub("/  /", "/")
		end

		return s
	end

	def roles_to_readable(role)
		s = ""

		unless role.nil?
			s = s + "Top" if role.include? "top"
			s = s + " / " unless s == ""
			s = s + "Jungle" if role.include? "jungle"
			s = s + " / " unless s == ""
			s = s + "Mid" if role.include? "mid"
			s = s + " / " unless s == ""
			s = s + "ADC" if role.include? "adc"
			s = s + " / " unless s == ""
			s = s + "Support" if role.include? "support"
		end
		4.times { s = s.chomp(' / ').gsub("/  /", "/") }

		return s
	end

	def days_to_readable(post)
		s = ""

		unless post.days_played.nil?	
			["mon", "tue", "wed", "thu", "fri", "sat", "sun"].each do |d|
				s = s + d.titleize if post.days_played.include? d
				s = s + " / " unless s == ""
			end

			7.times { s = s.chomp(' / ').gsub("/  /", "/") }
		end
		return s
	end

	def times_to_readable(post)
		#god this is terrible... refactor!!!

		unless post.time_zone.blank?
			offset = ActiveSupport::TimeZone[post.time_zone].utc_offset / 3600
		else
			offset = 0
		end

		b = []
		c = []
times = ["12am (0:00)", 
"1am (1:00)", "2am (2:00)", "3am (3:00)", "4am (4:00)","5am (5:00)","6am (6:00)",
"7am (7:00)","8am (8:00)","9am (9:00)","10am (10:00)",
"11am (11:00)","12pm (12:00)","1pm (13:00)","2pm (14:00)",
"3pm (15:00)","4pm (16:00)","5pm (17:00)","6pm (18:00)","7pm (19:00)",
"8pm (20:00)","9pm (21:00)","10pm (22:00)","11pm (23:00)"]
		
		s = ""

		unless post.times_play.nil?
			post.times_play.each do |t|
				i = t.to_s.to_i + offset
				i = i - 24 if i > 23  #adjusts the times so that it's always saved GMT
				i = i + 24 if i < 0
				b << times[i]
			end

			times.each_with_index do |k, i|
			  s = s + k if b.include? k
			  s = s + " / " unless s == ""
			  if b.include? k
			  	c << i
			  else
			  	c << nil
			  end
			end

			d = []
			c.each_with_index do |v, i|
				unless v.nil?
					c[i+1] = "-" if !c[i+1].nil? && !c[i+2].nil?
				end
			end

			c.each do |v|
				v = "" if v.nil?
				v = times[v.to_i] if is_integer(v)
			
				d << v
			end

			s = d.join.gsub(")", ") / ").gsub("/ -","-")

			23.times {s = s.chomp(' / ').gsub("/  /", "/").gsub("--", "-")}
			s= s.gsub("-", " -- ").gsub("/", "<br />")

			#check across midnight
			#s = "what" if s.include?("12am (0:00)  --")
			if s.include?("12am (0:00)  --") && s.include?("-- 11pm (23:00)")
				a = s.split("<br />")
				f = a.shift
				a << f
				s = a.join("<br />")
				s = s.gsub(" -- 11pm (23:00)<br />12am (0:00)  -- ", " -- ")
			else

				if s.include?("12am (0:00)") && s.include?("11pm (23:00)")
					if s.include?("1am (1:00)") && s.include?("10pm (22:00)")
						a = s.split("<br />")
						a = a.drop(1) #drop 12am
						f = a.shift #drop 1am into f
						a = a[0..-2]
						a << f
						s = a.join("<br />")
						s= s.gsub("10pm (22:00) <br /> 1am (1:00)", "10pm (22:00) -- 1am (1:00)")
					else
						if s.include?("1am (1:00)")
							a = s.split("<br />")
							a = a.drop(1) #drop 12am
							f = a.shift #drop 1am into f
							a << f
							s = a.join("<br />")
							#s = s.gsub(" ", "#")
							s= s.gsub("11pm (23:00)<br /> 1am (1:00)", "11pm (23:00) -- 1am (1:00)")
						end

						if s.include?("10pm (22:00)")
							a = s.split("<br />")
							f = a.shift #drop 12am into f
							a = a[0..-2]
							a << f
							s = a.join("<br />")
							#s = s.gsub(" ", "#")
							s= s.gsub("10pm (22:00) <br />12am (0:00)", "10pm (22:00) -- 12am (0:00)")
						end

						if s.include?(" -- 11pm (23:00)") && s.include?("12am (0:00)")
							a = s.split("<br />")
							f = a.shift
							a << f
							s = a.join("<br />")
							s = s.gsub(" -- 11pm (23:00)<br />" ," --")
						end
						if s.include?("11pm (23:00)") && s.include?("12am (0:00)  --")
							a = s.split("<br />")
							f = a.shift
							a << f
							s = a.join("<br />")
							s = s.gsub("<br />12am (0:00)  --", "--") 
						end

						s = s.gsub("-- 12am (0:00)  --", "--") if s.include?("-- 12am (0:00)  --")
						s = s.gsub("-- 11pm (23:00) --", "--") if s.include?("-- 11pm (23:00) --")
					end
				end
			end


			s = "All day!" if post.times_play.size > 20
		end

		return s
	end

	def is_integer(i)
		true if Integer(i) rescue false
	end

	def time_zone_offset(i, time_zone)
		offset = ActiveSupport::TimeZone[time_zone].utc_offset / 3600
		i -= offset
		i = i - 24 if i > 23  #adjusts the times so that it's always saved GMT
		i = i + 24 if i < 0

		return i
	end

	def title0_for_listing(p)
		s = "<b>[#{p.server}]</b>  " + p.summoner 
	end

	def title3_for_listing(p)
		s = " (Elo: " + p.elo + ")"
	end

	def title1_for_listing(p)
		s =  game_type_to_readable(p)
		s += " <b>(" + group_type_to_readable(p) + ")</b> "
	end

	def title2_for_listing(p)
		s = roles_to_readable(p.roles_self)
		
	end

	def title4_for_listing(p)
		s = "(" + p.time_zone.to_s + ")"
	end

	def title5_for_listing(p)
		s = times_to_readable(p)
	end
end
