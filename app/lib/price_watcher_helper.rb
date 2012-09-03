include TaobaoApiHelper

module PriceWatcherHelper
  def get_followed_items
  end

  def get_the_latest_price
    #items = get_followed_items
    items_udpated = [] 
    items = Item.all
    items.each do |item|
      binding.pry
      item_json = get_item(item.source_id)
      price = item_json["price"]
      if price < item.price_low
         item.update_attribute(:price_low , price)
         items_updated << [item._id,price]
      end
    end
  end

  def notify_users
    items_with_price = get_the_latest_price
  end
end
