require 'nokogiri'
require 'open-uri'

module BookmarkletHelper

  def taobao_collector(url)
    doc = Nokogiri::HTML(open(url))
    imgs = []
    doc.css('div.tb-s310 img').each do |node|
      node.values.each do |val|
        imgs << val if val.match(/^http/)
      end
    end

    doc.css('div.tb-s40 img').each do |node|
      imgs << conv_pic_from_40_to_310(node.values.first)
    end

    return imgs
  end

end
