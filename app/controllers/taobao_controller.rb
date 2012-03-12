#encoding: utf-8
require 'rubygems'
require 'net/http'
require 'uri'
require 'digest/md5'
require 'json'
require 'nestful'
require 'iconv'


class TaobaoController < ApplicationController
  layout 'application'
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
      format.html  index.html.erb
      format.json { render json: @product }
    end
  end
  
  def index

    respond_to do |format|
      format.html index.html.erb
    end
  end
  
  def callback
    #str = params['top_appkey'] + params["top_parameters"] + params["top_session"] + ENV['TAOBAO_APP_SECRET']
    str = params['top_appkey'] + params["top_parameters"] + params["top_session"] + 'ef1f67fba35584ee3cbf63cd093e6ddd'
    md5 = Digest::MD5.digest(str)
    sign = Base64.encode64(md5).strip

    if sign == params['top_sign']
      top_params = Hash[*(Base64.decode64(params['top_parameters']).split('&').collect {|v| v.split('=')}).flatten]

      exists = User.where(userid: top_params["visitor_id"].to_s ).first

      if exists.nil?
      
      user = User.create( :userid => top_params["visitor_id"], :session_key => top_params["top_session"])
      session[:current_user_id] = user._id
      binding.pry
      redirect_to :controller => "users", :action => "signup" , :id => user._id , :name => top_params["visitor_nick"]
      else
      session[:current_user_id] = exists._id
      redirect_to dashboard_users_path
      end
      
    else
      redirect_to users_url, :notice => "authorized failed!!!! #{access_token} #{token_secret}"
    end
 
#      session[:current_user] = top_params['visitor_nick']
#      redirect_to dashboard_users_path
#    else
#      raise RuntimeError, "Invalid signature"
#    end 
   end 


  # taobao callback (TOP style)
  # sample: http://www.ssg.com/taobao/callback?top_appkey=...&top_parameters=...&top_session=...&sign=...&timestamp=...&top_sign=...
  
end
