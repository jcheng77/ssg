module ImageHelper
  def big_avatar_url(avatar_url)
    if avatar_url.blank?
      ""
    elsif avatar_url.include? "sinaimg"
      avatar_url.sub "/50/", "/180/"
    elsif avatar_url.include? "qlogo"
      "#{avatar_url}/180"
    else
      avatar_url
    end
  end

  def small_avatar_url(avatar_url)
    if avatar_url.blank?
      ""
    elsif avatar_url.include? "qlogo"
      "#{avatar_url}/50"
    else
      avatar_url
    end
  end
end