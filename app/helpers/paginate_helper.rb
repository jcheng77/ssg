require 'will_paginate/collection'

module PaginateHelper

  # See http://rubydoc.info/gems/will_paginate/2.3.15/WillPaginate/Collection.create
  # See https://github.com/mislav/will_paginate/blob/master/lib/will_paginate/array.rb
  # Do in application_helper.rb or application_controller.rb (or somewhere else application-wide)

  # Now you can paginate any array, something like
  # @posts = NewsPost.search params[:search], :match_mode => :boolean, :field_weights => {:title => 20, :summary => 15}
  # filter_by_user
  # @posts = @posts.paginate :page => params[:page], :order => 'published_at DESC', :per_page => NewsPost.per_page
  Array.class_eval do
    def paginate(options = {})
      raise ArgumentError, "parameter hash expected (got #{options.inspect})" unless Hash === options

      WillPaginate::Collection.create(
          options[:page] || 1,
          options[:per_page] || 30,
          options[:total_entries] || self.length
      ) { |pager|
        pager.replace self[pager.offset, pager.per_page].to_a
      }
    end
  end

  # Based on https://gist.github.com/1182136
  class BootstrapLinkRenderer < ::WillPaginate::ActionView::LinkRenderer
    protected

    def html_container(html)
      tag :div, tag(:ul, html), container_attributes
    end

    def page_number(page)
      tag :li, link(page, page, :rel => rel_value(page)), :class => ('active' if page == current_page)
    end

    def gap
      tag :li, link(super, '#'), :class => 'disabled'
    end

    def previous_or_next_page(page, text, classname)
      tag :li, link(text, page || '#'), :class => [classname[0..3], classname, ('disabled' unless page)].join(' ')
    end
  end

  def bootstrap_will_paginate(pages, hash = {})
    params = {:class => 'pagination',
              :inner_window => 2,
              :outer_window => 0,
              :renderer => BootstrapLinkRenderer,
              :previous_label => '&laquo;'.html_safe,
              :next_label => '&raquo;'.html_safe}.merge(hash)
    will_paginate(pages, params)
  end
end
