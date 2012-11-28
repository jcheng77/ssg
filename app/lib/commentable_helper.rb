module CommentableHelper

  ROOT_TYPE_SINGLE = :single
  ROOT_TYPE_MULTIPLE = :multiple

  # Inject the class methods to the object's class.
  def self.included(c)
    c.instance_eval do
      extend CommentableHelper::ClassMethods
    end
  end

  module ClassMethods
    def acts_as_commentable(root_type = ROOT_TYPE_SINGLE)
      case root_type
      when ROOT_TYPE_SINGLE
        has_one :comment, :as => :commentable, :dependent => :destroy
        include CommentableHelper::SingleLocalInstanceMethods
      when ROOT_TYPE_MULTIPLE
        has_many :comments, :as => :commentable, :dependent => :destroy
        include CommentableHelper::MultipleLocalInstanceMethods
      end
      include CommentableHelper::CommonLocalInstanceMethods
      extend CommentableHelper::SingletonMethods
    end
  end

  # Singleton methods.
  module SingletonMethods
    # Helper method to lookup for comments for a given object.
    # This method is equivalent to obj.comments.
    def find_comments_for(obj)
      Comment.where(:commentable_id => obj._id, :commentable_type => obj.class).desc(:created_at)
    end

    # Lookup comments for the mixin commentable type written by a given user.
    # NOT equivalent to Comment.find_comments_for_user.
    def find_comments_by_user(user)
      Comment.where(:user_id => user._id, :commentable_type => self).desc(:created_at)
    end
  end

  module SingleLocalInstanceMethods
    # Display only root comments, no children/replies.
    def root_comments
      comment = self.comment
      comment.nil? ? [] : [comment]
    end

    # Display all comments.
    def all_comments
      self.comment.recursive_comments
    end

    def comment_content
      comment = self.comment
      comment.nil? ? nil : comment.content
    end
  end

  module MultipleLocalInstanceMethods
    # Display only root comments, no children/replies.
    def root_comments
      self.comments.all.desc(:created_at)
    end

    # Display all comments.
    def all_comments
      self.comments.all.map { |comment| comment.recursive_comments }
    end
  end

  module CommonLocalInstanceMethods
    # Sort comments by date.
    def comments_ordered_by_created
      Comment.where(:commentable_id => id, :commentable_type => self.class.name).desc(:created_at)
    end
  end
end
