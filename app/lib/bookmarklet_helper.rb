require 'nokogiri'
require 'open-uri'
require 'uri'

include ImageHelper

module BookmarkletHelper

  class Collector


    def initialize(url)
      @url = url
      domain_checker
      get_item_id
    end

    def collecter
      if @site == 'amazon'
      res = Amazon::Ecs.item_lookup( 'B004FLK6WM', { :country => 'cn', :ResponseGroup => 'Images'})
      else
      doc = Nokogiri::HTML(open(@url))
      imgs = []
      domain_checker
      if @css_mark
        doc.css(@css_mark).each do |node|
          imgs << conv_pic_to_310(node.values.first) if node.values.first.match(/^http/)
        end
      return imgs
      end

      if @xpath_mark
        i=0
        doc.xpath(@xpath_mark).each do |node|
          if i > 5
            break
          end
          if node["onerror"]
            i += 1
            imgs <<  node["src"].gsub('/n5/','/n1/')
          end
      end
      end
      return imgs
      end

    end

    def domain_checker
      case URI(@url).host
      when /taobao/
        @site =  'taobao'
        @css_mark =  'div.tb-pic img'
      when /tmall/
        @site = 'tmall'
        @css_mark =  'div.tb-pic img'
      when /amazon/
        @site = 'amazon'
        @css_mark = 'prodimage'
      when /360buy/
        @site ='360buy'
        @xpath_mark = '//img'
      else
        @site ='others'
      end
    end

    def get_item_id
      uri = URI(@url)
      req_hash = Rack::Utils.parse_nested_query uri.query
      path = uri.path.split('/')

      case @site
      when 'taobao'
        @item_id = req_hash["id"]
      when 'tmall'
        @item_id = req_hash["id"]
      when 'amazon'
        @item_id = path[path.index("product")+1]
      when '360buy'
        @item_id = path[path.index("product")+1].split('.').first
      else
        @item_id = "invalid"
      end
    end

  end
end
