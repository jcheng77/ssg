# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Tb::Application.initialize!

Rails.logger = Logger.new(STDOUT)
#Rails.logger = Log4r::Logger.new("Application Log")
# 0-4: debug|info|warn|error|fatal
Rails.logger.level = 1