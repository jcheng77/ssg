require 'uri'
module ItemsHelper
  def extra_item_id_from_url(url)
    uri = URI(url)
    req_hash = Rack::Utils.parse_nested_query uri.query
    return req_hash["id"]
  end
end
