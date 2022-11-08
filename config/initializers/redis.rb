require 'connection_pool'

Redis::Objects.redis = ConnectionPool.new(size: 5, timeout: 5) { Redis.new(host: ENV.fetch("REDIS_URL") { "127.0.0.1" }, port: 6379) }
