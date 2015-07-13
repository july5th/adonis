#encoding: utf-8

module ADONIS
module MODULE

class Ftp_fource_login < ::ADONIS::EXPLOIT::BruteFourceBase
    #command = "#{@cmd} #{@args} #{host.ip} #{@type}"
    def init
        id = 4004
        service_name = "ftp"
        father_node_name = "tcp_21"
        brute_fource_init(id, service_name, father_node_name)
        @args = "-e ns"
        return self
    end
end

end
end

