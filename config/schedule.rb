every 1.day, :at => '9:00 pm' do
    runner "PriceWatcherHelper.get_the_latest_price", :environment => "develpement"
end
