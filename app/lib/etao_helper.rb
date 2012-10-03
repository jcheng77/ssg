#encoding: UTF-8
require 'faraday_middleware'
require 'faraday'

include ItemHelper


module EtaoHelper
  ETAO_QUERY_PREFIX = '/item.htm?tb_lm_id=t_fangshan_wuzhao&url='

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
    html.scan(/other-sellers-name.*/).each do |s|
      shops << s.slice(/>.*</).slice(1..-2)
    end
    html.scan(/price.*span.*\d<\/strong>/).each do |p|
    prices <<  p.slice(/\d+.\d+/)
    end
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
