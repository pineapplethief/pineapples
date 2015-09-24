url = URI.parse(ENV.fetch('REDIS_URL'))

$redis = Redis.new(url: url, driver: :hiredis)
