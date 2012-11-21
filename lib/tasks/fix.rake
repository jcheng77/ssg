# encoding: utf-8

namespace :fix do
  desc "Create a default root comment for shares without one"
  task :create_shares_root_comment => :environment do
    Share.all.each do |s|
      if s.comment.nil?
        puts "Find: Share#<#{s._id}>"
        s.create_comment_by_sharer("分享自@菠萝点蜜 boluo.me")
      end
    end
    puts "Done."
  end
end