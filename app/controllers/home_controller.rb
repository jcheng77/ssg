class HomeController < ApplicationController
  layout 'application'
  skip_before_filter :authenticate
end
