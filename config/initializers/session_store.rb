#require "mongo_session_store/mongo_mapper"
#ActionController::Base.session_store = :mongo_mapper_store
#require "mongo_session_store/mongoid"
Ssg::Application.config.session_store = :mongoid_store

# Be sure to restart your server when you modify this file.

#Tb::Application.config.session_store :cookie_store, key: 'key'
#Tb::Application.config.session_store :mongo_mapper_store
#ActionController::Base.session_store = :mongo_mapper_store


# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# Tb::Application.config.session_store :active_record_store
