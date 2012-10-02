module CommentsHelper
  def comment_format(comment)
    comment_str = Comment.replace_at_user_exp(comment) do |name|
      user = User.find_if_exists(nick_name: name)
      path = user.nil? ? "javascripts: void(0);" : account_user_path(user)
      link_to Comment::AT_USER_SYMBOL + name, path
    end
    simple_format comment_str
  end
end