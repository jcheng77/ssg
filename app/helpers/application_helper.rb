module ApplicationHelper
  def empty_link_if(condition, name)
    if condition
      link_to name, "javascripts: void(0);"
    else
      link_to name, yield
    end
  end
end
