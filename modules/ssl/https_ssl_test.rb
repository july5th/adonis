#encoding: utf-8

require 'thread'

module ADONIS
module MODULE

class HttpsSSLTest < ::ADONIS::EXPLOIT::SSLTestBase

    def init
        module_id = 4100
        service_name = "https"
        port_str = "tcp_443"
        ssl_test_init(module_id, service_name, port_str)
        return self
    end

end

end
end

