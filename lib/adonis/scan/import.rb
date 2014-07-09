#encoding: utf-8

module ADONIS
module SCAN


class Import

    def self.import
        i = 0
        port_str = ::ADONIS::COMMON::Queue.lpop "adonis_scan_queue"
        while port_str != nil
            i = i + 1
            port_list = port_str.split(":")
            if port_list.size == 3 && (port_list[1] == "tcp" or port_list[1] == "udp") && (port_list[2] == port_list[2].to_i.to_s)
                logger.info("ADONIS::SCAN::Import.run, #{port_str}")
                host = ::ADONIS::MODEL::Host.add(port_list[0], ["#{port_list[1]}_#{port_list[2]}"])
                ::ADONIS::EXPLOIT::Exploit.add_target host
            else
                logger.error("ADONIS::SCAN::Import.run, #{port_str}")
            end
            port_str = ::ADONIS::COMMON::Queue.lpop "adonis_scan_queue"
        end
        return i
    end

    def self.run
        while true
            import
            sleep 5
        end
    end

end

end
end

