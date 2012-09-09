require 'nokogiri'
require 'open-uri'
require 'uri'

include ImageHelper
include TaobaoApiHelper

module BookmarkletHelper
  class Collector

    def initialize(url)
      @url = url
      @imgs = []
      domain_checker
      get_item_id
      retrieve_product_info
    end

    def collecter
      doc = Nokogiri::HTML(open(@url))
      if @css_mark
        doc.css(@css_mark).each do |node|
          @imgs << conv_pic_to_310(node.values.first) if node.values.first.match(/^http/)
        end
      end

      if @xpath_mark
        i=0
        doc.xpath(@xpath_mark).each do |node|
          if i > 5
            break
          end
          if node["onerror"]
            i += 1
            @imgs <<  node["src"].gsub('/n5/','/n1/')
          end
        end
      end

      if @title_mark
        first_title = doc.xpath(@title_mark).first
        @title = first_title.text if first_title
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
        @title_mark = '//title'
      else
        @site ='others'
      end
    end

    def get_item_id
      uri = URI(@url)
      path = uri.path.split('/')

      case @site
      when 'taobao'
        req_hash = Rack::Utils.parse_nested_query uri.query
        @item_id = req_hash["id"]
      when 'tmall'
        req_hash = Rack::Utils.parse_nested_query uri.query
        @item_id = req_hash["id"]
      when 'amazon'
        preindex = path.index("product") || path.index("dp")
        @item_id = path[preindex + 1] if preindex
      when '360buy'
        @item_id = path[path.index("product")+1].split('.').first
      else
        @item_id = "invalid"
      end
    end

    def correct?
      @item_id != "invalid" && @img != []
    end

    def item_id
      @item_id
    end

    def retrieve_product_info
      case @site
      when 'amazon'
      res = Amazon::Ecs.item_lookup( @item_id, { :country => 'cn', :ResponseGroup => 'ItemAttributes,Images,Offers'})
      item = res.first_item
      @imgs << item.get_hash("LargeImage")["URL"]
      node = item/'Price/Amount'
      @price = node.children.first.text.to_i/100 if node
      @title = item.get_element('ItemAttributes').get('Title')
      node2 = item/'DetailPageURL'
      @purchase_url = node2.first.text if node
      when 'taobao','tmall'
        product = get_item item_id
        @imgs = product["item_imgs"]["item_img"].collect { |img| img["url"] }
        @price = product['price']
        @title = product['title']
        @purchase_url = convert_item_url item_id
        @purchase_url ||= taobao_url(item_id)
      when '360buy'
        collecter
      end
    end

    def imgs
      @imgs
    end

    def title
      @title
    end

    def price
      @price
    end

    def purchase_url
      @purchase_url ||= @url
    end


  end
end
