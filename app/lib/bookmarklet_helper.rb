require 'nokogiri'
require 'net/http'
require 'open-uri'
require 'uri'

include ImageHelper
include TaobaoApiHelper

module BookmarkletHelper
#  SM = [ "Wireless","Photography" , "Car Audio or Theater" ,"CE" , "Major Appliances", "Personal Computer" ,"Video Games","软件" ] 
#  QT = [ "办公用品","Pet Products", "Wine", "玩具", "Automotive Parts and Accessories"]
#  JJ = [ "Home", "Home Improvement" ,"厨具" ]
#  HW = ["运动"]
#  NZ = ["服饰"] 
#  SP = ["首饰"]
#
#  SOURCE_CATEGORY_ARRAY = [ SM, QT, JJ, HW, NZ, SP ]
#  CAT_MAP = { SM => "数码", QT => "其他" , JJ => "家居" , HW => "户外" , NZ => "女装" , SP =>"饰品"}
  


  class Collector

    def initialize(url)
      Rails.logger.info "processing " + url
      @url = url
      @imgs = []
      domain_checker
      get_item_id
      retrieve_product_info if correct?
    end

    def collecter
      html = open(@url, "r:binary").read.force_encoding('GB2312').encode("utf-8", "GB2312",  :invalid => :replace, :undef => :replace)
      @imgs = get_jd_imgs(html)
      begin
      @price = ( get_jd_price_by_staic_tag(html) || get_jd_price_by_pic(html) )
    rescue
      puts 'encoding error or no price tag found'
    end
      @title = get_jd_title(html)
      end


    def domain_checker
      host = URI.parse(URI.encode(@url.strip)).host

      if /t.cn/.match(host)
        begin
          RestClient.get(@url)
        rescue URI::InvalidURIError
          @url = $!.to_s.split("bad URI(is not URI?): ")[1]
        end
        uri = open(URI.encode(@url.strip)).base_uri
        @url = uri.scheme + '://' + uri.host + uri.path + '?' + ( uri.query  || '' )
        host = uri.host
      end

      case host
      when /taobao/
        @site =  'taobao'
        @css_mark =  'div.tb-pic img'
        if /trade/.match(host)
          @url = get_trade_snapshot_item
        end
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
      uri = URI.parse(URI.encode(@url.strip))
      path = uri.path.split('/')

      case @site
      when 'taobao'
        req_hash = Rack::Utils.parse_nested_query uri.query
        @item_id = req_hash["id"]
      when 'tmall'
        req_hash = Rack::Utils.parse_nested_query uri.query
        @item_id ||= (req_hash["id"] || req_hash["mallstItemId"])
      when 'amazon'
        preindex = path.index("product") || path.index("dp")
        @item_id = path[preindex + 1] if preindex
      when '360buy'
        @item_id = path.last.split('.').first
      else
        @item_id = "invalid"
      end
    end

    def correct?
      @item_id && @item_id != "invalid" 
    end

    def item_id
      @item_id
    end

    def retrieve_product_info
      case @site
      when 'amazon'
      res = Amazon::Ecs.item_lookup( @item_id, { :country => 'cn', :ResponseGroup => 'ItemAttributes,Images,Offers'})
      if !res.has_error?
      item = res.first_item
      @imgs << item.get_hash("LargeImage")["URL"]
      node = item/'Price/Amount'
      @price = node.children.first.text.to_i/100 if node
      @title = item.get_element('ItemAttributes').get('Title')
      @category = item.get_element('ItemAttributes').get('ProductGroup')
      determine_category
      node2 = item/'DetailPageURL'
      @purchase_url = node2.first.text if node
      end
      when 'taobao','tmall'
        product = get_item @item_id
        shop = get_shop_info product['nick']
        @shop_name = shop['title']
        @imgs = product["item_imgs"]["item_img"].collect { |img| img["url"] }
        @price = product['price']
        @title = product['title']
        @purchase_url = convert_item_url item_id
        @purchase_url ||= taobao_url(item_id)
      when '360buy'
        collecter
      end
    end

    def get_trade_snapshot_item
      doc = open(@url).read
      @url = ( doc.slice(/http:\/\/item.taobao.com.*\d/) ||  doc.slice(/http:\/\/detail.tmall.com\/.*\d/) || @url )
    end

    def imgs
      @imgs
    end

    def title
      @title
    end

    def price
      @price ||= '0'
    end

    def purchase_url
      @purchase_url ||= @url
    end

    def category
      @category
    end

    def site
      @site
    end

    def shop_name
      @shop_name
    end

    def determine_category
      case @site
      when 'taobao'
      when '360buy'
      when 'amazon'
#        cat = SOURCE_CATEGORY_ARRAY.select { |arr| arr.index(@category) }.first
#        @category = ( CAT_MAP.select { |k,v| cat == k }.values.first || @category )
      end
    end




    def parse_price_pic(pic)
      RTesseract.new(pic).to_s.sub(/Y|\s/, '').match(/\d+(\.\d+)?/).to_s.to_f
    end

    def download_pic(url)
      open(url) { |f|
        File.open( jd_pic_file,'wb' ) do |file|
          file.puts f.read
        end
      }
    end

    def jd_pic_file
      ['tmp','png'].join('.')
    end

    def get_jd_price_by_pic(item_page_source)
      png_tags = item_page_source.scan(/p-price.*png/)
      unless png_tags.blank
      price_pic_url = png_tags.first.slice(/http.*png/) 
      download_pic(price_pic_url)
      parse_price_pic jd_pic_file
    end
    end

    def get_jd_imgs(item_page_source)
      imgs =  item_page_source.scan(/src.*http:\/\/img.*jpg"/).map { |img| img.slice(/http.*jpg/).gsub(/\/n\d\//,'/n1/') }
      imgs.uniq!
      imgs[0..3]
    end

    def get_jd_price_by_staic_tag(item_page_source)
      price_tag = item_page_source.scan(/price:.\d*.\d*/)
      price_tag.first.slice(/\d*\.\d*/) unless price_tag.blank?
    end

    def get_jd_title(item_page_source)
      title = item_page_source.slice(/<title>.*>/)
      title.slice(/>.*</).slice(1..-2)
    end


  end
end
