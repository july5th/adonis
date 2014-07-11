#encoding: utf-8

module ADONIS
module COMMON

class Show

    ## 显示主机
    def self.show_target targets
        columns = ['IP']
        port_key_list = ::ADONIS::MODEL::Host.port_key_list
        port_key_list.each do |port_str|
            columns << port_str
        end
        #columns << "uncommon_port"
        columns << "scan_time"

        show_table = Rex::Ui::Text::Table.new(
            'Header' => '主机列表',
            'Ident' => 1,
            'Columns' => columns,
        )

        targets.each do |host|
            col = [host.ip]
            port_key_list.each do |port_str|
                col <<  (host.instance_eval(port_str) ? port_str : "--")
            end

            #col << host.uncommon_port_list.join(",")
            col << host.created_at.to_s
            show_table.add_row col
        end

        show_table.print
        return targets.size
    end

    ## 显示主机
    def self.show_exm exms
        columns = ['IP', 'MID', 'PA', 'PB', 'PC', 'PD', 'TIME', 'M_DESC']

        show_table = Rex::Ui::Text::Table.new(
            'Header' => '漏洞列表',
            'Ident' => 1,
            'Columns' => columns,
        )

        exms.each do |exm|
            module_class = ::ADONIS::EXPLOIT::Exploit.exploit_module_hash[exm.module_id]
            pa = exm.pa ? exm.pa : "--"
            pb = exm.pb ? exm.pb : "--"
            pc = exm.pc ? exm.pc : "--"
            pd = exm.pd ? exm.pd : "--"
            col = [exm.host.ip, exm.module_id, pa, pb, pc, pd, exm.created_at, module_class.desc]
            show_table.add_row col
        end

        show_table.print
        return exms.size
    end

    def self.show_target_by_port port_str, limit = nil
        show_target get_target_by_port(port_str, limit)
    end

    def self.show_exms_by_host hosts
        exms = []
        hosts.each do |t|
            t.exms.each do |e|
                exms << e
            end
        end

        show_exm exms
        return exms.size
    end

    #显示exploit插件
    def self.show_exploit_module
        columns = ["ID", "Family", "Name", "Port", "Status", "DESC"]
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
end

end
end
