module ImageHelper
  def big_avatar_url(small_avatar_url)
    url = small_avatar_url
    if small_avatar_url.include? "tp3.sinaimg.cn"
      url = small_avatar_url.sub "/50/", "/180/"
    end
    url
  end
end