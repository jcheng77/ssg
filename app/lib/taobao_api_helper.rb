# encoding: utf-8

require 'net/http'
require 'uri'
require 'digest/md5'
require 'json'

module TaobaoApiHelper
  EMPTY_JSON=JSON.parse('{}')
  #REST_URL = 'http://gw.api.tbsandbox.com/router/rest'
  REST_URL = 'http://gw.api.taobao.com/router/rest'
  AUTH_URL = 'http://container.api.tbsandbox.com/container'
  #SESSION  = '6101a04ef7531fe8aaa7dd4050a231779fa39ea0896d155175978269'
  #SESSION = '6102218e988d186f62837ec8fd1370c7abe7c8772a0207065753053'

  # simple api wrap
  # eg. method: 'taobao.user.get'
  #     map: parameters
  def call_taobao ( method, params)
    app_key = '12483819'
    app_sec = 'ef1f67fba35584ee3cbf63cd093e6ddd' #production

    p = {
      'method' => method, #'taobao.user.get',
      #'session' => 'sandbox88bf3a4b3d1c9dff28d4890e9'
      'timestamp' => Time.now.strftime("%Y-%m-%d %H:%M:%S"),
      'format' => 'json',
      'app_key' => app_key, #'12443313',# 'test',
      'v' => '2.0',
      'sign_method' => 'md5',
    }
    p = p.merge params
    p["sign"] = Digest::MD5.hexdigest(app_sec + p.sort.flatten.join + app_sec).upcase

    url = URI.parse(REST_URL)
    resp  = Net::HTTP.post_form(url, p)
    json = JSON.parse(resp.body.force_encoding('UTF-8'))
    #binding.pry

    if(json['error_response'])
      puts json
      return EMPTY_JSON
    else
      return json
    end
    #Nestful.get 'http://gw.api.tbsandbox.com/router/rest', :params => p
  end

  # item detail
  # eg. item_id: '246883'
  def get_item (item_id)
    params = {
      "num_iid"=> item_id,
      "fields" => "detail_url,num_iid,title,nick,type,cid,seller_cids,props,input_pids,input_str,pic_url,num,valid_thru,list_time,delist_time,stuff_status,location,price,post_fee,express_fee,ems_fee,has_discount,freight_payer,has_invoice,has_warranty,has_showcase,modified,increment,approve_status,postage_id,product_id,auction_point,property_alias,item_img,prop_img,sku,video,outer_id,is_virtual,skus"
    }

    json = call_taobao "taobao.item.get", params
    return json["item_get_response"]["item"] if json!=EMPTY_JSON
  end

  # shopping history
  def get_bought_trades(session_key)
    params = {
      'session' => session_key,
      "fields" => "seller_nick,buyer_nick,title,type,created,sid,tid,seller_rate,buyer_rate,can_rate,status,payment,discount_fee,adjust_fee,post_fee,total_fee,pay_time,end_time,modified,consign_time,buyer_obtain_point_fee,point_fee,real_point_fee,received_payment,commission_fee,pic_path,num_iid,num,price,cod_fee,cod_status,shipping_type,receiver_name,receiver_state,receiver_city,receiver_district,receiver_address,receiver_zip,receiver_mobile,receiver_phone,orders"
    }

    json = call_taobao  "taobao.trades.bought.get", params
    return json["trades_bought_get_response"]["trades"]["trade"] if json!=EMPTY_JSON
  end

  def get_favorite_items(session_key)
    params = {
      "session" =>  session_key,
      "user_nick" => 'jackie_f_cheng',
      "collect_type" => 'ITEM',
      "page_no" => 20
    }

    json = call_taobao "taobao.favorite.search", params
    return json["favorite_search_response"] if json != EMPTY_JSON
  end


  # get taobaoke link
  def convert_items_taobaoke(item_id)
    params = {
      "num_iids"=> item_id,
      'nick' => 'jackie_f_cheng',
      "fields" => "num_iid,title,nick,pic_url,price,click_url,commission,ommission_rate,commission_num,commission_volume,shop_click_url,seller_credit_score,item_location,volume"
    }

    json = call_taobao "taobao.taobaoke.items.convert", params
    return json["taobaoke_items_convert_response"]["taobaoke_items"]["taobaoke_item"] if json!=EMPTY_JSON
  end

  def convert_item_url(item_id)
    params = {
      "num_iids"=> item_id,
      'nick' => 'jackie_f_cheng',
      "fields" => "click_url"
    }

    json = call_taobao "taobao.taobaoke.items.convert", params

    # return json["taobaoke_items_convert_response"]["taobaoke_items"]["taobaoke_item"].first["click_url"] if json["taobaoke_items_convert_response"]!=EMPTY_JSON
    return json["taobaoke_items_convert_response"]["taobaoke_items"]["taobaoke_item"].first["click_url"] if json["taobaoke_items_convert_response"]!=EMPTY_JSON && json["taobaoke_items_convert_response"]["total_results"]!=0
  end

  def taobao_url(taobao_item_id)
    "http://item.taobao.com/item.htm?id=" + taobao_item_id
  end

  # get the rating/comment of your shopping history
  def get_traderates
    params = {
      'session' => SESSION,
      'rate_type' => 'give',
      'role' => 'buyer',
      "fields" => "tid,oid,role,nick,result,created,rated_nick,item_title,item_price,content,reply"
    }

    json = call_taobao "taobao.traderates.get", params
    return json["traderates_get_response"]["trade_rates"]["trade_rate"] if json!=EMPTY_JSON
  end

  # get item categories
  # eg. parent_cid: 50011999, cids: 18957,19562,
  def get_itemcats(parent_cid, cids)
    params = {
      "fields" => "cid, parent_cid, name, is_parent, status, sort_order"
    }

    if parent_cid  && parent_cid>=0
      params['parent_cid']=parent_cid
    elsif cids
      params['cids']=cids
    end

    json = call_taobao "taobao.itemcats.get", params
    return json["itemcats_get_response"]["item_cats"]["item_cat"] if json!=EMPTY_JSON
  end

  # get item properties
  # eg. cid: 50011999
  def get_itemprops(cid)
    params = {
      'cid' => cid,
      "fields" => "pid,name,must,multi,prop_values"
    }

    json = call_taobao "taobao.itemprops.get", params
    return json["itemprops_get_response"]["item_props"]["item_prop"] if json!=EMPTY_JSON
  end

  # get taobaoke report
  # eg. date: 20090520
  def get_report_taobaoke(date)
    params = {
      'date' => date,
      'session' => SESSION,
      "fields" => "trade_id,pay_time,pay_price,num_iid,outer_code,commission_rate,commission,seller_nick,pay_time,app_key"
    }

    json = call_taobao "taobao.taobaoke.report.get", params
    return json["taobaoke_report_get_response"]["taobaoke_report"]["taobaoke_report_members"]["taobaoke_report_member"] if json!=EMPTY_JSON
  end
