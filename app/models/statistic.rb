class Statistic
  class << self
    def users_online
      # because devise_lastseenable gem save last seen time as 5 minutes a step
      # and because our notification refresh every 2.5 minutes
      users_last_seen Time.now-10.minutes, Time.now
    end

    def users_login_today
      users_last_seen Time.now.midnight, Time.now.midnight + 1.day
    end

    # Public: The users last seen between some time.
    #
    # beginTime  - The begin time.
    # endTime - The end time.
    #
    # Examples
    #   # yesterday's new users
    #   Statistic.new_users(Time.now.midnight-1.day, Time.now.midnight)
    #   # => [the users]
    #
    # Returns the duplicated String.
    def users_last_seen(beginTime, endTime)
      User.where(last_seen: (beginTime..endTime)).order("last_seen ASC")
    end

    def new_users_this_month
      new_users(Time.now.beginning_of_month, Time.now.end_of_month)
    end

    def new_users_this_week
      new_users(Time.now.beginning_of_week, Time.now.end_of_week)
    end

    def new_users_today
      new_users(Time.now.midnight, Time.now.midnight + 1.day)
    end

    def new_users_yesterday
      new_users(Time.now.midnight - 1.day, Time.now.midnight)
    end

    # Public: The new_users between some time.
    #
    # beginTime  - The begin time.
    # endTime - The end time.
    #
    # Examples
    #   # yesterday's new users
    #   Statistic.new_users(Time.now.midnight-1.day, Time.now.midnight)
    #   # => [the users]
    #
    # Returns the duplicated String.
    def new_users(beginTime, endTime)
      User.where(created_at: (beginTime..endTime))
    end
  end
end
