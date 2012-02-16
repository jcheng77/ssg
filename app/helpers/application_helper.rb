module ApplicationHelper
  def my_form_for(*args, &block)
    options=args.extract_options!.merge(:builder => LabeledFormBuilder)
    form_for(*(args + [options]), &block)
  end
end
