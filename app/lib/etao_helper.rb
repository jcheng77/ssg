require 'faraday_middleware'
require 'faraday'


module EtaoHelper

  class Etao

    def initialize
      init_etao_conn
    end

  def get_etao_resource(query_url)
    binding.pry
    shops  = []
    prices = []
    res = @conn.get query_url
    res.scan(/other-sellers-name.*/).each do |s|
      shops << s.slice(/>.*</).slice(1..-2)
    end
    res.scan(/price.*span.*\d<\/strong>/).each do |p|
    prices <<  p.slice(/\d+.\d+/)
    end
    { :shops => shops, :prices => prices }
    end

  def init_etao_conn
    binding.pry
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
  end


end
