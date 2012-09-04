require 'amazon/ecs'

module AmazonHelper

class AmazonEcs

  def test

  #res = Amazon::Ecs.item_search('ruby', {:response_group => 'Medium', :sort => 'salesrank'})
  #res = Amazon::Ecs.item_search('ruby', :country => 'cn')
  binding.pry
  res = Amazon::Ecs.item_lookup( 'B004FLK6WM', { :country => 'cn', :ResponseGroup => 'Images'})

  end

end
end
