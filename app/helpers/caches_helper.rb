##
# cache 相关的 helper，主要是 cache_key
#
module CachesHelper
  def cache_key_for_users(users)
    return "" unless users
    count = users.count
    max_updated_at = users.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "users/all-#{count}-#{max_updated_at}"
  end

  def cache_key_for_comments(comments)
    return "" unless comments
    count          = comments.count
    max_updated_at = comments.maximum(:updated_at).try(:utc).try(:to_s, :number)
    users = User.where(id: comments.map(&:user_id).uniq)
    "comments/all-#{count}-#{max_updated_at}-#{cache_key_for_users(users)}"
  end

  ##
  # TODO 要考虑到所有会影响 status view 的因素：
  # - status 自己
  # - status.user
  # - statusable
  # - comments
  def cache_key_for_status(status)

  end
end
