#require "mongo_session_store/mongoid"
#ActionController::Base.session_store = :mongo_mapper_store
#require "mongo_session_store/mongoid"
Ssg::Application.config.session_store = :mongoid_store

# Be sure to restart your server when you modify this file.

#ActionController::Base.session_store = :mongo_mapper_store


# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
