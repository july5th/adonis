#encoding: utf-8

require 'thread'

module ADONIS
module MODULE

class WebInfo < ::ADONIS::EXPLOIT::Base
    def init
        module_id = 10001
        name = "web_info"
        port_str = ['tcp_80', 'tcp_8080']
        desc = '获取HEADER和TITLE信息'
        info_init(module_id, name, port_str, desc)
        return self
    end

    def info_func target
        p 'start info_func'
    end
end

end
end
