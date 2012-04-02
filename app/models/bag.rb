class Bag
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongo::Followable
  include CommentableHelper

  acts_as_commentable
  belongs_to :user
  belongs_to :item
end