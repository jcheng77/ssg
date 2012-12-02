# encoding: utf-8

require 'nokogiri'
require 'net/http'
require 'open-uri'
require 'uri'
require 'cgi'

include ImageHelper
include TaobaoApiHelper
include ItemHelper
include EtaoHelper

module BookmarkletHelper
    SM = [ "Wireless","Photography" ,"CE" , "Major Appliances", "Personal Computer" ,"Video Games","软件" ,"电脑","硬件","电脑笔记本","电子"]
    CYLP = [ "办公用品","Pet Products", "Wine", "玩具" , "创意", "礼品"]
    JJ = [ "Home", "Home Improvement" ,"厨具","居家","家具" ]
    HW = ["运动","户外"]
    NZ = ["服饰","服饰配件"]
    NZ2 = ["男装"]
    SP = ["首饰"]
    HZP = ["Beauty"]
    QC =  ["汽车","Automotive Parts and Accessories","Car Audio or Theater"   ]
    TSYX = ["Book"]
    SP2 = ["食品","零食","茶叶"]
    XB = ["箱子","包包"]

   SOURCE_CATEGORY_ARRAY = [ SM, JJ, HW, NZ, SP , HZP, QC , TSYX , CYLP , XB, SP2 ]

   CAT_MAP = { CYLP => "创意礼品" , SM => "数码", JJ => "居家" , HW => "户外运动" , NZ => "女装" , SP =>"饰品", HZP => "化妆品",TSYX => "图书影像", SP2 => "食品", XB => "箱包", QC => "汽车"  }

   CATEGORIES = ['数码', '户外运动', '男装', '女装', '箱包', '饰品', '化妆品', '居家', '食品', '汽车', '图书影像', '创意礼品']


  class Collector

    def initialize(url)
      Rails.logger.info "processing " + url
      @url = url
      @imgs = []

      begin
        domain_checker
        return if @site == 'unknown'
        get_item_id
        retrieve_product_info
        search_item_on_etao unless succeed?
        process_unknown_sites unless succeed?
        #get_category_from_etao_for_non_amazon_item
        determine_category
      rescue => ex
        Rails.logger.error ex
      end
    end

    def collecter
      #html = open(@url, "r:binary").read.force_encoding('GB2312').encode("utf-8", "GB2312",  :invalid => :replace, :undef => :replace)
      res = Faraday.get @url
      html = res.body.ensure_encoding('UTF-8', :external_encoding => 'GB2312', :invalid_characters => :drop)
      begin
        @imgs = get_jd_imgs(html)
        @price = (get_jd_price_by_staic_tag(html) || get_jd_price_by_pic(html))
        @title = get_title(html)
      rescue
        Rails.logger.info 'encoding error...will retry with etao query at the end of this process'
      end
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
        @url = uri.scheme + '://' + uri.host + uri.path + '?' + (uri.query || '')
        host = uri.host
      end

      case host
      when /taobao/
        @site = 'taobao'
        if /trade/.match(host)
          @url = get_trade_snapshot_item
        end
      when /tmall/
        @site = 'tmall'
      when /amazon/
        @site = 'amazon'
      when /360buy/
        @site ='360buy'
      when /newegg/
        @site = 'newegg'
      when /yihaodian/
        @site = '1shop'
      when /gome.com/
        @site = 'gome'
      when /dangdang/
        @site = 'dangdang'
      when /vancl/
        @site = 'vancl'
      when /suning/
        @site = 'suning'
      when /51buy/
        @site = '51buy'
      when /fengbuy/
        @site = 'fengbuy'
      when /coco8/
        @site = 'coco8'
      else
        @site = 'unknown'
      end
    end

    def get_item_id
      uri = URI.parse(URI.encode(@url.strip))
      path = uri.path.split('/')
      query = uri.query

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
      when 'newegg', 'gome'
        preindex = path.index("Product") || path.index("product") || path.index("dp")
        @item_id = path[preindex + 1].split('.htm').first if preindex
      when '1shop'
        @item_id = path.last
      when 'dangdang'
        query = query.split('=')
        preindex = query.index("product_id")
        @item_id = query[preindex+1] if preindex
      when 'vancl', '51buy'
        pp = path.select { |p| p.slice(/\d+.html/) }
        @item_id = pp.first.slice(/\d+/)
      when 'suning', 'fengbuy', 'coco8'
        @item_id = (path.last.split('.').first if path.last.index('html') > 0)
      else
        @item_id = @url
      end
    end


    def succeed?
      !(@imgs.blank? || @title.nil?)
    end

    def item_id
      @item_id
    end

    def retrieve_product_info
      case @site
      when 'amazon'
        is_amazon_us = 0
        res = Amazon::Ecs.item_lookup(@item_id, {:country => 'cn', :ResponseGroup => 'ItemAttributes,Images,Offers'})
        if res.has_error?
        AmazonEcs::Associates.use_us_track_id
        res = Amazon::Ecs.item_lookup(@item_id, {:country => 'us', :ResponseGroup => 'ItemAttributes,Images,Offers'})
        is_amazon_us = 1
        end
        if !res.has_error?
          item = res.first_item
          @title,@imgs,@purchase_url,@category,@price = AmazonEcs::Associates.process_amazon_item(item)
          @shop_name = '亚马逊美国' if is_amazon_us == 1
        end
      when 'taobao','tmall'
        product = get_item @item_id
        taobaoke_item = convert_items_taobaoke(@item_id)
        shop = get_shop_info product['nick']
        @shop_name = shop['title']
        unless taobaoke_item.nil?
        @shop_url = taobaoke_item["shop_click_url"]
        @purchase_url = taobaoke_item["click_url"]
        end
        @imgs = product["item_imgs"]["item_img"].collect { |img| img["url"] }
        @price = product['price']
        @title = product['title']
        @purchase_url ||= taobao_url(item_id)
      when '360buy'
        collecter
      when 'fengbuy'
        doc = Nokogiri::HTML(open(@url))
        doc.css('div.img_panel > img').each do |n|
          @imgs << n['src']
        end
        doc.xpath('//head/title').each do |tt|
          @title = tt.text
        end
        doc.css('strong.price_fix').each do |p|
          @price = p.text.slice(/\d+/) if p.text
        end
      end
      end

    def process_unknown_sites
        res = Faraday.get @url
        html = res.body.ensure_encoding('UTF-8' , :invalid_characters => :drop)
        @imgs = get_all_imgs(html)
        @title = get_title(html)
    end

    def get_trade_snapshot_item
      doc = open(@url).read
      @url = (doc.slice(/http:\/\/item.taobao.com.*\d/) || doc.slice(/http:\/\/detail.tmall.com\/.*\d/) || @url)
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
      @purchase_url ||= convert_url(@url)
    end

    def category
      @category ||= '创意礼品'
    end

    def site
      @site
    end

    def shop_name
      @shop_name
    end

    def shop_url
      @shop_url
    end

    def determine_category
         cate = SOURCE_CATEGORY_ARRAY.select { |arr| arr.index(@category.strip) || arr.join.match(@category.strip) || partial_match_predefined_category_dictionary(arr,@category) }.first
         @category = ( CAT_MAP.select { |k,v| cate == k }.values.first || @category )
         CATEGORIES.include?(@category) ? @category : '创意礼品'
    end

    def get_category_from_etao_for_non_amazon_item
      if @site != 'amazon'
        search_item_on_etao("price","category")
      end
    end


    def parse_price_pic(pic)
      RTesseract.new(pic).to_s.sub(/Y|\s/, '').match(/\d+(\.\d+)?/).to_s.to_f
    end

    def download_pic(url)
      open(url) { |f|
        File.open(jd_pic_file, 'wb') do |file|
          file.puts f.read
        end
      }
    end

    def jd_pic_file
      ['tmp', 'png'].join('.')
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
      imgs = item_page_source.scan(/src\S+http:\/\/img\S+jpg"/).map { |img| img.slice(/http.*jpg/).gsub(/\/n\d\//, '/n1/') }
      imgs.uniq!
      imgs[1..3]
    end

   def get_all_imgs(item_page_source)
      get_possible_taobao_link(item_page_source)
      imgs = item_page_source.scan(/src\S+http:\/\/\S+jpg"/).map { |img| img.slice(/http.*jpg/) }
      imgs.uniq!
      imgs[0..7]

   end

    def get_possible_taobao_link(item_page_source)
      taobao_item_url = item_page_source.scan(/http:\/\/item.taobao.com\/\S+id=\d+/).first
      tmall_item_url = item_page_source.scan(/http:\/\/\S+\.tmall.com\/\S+id=\d+/).first
      if taobao_item_url
        item = convert_items_taobaoke(taobao_item_url)
        @purchase_url = item["click_url"] if item
      end

    end

    def get_jd_price_by_staic_tag(item_page_source)
      price_tag = item_page_source.scan(/price:.\d*.\d*/)
      price_tag.first.slice(/\d*\.\d*/) unless price_tag.blank?
    end

    def get_title(item_page_source)
      title = item_page_source.slice(/<title>.*>/).force_encoding('UTF-8')
      title.slice(/>.*</).slice(1..-2)
    end

    def search_item_on_etao(*args)
      begin
      e = Etao.new(@url)
      etao_result = e.get_item_info
      @price = etao_result[:price] if args.include?("price") || args.blank?
      @title = etao_result[:title] if args.include?("title") || args.blank?
      @imgs = [etao_result[:image]] if args.include?("image") || args.blank?
      @category = etao_result[:category].split('/').first if args.include?("category") || args.blank?
      rescue Exception => ex
       Rails.logger.info ex
      end
    end

    def convert_url(url)
      case @site
      when '1shop'
        generate_cps_link(nil,'tracker_u=107128006','?')
      when 'dangdang'
        generate_cps_link('http://union.dangdang.com/transfer.php?from=P-310686&ad_type=10&sys_id=1&backurl=')
      when 'vancl'
        connector = (@url.index('?') > 0 ? '&' : '?')
        generate_cps_link(nil,'source=boluome',connector)
        when 'newegg'
        connector = (@url.index('?') > 0 ? '&' : '?')
        generate_cps_link(nil,'cm_mmc=CPS-_-boluome-_-boluome-_-eventcode',connector)
      when 'coco8'
        generate_cps_link('http://cps.coo8.com/cpstransfer.php?unid=j1306&urlto=',nil,nil)
      else
        @url
      end
    end

    def generate_cps_link( prefix = nil, suffix = nil, connector = nil)
      [prefix, [prefix.nil? ? @url : CGI.escape(@url) , suffix ].join(connector)].join()
    end

    protected 

    def partial_match_predefined_category_dictionary(category_array,potential_category)
      c = array.select { |w| potential_category =~ w }
      c.blank? ? false : true
    end

  end
end

module AmazonEcs

class Associates

  def self.use_cn_track_id
   Amazon::Ecs.configure do |options|
      options[:associate_tag] = 'ixiangli-23'
      options[:AWS_access_key_id] = 'AKIAIZPTA7Y3DFTVKL2Q'
      options[:AWS_secret_key] = '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'
   end 
  end

  def self.use_us_track_id
   Amazon::Ecs.configure do |options|
      options[:associate_tag] = 'boluome-20'
      options[:AWS_access_key_id] = 'AKIAIZPTA7Y3DFTVKL2Q'
      options[:AWS_secret_key] = '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'
   end 
  end

  def self.process_amazon_item(item)
      imgs = []
      imgs << item.get_hash("LargeImage")["URL"]
      node = item/'Price/Amount'
      price = node.children.first.text.to_i/100.to_f if node
      title = item.get_element('ItemAttributes').get('Title')
      category = item.get_element('ItemAttributes').get('ProductGroup')
      node2 = item/'DetailPageURL'
      purchase_url = node2.first.text if node
      [title,imgs,purchase_url,category,price]
  end

end
end


