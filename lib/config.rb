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

