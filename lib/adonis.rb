#encoding: utf-8

require 'active_record'
require 'redis'
require 'yaml'

require 'env'
require 'rex'

module ADONIS

    BaseDir = File.expand_path(File.dirname(File.dirname(__FILE__)))

    BinDir = File.expand_path(File.join(BaseDir, 'bin'))
    LibarayDir = File.expand_path(File.join(BaseDir, 'lib'))
    DataDir = File.expand_path(File.join(BaseDir, 'data'))
    TmpDir = File.expand_path(File.join(BaseDir, 'tmp'))
    LogDir = File.expand_path(File.join(BaseDir, 'log'))

    #加载配置文件
    @@config = YAML::load File.open(File.join(BaseDir, "config.yml"))

    def self.config
        @@config
    end

    #初始化数据库
    ::ActiveRecord::Base.establish_connection(@@config[:database])

    @auto_exploit = false

    def self.auto_exploit
        @auto_exploit
    end

    def self.set_auto_exploit v
        @auto_exploit = v
    end
end


# 导入model文件夹
model_file_path = File.join(::ADONIS::LibarayDir, "/adonis/model/*.rb")
Dir[model_file_path].each do |model_file|
    load model_file
end

# 导入公共库
require 'adonis/scan/ip.rb'
require 'adonis/scan/import.rb'
require 'adonis/scan/scan.rb'

require 'adonis/common/show.rb'
require 'adonis/common/queue.rb'
require 'adonis/common/database.rb'
require 'adonis/common/log.rb'

require 'adonis/exploit/base.rb'
require 'adonis/exploit/exploit.rb'
require 'adonis/exploit/hydra.rb'
require 'adonis/exploit/brute_fource_base.rb'


# 加载expliot module
::ADONIS::EXPLOIT::Exploit.load_modules
