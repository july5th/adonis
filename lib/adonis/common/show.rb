#encoding: utf-8

module ADONIS
module COMMON

class Show

    ## 显示主机
    def self.show_target targets, verbose = false
        columns = ['IP']
        port_key_list = ::ADONIS::MODEL::Host.port_key_list
        port_key_list.each do |port_str|
            columns << port_str
        end
        #columns << "uncommon_port"
        columns << "tag"
        columns << "is_vuln" if verbose 
        columns << "is_control" if verbose 
        columns << "scan_time" unless verbose 

        show_table = Rex::Ui::Text::Table.new(
            'Header' => '主机列表',
            'Ident' => 1,
            'Columns' => columns,
        )

        targets.each do |host|
            col = [host.ip]
            port_key_list.each do |port_str|
		if verbose 
                	col <<  (host.instance_eval(port_str) ? "#{port_str} - (#{Time.at(host.instance_eval(port_str))})" : "--")
		else
                	col <<  (host.instance_eval(port_str) ? port_str : "--")
		end
            end

            #col << host.uncommon_port_list.join(",")
            col <<  (host.tag ? host.tag : "--")
            col <<  (host.is_vuln.blank? ? '--' : Time.at(host.is_vuln) ) if verbose
            col <<  (host.is_control.blank? ? '--' : Time.at(host.is_control) ) if verbose
            col << host.created_at.to_s unless verbose 
            show_table.add_row col
        end

        show_table.print
        return targets.size
    end

    ## 显示可渗透主机
    def self.show_exm exms, verbose = false
        columns = ['IP', 'MID', 'P1', 'P2', 'P3', 'P4', 'P5', 'TIME', 'M_DESC']

        show_table = Rex::Ui::Text::Table.new(
            'Header' => '漏洞列表',
            'Ident' => 1,
            'Columns' => columns,
        )

        exms.each do |exm|
	    next if (not verbose) && exm.active_time.blank?
	    exploit_node = ::ADONIS::EXPLOIT::ModuleHelper.find_node_by_id(exm.module_id)
	    next if exploit_node.blank?
            base = ::ADONIS::EXPLOIT::ModuleHelper.find_node_by_id(exm.module_id).base
            p1 = exm.p1 ? exm.p1 : "--"
            p2 = exm.p2 ? exm.p2 : "--"
            p3 = exm.p3 ? exm.p3 : "--"
            p4 = exm.p4 ? exm.p4 : "--"
            p5 = exm.p5 ? exm.p5 : "--"
            col = [exm.host.ip, exm.module_id, p1, p2, p3, p4, p5, exm.active_time ? Time.at(exm.active_time) : '--', base.desc]
            show_table.add_row col
        end

        show_table.print
        return exms.size
    end

    def self.show_target_by_port port_str, limit = nil
        show_target get_target_by_port(port_str, limit)
    end

    def self.show_exms_by_host hosts, verbose = false
        exms = []
        hosts.each do |t|
            t.exms.each do |e|
                exms << e
            end
        end

        show_exm exms, verbose
        return exms.size
    end

    def self.show_exploit_module_tree
        columns = ["node_name", "father_node_name", "base_name", "active", "is_end", "children_list_size"]
        show_table = Rex::Ui::Text::Table.new(
            'Header' => "EXPLOIT模块",
            'Ident' => 1,
            'Columns' => columns,
        )

        active_module_list = ::ADONIS::EXPLOIT::Exploit.get_exploit_module_list
        
        ::ADONIS::EXPLOIT::Exploit.exploit_module_spec_hash.each_pair do |kind, module_hash|
            module_hash.each_pair do |k, v|
                show_table.add_row [k, kind.to_s, v.name, v.port_str, active_module_list.include?(v.id) ? "active" : "--", v.desc]
            end
        end

        show_table.print
        return ::ADONIS::EXPLOIT::Exploit.exploit_module_hash.size
    end

    def self.print_detail hosts
	hosts.each do |host|
		__print_detail host
	end
    end

    def self.__print_detail host
        columns = ['ID', 'K', 'V']
        show_table = Rex::Ui::Text::Table.new(
            'Header' => host.ip,
            'Ident' => 1,
            'Columns' => columns,
        )

	open_port_list = []
        ::ADONIS::MODEL::Host.port_key_list.each do |port_str|
                open_port_list << port_str if host.instance_eval(port_str)
	end

        show_table.add_row [1, 'open_port', open_port_list]

	general_items = ['finger', 'os', 'tested_exploit_modules', 'exploit_modules', 'is_vuln', 
		'is_control', 'tag', 'desc']
	
	general_items.each_with_index do |v, i|
		i += 2
		msg = host.instance_eval v
        	show_table.add_row [i, v, msg]
	end
        show_table.print
	printf "\nhistory:"
	printf host.history.gsub("--", "\n").gsub("\n", "\n\t") if host.history
	printf "\n"
    end
end

end
end
