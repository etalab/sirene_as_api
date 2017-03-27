require 'connection_pool'

Redis::Objects.redis = ConnectionPool.new(size: 5, timeout: 5) { Redis.new(host: '127.0.0.1', port: 6379) }
