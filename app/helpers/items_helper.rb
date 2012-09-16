require 'uri'
module ItemsHelper
  def extra_item_id_from_url(url)
    uri = URI(url)
    req_hash = Rack::Utils.parse_nested_query uri.query
    return req_hash["id"]
  end

  def gotopic(site)
    case site
    when '360buy'
      return '3_gobuy.png'
    when 'amazon'
      return 'a_gobuy.png'
    when 'taobao'
      return 't_gobuy.png'
    else
      't_gobuy.png'
    end
  end
end
