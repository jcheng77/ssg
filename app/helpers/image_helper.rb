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

  def conv_pic_from_310_to_40(picurl)
    picurl.gsub('40x40','310x310')
  end

  def conv_pic_from_40_to_310(picurl)
    picurl.gsub('310x310','40x40')
  end

end
