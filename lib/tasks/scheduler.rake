  task :maintenance => :environment do
    #send emails to listing that are about to expire
    i = 0
    Post.all_about_to_expire.each do |p|
      ListingMailer.listing_about_to_expire(p).deliver
      i += 1
    end
    puts "#{i} emails sent"

    #delete listing expired past 30 days
    j =0
    Post.all_expired_for_30.each do |p|
      p.destroy
      j+= 1
    end
    puts "Cleared #{i} listings expired past 30 days"

    ListingMailer.test_mail("finished #{Time.now}", i, j).deliver
  end

  task :clear_database => :environment do
    Post.destroy_all
    puts "posts has been cleared."
    ListingMailer.test_mail("database has been cleared #{Time.now}", "", "").deliver
  end