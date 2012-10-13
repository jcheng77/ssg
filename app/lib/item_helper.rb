module ItemHelper
  def restore_url(site, item_source_id)
    case site
      when 'taobao'
        prefix = 'http://item.taobao.com/item.htm?id='
      when 'tmall'
        prefix = 'http://detail.tmall.com/item.htm?id='
      when '360buy'
        prefix = 'http://www.360buy.com/product/'
        suffix = '.html'
      when 'amazon'
        prefix = 'http://www.amazon.cn/dp/'
    end
    return [prefix, item_source_id, suffix].join
  end

  def append_track_id(site,url,track_id)
    case site
    when 'taobao', 'tmall'
     if is_taobaoke_url?(url) && track_id
       url + '&unid=' + track_id
     else
       url
     end
    else 
      url
    end
  end

  def is_taobaoke_url?(url)
    url.match(/s.click.taobao/)
  end

end
