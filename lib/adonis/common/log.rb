#encoding: utf-8

module ADONIS
module COMMON

class Log
    #初始化LOG
    @@logger = Logger.new(File.join(LogDir, "adonis.log"))
    @@scan_logger = Logger.new(File.join(LogDir, "scan.log"))
    @@exploit_logger = Logger.new(File.join(LogDir, "exploit.log"))

    def self.logger
        @@logger
    end

    def self.exploit_logger
        @@exploit_logger
    end

end

end
end

module Kernel

    def logger
        ::ADONIS::COMMON::Log.logger
    end

    def exploit_logger
        ::ADONIS::COMMON::Log.exploit_logger
    end

end

