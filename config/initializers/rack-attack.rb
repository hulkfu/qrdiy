BLOCK_MESSAGE = ['你请求过快，超过了频率限制，暂时屏蔽一段时间。'.freeze]

class Rack::Attack
  Rack::Attack.cache.store = Rails.cache

  ### Throttle Spammy Clients ###
  throttle('req/ip', limit: 300, period: 3.minutes) do |req|
    req.ip
  end

  # 固定黑名单
  # blocklist('blacklist/ip') do |req|
  #   Setting.blacklist_ips && !Setting.blacklist_ips.index(req.ip).nil?
  # end

  # 允许 localhost
  # safelist('allow from localhost') do |req|
  #   '127.0.0.1' == req.ip || '::1' == req.ip
  # end

  ### Custom Throttle Response ###
  self.throttled_response = lambda do |_env|
    [503, {}, BLOCK_MESSAGE]
  end
end
