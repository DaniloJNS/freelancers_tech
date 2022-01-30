redis_host = ENV.fetch('REDIS_HOST') { 'redis://localhost:6370/0' }

# The constant below will represent ONE connection, present globally in models, controllers, views etc for the instance. No need to do Redis.new everytime
REDIS = Redis.new(url: redis_host)
