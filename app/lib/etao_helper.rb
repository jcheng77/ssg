#encoding: UTF-8
require 'faraday_middleware'
require 'faraday'

include ItemHelper


module EtaoHelper
  ETAO_QUERY_PREFIX = '/item.htm?tb_lm_id=t_fangshan_wuzhao&url='

  def search_item_with_ruyi_api(keyword)
    res = Faraday.get URI.encode(ruyi_search_string(keyword))
    j = JSON(res.body)
    items = []
    result = j["Items"]
    unless result.nil?
    result[0..20].each do |t|
      if is_known_site?(t["DetailPageURL"])
      items << [ t["Title"], t["LargeImageUrl"],t["DetailPageURL"],nil,t["Price"] ]
      end
    end
    end
    items
  end


  def is_known_site?(url)
    !!( (url.match('taobao')) || (url.match('360buy')) || (url.match('yihaodian')) || (url.match('dangdang')) || (url.match('suning') ) || (url.match('51buy')) || (url.match('newegg')))
  end

  def ruyi_search_string(keyword)
    ['http://ruyi.etao.com/ext/etaoSearch?q=',keyword,'&application=ruyijs&page=1'].join()
  end



  class Etao

    def initialize(url)
      @url = url  
      init_etao_conn
    end


  def get_item_info
    shops  = []
    prices = []
    res = @conn.get etao_query_url
    html = res.body.ensure_encoding('UTF-8', :external_encoding  => get_response_encoding(res), :invalid_characters => :drop)
    img = html.scan(/img src=.*.jpg/).first.slice(/http.*/)
    price = html.scan(/J_price.*\d+.\d+/).first.slice(/\d+.\d+/)
    title = html.slice(/title.*</).slice(/>.*</).slice(1..-2)
    { :title => title, :image => img, :price => price ,:shops => shops, :prices => prices }
    end

  def init_etao_conn
    @conn = Faraday.new 'http://ok.etao.com/' do |c|
            c.use FaradayMiddleware::FollowRedirects, limit: 10
            c.use Faraday::Response::RaiseError       # raise exceptions on 40x, 50x responses
            c.use Faraday::Adapter::NetHttp
    end
  end

  def get_etao_shop_address
    @conn = Faraday.new 'http://shop.etao.com/' do |c|
            c.use FaradayMiddleware::FollowRedirects, limit: 10
            c.use Faraday::Response::RaiseError       # raise exceptions on 40x, 50x responses
            c.use Faraday::Adapter::NetHttp
    end
  end

  def etao_query_url
    [ ETAO_QUERY_PREFIX , @url ].join()
  end

  def get_response_encoding(res)
    res.env[:response_headers]["content-type"].split('=').last
  end

  end

end

