module ImageHelper
  def big_avatar_url(avatar_url)
    url = avatar_url
    if avatar_url.include? "sinaimg"
      url = avatar_url.sub "/50/", "/180/"
    elsif avatar_url.include? "qlogo"
      url = "#{avatar_url}/180"
    end
    url
  end

  def small_avatar_url(avatar_url)
    url = avatar_url
    if avatar_url.include? "qlogo"
      url = "#{avatar_url}/50"
    end
    url
  end
end