end

###########################################################
module TestTaobaoApiHelper
  def TestTaobaoApiHelper.get_item
    item = TaobaoApiHelper.get_item('34562')
    return if !item

    puts 'num_iid Number  否   1489161932  商品数字id',
      item['num_iid'],"\n",
      'title  String  否   Google test item  商品标题,不能超过60字节',
      item['title'],"\n",
      'detail_url String  否   http://item.taobao.com/item.htm?id=4947813209   商品url',
      item['detail_url'],"\n",
      'nick String  否   tbtest561   卖家昵称',
      item['nick'],"\n",
      'desc String  否   这是一个好商品   商品描述, 字数要大于5个字符，小于25000个字符',
      item['desc'],"\n",
      'skus Sku []  否     Sku列表。fields中只设置sku可以返回Sku结构体中所有字段，如果设置为sku.sku_id、sku.properties、sku.quantity等形式就只会返回相应的字段',
      item['skus'],"\n",
      'props_name String  否   20000:3275069:品牌:盈讯;1753146:3485013:型号:F908;30606:112030:上市时间:2008年   商品属性名称。标识着props内容里面的pid和vid所对应的名称。格式为：pid1:vid1:pid_name1:vid_name1;pid2:vid2:pid_name2:vid_name2……(注：属性名称中的冒号":"被转换为："#cln#"; 分号";"被转换为："#scln#" )',
      item['props_name'],"\n",
      'cid  Number  否   132443  商品所属的叶子类目 id',
      item['cid'],"\n",
      'props  String  否   135255:344454   商品属性 格式：pid:vid;pid:vid',
      item['props'],"\n",
      'pic_url  String  否   http://img03.taobao.net/bao/uploaded/i3/T1HXdXXgPSt0JxZ2.8_070458.jpg   商品主图片地址',
      item['pic_url'],"\n",
      'location Location  否     商品所在地',
      item['location'],"\n",
      'price  Price   否   5.00  商品价格，格式：5.00；单位：元；精确到：分',
      item['price'],"\n",
      'freight_payer  String  否   seller  运费承担方式,seller（卖家承担），buyer(买家承担）',
      item['freight_payer'],"\n",
      'product_id Number  是   85883030  宝贝所属产品的id(可能为空). 该字段可以通过taobao.products.search 得到',
      item['product_id'],"\n",
      'item_imgs  ItemImg []  否     商品图片列表(包括主图)。fields中只设置item_img可以返回ItemImg结构体中所有字段，如果设置为item_img.id、item_img.url、item_img.position等形式就只会返回相应的字段',
      item['item_imgs'],"\n",
      'wap_desc String  否   Wap宝贝详情   不带html标签的desc文本信息，该字段只在taobao.item.get接口中返回',
      item['wap_desc']
  end

  def TestTaobaoApiHelper.get_bought_trades
    trades = TaobaoApiHelper.get_bought_trades
    return if !trades

    trades.each do |trade|
      puts trade
      trade['orders']['order'].each do |order|
        puts "\torder: #{order}"
      end
    end
  end

  def TestTaobaoApiHelper.convert_items_taobaoke
    items = TaobaoApiHelper.convert_items_taobaoke('34562')
    return if !items

    items.each do |item|
      puts item
    end
  end

  def TestTaobaoApiHelper.get_traderates
    rates = TaobaoApiHelper.get_traderates
    return if !rates

    rates.each do |rate|
      puts rate
    end
  end

  def TestTaobaoApiHelper.get_itemcats(parent_cid, level)
    itemcats = TaobaoApiHelper.get_itemcats(parent_cid, nil)
    return if !itemcats

    itemcats.each do |itemcat|
      level.times{print '  '}
      print itemcat, "\n"
      level.times{print '  '}
      print '-',TaobaoApiHelper.get_itemprops(itemcat['cid']), "\n"
      TestTaobaoApiHelper.get_traderates(itemcat['cid'], level+1)
    end
  end

  def TestTaobaoApiHelper.get_report_taobaoke
    5.times{|i|
      print "\n", date=(Time.now-(3600*24*i)).strftime("%Y%m%d"), "\t"
      reports = TaobaoApiHelper.get_report_taobaoke(date)
      next if !reports

      reports.each do |report|
        print report#report['outer_code'],report['trade_id'],report['pay_price'],report['commission'],report['num_iid'],"\n"
      end
    }

  end
