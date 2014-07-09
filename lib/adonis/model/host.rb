#encoding: utf-8

module ADONIS
module MODEL

class Host < ActiveRecord::Base

    has_many :exms, :foreign_key => "host_id"

    def self.port_key_list
        ::ADONIS.config[:port]
    end


    # Host.add(127.1.1.1, [tcp_80, udp_8080])
    def self.add(ip, port_list)
        host = ::ADONIS::MODEL::Host.where(:ip => ip)
        if host.size != 0
            host = host.first
        else
            host = ::ADONIS::MODEL::Host.new
            host.ip = ip
        end

        port_list.each do |port_str|
            if port_key_list.include?(port_str)
                host.instance_eval "self.#{port_str} = true"
            else
                host.add_uncommon_port(port_str)
            end
        end

        host.save

        return host
    end

    def add_uncommon_port(port_str)
        return if self.uncommon_port_list.include?(port_str)
        self.open_ports = self.uncommon_port_list.push(port_str).to_json
    end

    def uncommon_port_list
        return Array.new if self.open_ports.blank?
        JSON.parse(self.open_ports)
    end

    def common_port_list
        tmp_list = []
        ::ADONIS::MODEL::Host.port_key_list.each do |port_str|
            if self.instance_eval(port_str) == true
                tmp_list.push(port_str)
            end
        end
        return tmp_list
    end

    def tested_exploit_module_list
        return Array.new if self.tested_exploit_modules.blank?
        JSON.parse(self.tested_exploit_modules)
    end

    def add_tested_exploit_module(id)
        return if self.tested_exploit_module_list.include?(id)
        self.tested_exploit_modules = self.tested_exploit_module_list.push(id).to_json
    end

    def is_tested_by_exploit(id)
        self.tested_exploit_module_list.include?(id) ? true : false
    end

    def exploit_module_list
        return Array.new if self.exploit_modules.blank?
        JSON.parse(self.exploit_modules)
    end

    def add_exploit_module(id)
        return if self.exploit_module_list.include?(id)
        self.exploit_modules = self.exploit_module_list.push(id).to_json
    end

    def can_exploit_by(id)
        self.exploit_module_list.include?(id) ? true : false
    end
end

end
end
