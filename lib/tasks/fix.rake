# encoding: utf-8

namespace :fix do
  desc "Create a default root comment for shares without one"
  task :create_shares_root_comment => :environment do
    Share.all.each do |s|
      if s.comment.nil?
        puts "Find: Share#<#{s._id}>"
        s.create_comment_by_sharer(s.default_root_comment_content)
      end
    end
    puts "Done."
  end

  desc "Recreate the missing source_id attribute in Item"
  task :recreate_missing_source_id => :environment do
    Item.all.each do |i|
      if i.source_id.blank?
        source_id = nil
        i.shares.each { |s| source_id = s.source unless s.source.blank? }
        if source_id.blank?
          puts "Missing source_id: Item#<#{i._id}>"
        else
          i.source_id = source_id
          puts "Add source_id #{source_id}: Item#<#{i._id}>" if i.save
        end
      end
    end
    puts "Done."
  end
end