#encoding: utf-8

module ADONIS
module COMMON

class Queue

    #初始化REDIS
    @@redis = ::Redis.new(::ADONIS.config[:redis])

    def self.lpush queue_name, x
        @@redis.lpush queue_name, x
    end

    def self.lpop queue_name
        @@redis.lpop queue_name
    end

end

end
end
