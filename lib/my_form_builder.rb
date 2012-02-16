class MyFormBuilder < ActionView::Helpers::FormBuilder
  %w[text_field text_area].each do |method_name|
    define_method(method_name) do |field_name, *args|
      @template.content_tag(:p, field_label(field_name, *args) + "<br/>" + field_error(field_name)+super)
  end
  
  def submit(*args)
    @template.content_tag(:p, super)    
  end
end