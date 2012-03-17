module CommentableHelper

  # Inject the class methods to the object's class.
  def self.included(c)
    c.instance_eval do
      extend CommentableHelper::ClassMethods
    end
  end

  module ClassMethods
    def acts_as_commentable
      has_many :comments, :as => :commentable, :dependent => :destroy
      include CommentableHelper::LocalInstanceMethods
      extend CommentableHelper::SingletonMethods
    end
  end

  # Singleton methods.
  module SingletonMethods
    # Helper method to lookup for comments for a given object.
    # This method is equivalent to obj.comments.
    def find_comments_for(obj)
      Comment.where(:commentable_id => obj._id, :commentable_type => obj.class).desc(:created_time)
    end

    # Lookup comments for the mixin commentable type written by a given user.
    # NOT equivalent to Comment.find_comments_for_user.
    def find_comments_by_user(user)
      Comment.where(:user_id => user._id, :commentable_type => self).desc(:created_time)
    end
  end

  module LocalInstanceMethods
    # Display only root comments, no children/replies
    def root_comments
      self.comments.all.desc(:created_time)
    end

    # Display all comments
    def all_comments
      self.comments.all.map { |comment| comment.recursive_comments }
    end

    # Sort comments by date
    def comments_ordered_by_created
      Comment.where(:commentable_id => id, :commentable_type => self.class.name).desc(:created_time)
    end

    # Defaults the submitted time.
    def add_comment(comment)
      self.comments << comment
    end
  end
end