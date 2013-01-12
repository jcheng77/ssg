class Note
  include Mongoid::Document
  include Mongoid::Timestamps::Created
  include Mongo::Followable::Followed
  include VisibleToHelper
  include CommentableHelper
  include TaggableHelper

  field :text, type: String
  field :image, type: String, default: 'http://t2.baidu.com/it/u=2726430811,1796290699&fm=0&gp=0.jpg'

  acts_as_commentable
  belongs_to :user,index: true
  belongs_to :item, index: true



end
