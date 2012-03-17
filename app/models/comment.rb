class Comment
  MARK_BYTE = 5

  include Mongoid::Document
  include Mongoid::MultiParameterAttributes
  include Mongo::Voteable
  include ObjectIdHelper

  after_initialize do |o|
    o.mark_id! # mark the _id with the mark byte
  end

  before_create :set_created_time, :reset_commentable_id

  # comment to share, object_id = share_id
  # comment to item, object_id = item_id (not now)
  # comment to seller, object_id = seller_id (not now)
  # comment to comment would be using weibo style, which is @user_nick_name, won't use object_id to refer to the target-comment id

  # field :object_id_type, type: BSON::ObjectId # user make comment to item/seller/share etc.
  field :user_id, type: BSON::ObjectId # user who writes this comment
  field :content, type: String # content of the comment
  field :created_time, type: DateTime # the time comment created

  # index :object_id_type

  belongs_to :commentable, :polymorphic => true
  has_many :comments, :as => :commentable, :dependent => :destroy

  voteable self, :up => 1, :down => -1

  validates_presence_of :user_id, :content, :allow_nil => false

  # Get uer object.
  def user
    User.find(self.user_id)
  end

  # Get the root object of the comment.
  def root
    parent = self.parent
    parent.is_a?(self.class) ? parent.parent : parent
  end

  # Get the parent object of the comment.
  def parent
    self.commentable
  end

  # Get all child comments recursively.
  def recursive_comments
    child_comments = self.comments.all.map { |comment| comment.recursive_comments }
    [self, child_comments]
  end

  # Get only the direct child comments
  def child_comments
    self.comments.all
  end

  protected
  def set_created_time
    self.created_time = Time.now if self.created_time.nil?
  end

  def reset_commentable_id
    id = self.commentable_id
    if !id.nil? && id.is_a?(String)
      self.commentable_id = BSON::ObjectId.from_string self.commentable_id
    end
  end
end
