#encoding: utf-8

module ADONIS
module SCAN


class Import


    def initialize 
    	@start_time = nil
    	@import_host_hash = {}
    	@scan_port_list = []
    	@run = true
    end

    def import 
        i = 0
        exploit_list = []
        port_str = ::ADONIS::COMMON::Queue.lpop "adonis_scan_queue"
        while port_str != nil
            i = i + 1
            port_list = port_str.split(":")
            if port_list.size == 4 && (port_list[1] == "tcp" or port_list[1] == "udp") && (port_list[2] == port_list[2].to_i.to_s) && (port_list[3] == port_list[3].to_i.to_s)
                scan_logger.info("ADONIS::SCAN::Import.run, #{port_str}")

		@import_host_hash.update({port_list[0] => []}) unless @import_host_hash.has_key?(port_list[0])
		@import_host_hash[port_list[0]].push "#{port_list[1]}_#{port_list[2]}"

                host = ::ADONIS::MODEL::Host.add(port_list[0], ["#{port_list[1]}_#{port_list[2]}"], port_list[3])
                if ::ADONIS.auto_exploit and not exploit_list.include?(host.id)
                    ::ADONIS::EXPLOIT::Exploit.add_target host
                    exploit_list.push host.id
                end
            else
                scan_logger.error("ADONIS::SCAN::Import.run, #{port_str}")
            end
            port_str = ::ADONIS::COMMON::Queue.lpop "adonis_scan_queue"
        end
        return i
    end

    # start import
    def run
        @start_time = Time.now.to_i
        @scan_port_list = ::ADONIS::MODEL::Host.port_key_list

        while @run
            begin
                import
                sleep 1
            rescue => e
                p e
            end
        end
    end

    def clear target = nil, tag = nil
	@run = false
	target = @import_host_hash.keys if target == nil
	target.each do |k|
		tmp_list = @scan_port_list - (@import_host_hash[k] || [])
		if tmp_list.size > 0
			begin
				host = ::ADONIS::MODEL::Host.where(:ip => k).first
				next if host == nil
				host.tag = tag unless tag.is_blank?
				tmp_list.each do |l|
                			scan_logger.info("ADONIS::SCAN::Import.clear, #{k} #{l}")
					host.instance_eval "host.#{l} = nil"
				end
				host.save
			rescue
				pass
			end
		end
	end
    end
end

end
end

