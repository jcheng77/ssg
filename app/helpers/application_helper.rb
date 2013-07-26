# encoding: utf-8

module ApplicationHelper
  def empty_link_if(condition, name)
    if condition
      link_to name, "javascripts: void(0);"
    else
      link_to name, yield
    end
  end
  
  def title(page_title)
    content_for :title, page_title
  end
end
