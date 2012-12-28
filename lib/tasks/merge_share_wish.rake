namespace :db_migrate do
  desc "Merge TYPE_SHARE and TYPE_WISH"
  task :merge_share_and_wish => :environment do
    Share.all.each do |s|
      if s.share_type == 'SHA'
        puts "Find: Share#<#{s._id}>"
        s.alter_type('WIS')
        s.save
      end
    end
    puts "Done."
  end
end