every 1.day, :at => '9:00 pm' do
    runner "PriceWatcherHelper.get_the_latest_price", :environment => "develpement"
end

every 1.day, :at => '2:00 am' do
    runner "Item.sync_data"
end
