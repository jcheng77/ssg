require 'open-uri'
require 'uri'
require 'oauth2'

#WeiboOAuth2::Api::V2::Statuses.class_eval do
#
#  def upload(status, pic, opt={})
#   if ( pic =~ URI::regexp).nil?
#    pic = File.open(pic,"rb") 
#    else
#    pic = open(pic,"rb")
#    end
#    multipart = Base.build_multipart_bodies({"status" => status, "pic" => pic}.merge(opt))
#    hashie post("statuses/upload.json", :headers => multipart[:headers], :body => multipart[:body])
#  end
#end


OauthChina::Sina.class_eval do

  def upload_image(content, image_path, options = {})
  if (image_path =~ URI::regexp).nil?
    pic = File.open(image_path,"rb") 
  else
    pic = open(image_path,"rb")
  end
  options = options.merge!(:status => content, :pic => pic ).to_options
  upload("http://api.t.sina.com.cn/statuses/upload.json", options)
  end

  def new_dm(content,object_user,options = {})
    options.merge!(:id => object_user,:text => content, :screen_name => 'zl_demon')
    self.post("http://api.t.sina.com.cn/direct_messages/new.json", options)
  end
  
end

OauthChina::Qq.class_eval do
  def upload_image_url(content, image_path, options = {})
      options = options.merge!(:content => content, :pic_url => image_path).to_options
      self.consumer.options[:site] = "http://open.t.qq.com/api/t/add_pic_url"
      self.consumer.uri("http://open.t.qq.com/api/t/add_pic_url")
      upload("http://open.t.qq.com/api/t/add_pic_url", options)
  end

  def new_dm(content,object_user,options = {})
    options.merge!(:id => object_user,:text => content, :screen_name => 'zl_demon')
    self.post("http://api.t.sina.com.cn/direct_messages/new.json", options)
  end
  
end

