# Load the rails application
require File.expand_path('../application', __FILE__)
Encoding.default_internal = Encoding::UTF_8
Encoding.default_external = Encoding::UTF_8
#Encoding.default_internal = 'utf-8'
#Encoding.default_external = 'utf-8'


# Initialize the rails application
Ssg::Application.initialize!

Rails.logger = Logger.new(STDOUT)
#Rails.logger = Log4r::Logger.new("Application Log")
# 0-4: debug|info|warn|error|fatal
Rails.logger.level = 1
