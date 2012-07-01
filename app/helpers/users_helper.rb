# encoding: utf-8
module UsersHelper
  def account_info(info)
    if info.blank?
      "暂无资料"
    else
      info
    end
  end
end
