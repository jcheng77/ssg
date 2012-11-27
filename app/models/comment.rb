class Comment
  include Mongoid::Document
  include Mongoid::MultiParameterAttributes
  include Mongoid::Timestamps::Created
  include Mongo::Voteable
  include Mongo::Followable::Followed

  field :user_id, type: BSON::ObjectId # user who writes this comment
  field :content, type: String # content of the comment

  belongs_to :commentable, :polymorphic => true
  has_many :comments, :as => :commentable, :dependent => :destroy

  voteable self, :up => 1, :down => -1

  validates_presence_of :user_id, :allow_nil => false
  before_create :reset_commentable_id

  AT_USER_SYMBOL = '@'
  AT_USER_REGEXP = /#{AT_USER_SYMBOL}(\w+)\b/

  def self.replace_at_user_exp(content)
    content.gsub(AT_USER_REGEXP) { |exp| yield AT_USER_REGEXP.match(exp)[1] }
  end

  def self.each_at_user_name(content)
    content.scan(AT_USER_REGEXP) { |exp| yield exp[0] }
  end

  # Get uer object.
  def user
    User.find(self.user_id)
  end

  alias_method :original_content, :content
  def content
    comment_content = self.original_content
    if comment_content.blank? && self.is_root_comment?
      root = self.root
      root.respond_to?(:default_root_comment_content) ? root.default_root_comment_content : ""
    else
      comment_content
    end
  end

  # Get the root object of the comment.
  def root
    parent = self.parent
    parent.is_a?(self.class) ? parent.parent : parent
  end

  def root_id
    root = self.root
    root.nil? ? nil : root._id
  end

  def is_root_comment?
    parent = self.parent
    parent.is_a?(self.class) ? false : true
  end

  def has_root?
    root = self.root
    !root.nil?
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
    self.comments.all.desc(:created_at)
  end

  protected

  def reset_commentable_id
    id = self.commentable_id
    if !id.nil? && id.is_a?(String)
      self.commentable_id = BSON::ObjectId.from_string self.commentable_id
    end
  end
end
