# encoding: utf-8
module UsersHelper
  def account_info(info)
    if info.blank?
      "暂无资料"
    else
      info
    end
  end

  def actived_li_if(condition)
    html_class = ""
    if condition
      html_class = "active"
    end
    content_tag(:li, :class => html_class){ yield }
  end
end
