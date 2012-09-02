require 'amazon/ecs'

module AmazonHelper

class AmazonEcs

  def test

  Amazon::Ecs.configure do |options|
      options[:associate_tag] = 'ixiangli-23'
      options[:AWS_access_key_id] = 'AKIAIZPTA7Y3DFTVKL2Q'
      options[:AWS_secret_key] = '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'
  end


  #res = Amazon::Ecs.item_search('ruby', {:response_group => 'Medium', :sort => 'salesrank'})
  #res = Amazon::Ecs.item_search('ruby', :country => 'cn')
  res = Amazon::Ecs.item_lookup( :ASIN => 'B004FLK6WM', :country => 'cn', :IncludeReviewsSummary => 'true')

  end

end
end
