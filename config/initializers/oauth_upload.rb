require 'open-uri'
require 'uri'

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
  
end

