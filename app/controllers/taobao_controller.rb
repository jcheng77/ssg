#encoding: utf-8
require 'rubygems'
require 'net/http'
require 'uri'
require 'digest/md5'
require 'json'
require 'nestful'
require 'iconv'


class TaobaoController < ApplicationController
  #layout 'taobao'
  #skip_before_filter :verify_authenticity_token

  def new
    #params[:itemId]
    #@json_str = call_taobao "taobao.user.get", "fields" => "user_id,uid,nick", "nick"=> "andyy_tan"
    #13012180181 
    #@json_str = call_taobao "taobao.user.get", {"nick"=> "andyy_tan", "fields" => "user_id,uid,nick"}
    @json_str = call_taobao "taobao.item.get", {"num_iid"=> "246883", "fields" => "detail_url,num_iid,title,nick,type,cid,seller_cids,props,input_pids,input_str,desc,pic_url,num,valid_thru,list_time,delist_time,stuff_status,location,price,post_fee,express_fee,ems_fee,has_discount,freight_payer,has_invoice,has_warranty,has_showcase,modified,increment,approve_status,postage_id,product_id,auction_point,property_alias,item_img,prop_img,sku,video,outer_id,is_virtual,skus"}
    @product = JSON.parse(@json_str)["item_get_response"]["item"]

    @json_str=@json_str.force_encoding('UTF-8')[100..141] << '啊'
    @json_str.force_encoding('ASCII-8BIT')
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @product }
    end
  end
  
  def index

    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  # taobao callback (TOP style)
  # sample: http://www.ssg.com/taobao/callback?top_appkey=...&top_parameters=...&top_session=...&sign=...&timestamp=...&top_sign=...
  def callback
  end
  
end

