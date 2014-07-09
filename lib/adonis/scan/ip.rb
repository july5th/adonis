#encoding: utf-8

require 'thread'

module ADONIS
module SCAN

class Ip

    def self.ip_hash
        return @ip_hash if not @ip_hash.nil?
        tmp_hash = {}
        tmp_key = nil
        tmp_list = []
        reip = /^([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})\s*([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}).*/
        ip_file = File.open(File.join(::ADONIS::BaseDir, "/data/ip/ip.txt"), "r")

        ip_file.each_line do |line|
            line = line.strip
            #滤过空行：
            next if line.size == 0
            #是否是IP分段：
            if line =~ reip 
                tmp_list << ::Rex::Socket::RangeWalker.new("#{$1}-#{$2}")
            else
                tmp_hash[tmp_key] = tmp_list if tmp_key != nil
                tmp_hash[line] = nil
                tmp_key = line
                tmp_list = []
            end
            
        end

        tmp_hash[tmp_key] = tmp_list if tmp_key != nil
        @ip_hash = tmp_hash
        return @ip_hash
    end

    def self.get_ip_list(province)
        ip_hash[province]
    end

    def self.get_ip_list_num(province)
        length = 0
        ip_hash[province].each do |range|
            length = length + range.length
        end
        return length
    end

    def self.get_province(ip)
        ip_hash.each_pair do |key, v|
            v.each do |r|
                return key if r.include?(ip)
            end
        end
        return nil
    end

end

end
end

