require 'nokogiri'
require 'open-uri'
require 'uri'

include ImageHelper

module BookmarkletHelper

  class Collector


    def initialize(url)
      @url = url
    end

    def collecter
      doc = Nokogiri::HTML(open(@url))
      imgs = []
      domain_checker
      doc.css(@mark).each do |node|
        imgs << conv_pic_40_to_310(node.values.first)
      end
     return imgs
    end

    def domain_checker
      case URI(@url).host
      when /taobao/
        @site =  'taobao'
        @mark =  'div.tb-s40 img'
      when /tmall/
        @site = 'taobao'
        @mark =  'div.tb-s40 img'
      when /amazon/
        @site = 'amazon'
        @mark = 'prodimage'
      when /360buy/
        @site ='360buy'
      else
        @site ='others'
      end
    end

  end
end