end

module CommissionHelper
  BUYER_COMMISSION_RATE=0.5
  REFERRER_COMMISSION_RATE=0.3

  # trade_id:xx, pay_time:xx, pay_price:xx, item_id:xx, item_num:xx, real_pay_fee:xx, commission:xx, commission_rate:xx
  # buyer_id:xx, buyer_commission:xx
  # referral_code:xx, referrer_id:xx, shared_item_id:xx, shared_item_price:xx, referrer_bought:true, referrer_commission:xx
  def CommissionHelper.commission_calculator
    result={}

    report = get_report_mock
    result['item_id'] = report['num_iid']
    result['item_num'] = report['item_num']
    result['trade_id'] = report['trade_id']
    result['referral_code'] = report['outer_code']
    result['pay_time'] = report['pay_time']
    result['pay_price'] = report['pay_price']
    result['real_pay_fee'] = report['real_pay_fee']
    result['commission'] = report['commission']
    result['commission_rate'] = report['commission_rate']

    trade = get_trade_mock(result['trade_id'])
    buyer_nick=trade['buyer_nick']
    result['buyer_id']=get_user_id_by_taobao_nick_mock(buyer_nick)

    referral = get_referral_mock(result['referral_code'])
    if(referral)
      result['referrer_id'] = referral['referrer_id']
      result['shared_item_id'] = referral['shared_item_id']
      result['referrer_bought'] = referral['referrer_bought']
      result['shared_item_price'] = referral['shared_item_price']

      if (result['item_id']==referral['shared_item_id'] && referral['referrer_bought'])
        result['referrer_commission']=report['commission']*REFERRER_COMMISSION_RATE
      end

      result['buyer_commission'] = report['commission']*BUYER_COMMISSION_RATE
    end

    return result
  end

  def CommissionHelper.get_report_mock
    report={}
    report['num_iid']='101'
    report['item_num']=2
    report['trade_id']='201'
    report['outer_code']='123456789ABC'
    report['pay_time']='2000-01-01 00:00:00'
    report['pay_price']=120
    report['real_pay_fee']=200
    report['commission']=20
    report['commission_rate']=0.1
    return report
  end

  def CommissionHelper.get_user_id_by_taobao_nick_mock(nick)
    return nick
  end

  def CommissionHelper.get_trade_mock(trade_id)
    trade={}
    trade['buyer_nick']='buyer'
    return trade
  end

  def CommissionHelper.get_referral_mock(referral_code)
    referral={}
    referral['referrer_id']='referrer'
    referral['shared_item_id']='101'
    referral['referrer_bought']=true
    referral['shared_item_price']=120
    return referral
  end
end

###########################################################
#TestTaobaoApiHelper.get_item
#TestTaobaoApiHelper.get_bought_trades
#TestTaobaoApiHelper.convert_items_taobaoke
#TestTaobaoApiHelper.get_traderates
#TestTaobaoApiHelper.get_itemcats(0, 0)
#TestTaobaoApiHelper.get_report_taobaoke

CommissionHelper.commission_calculator.each do |x,y|
  p x,": ",y,"\n"
end
