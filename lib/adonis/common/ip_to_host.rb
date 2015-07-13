#encoding: utf-8
require "open-uri"
require 'resolv'
require 'timeout'
require 'json'

module ADONIS
module COMMON

class IpToHost

    attr_accessor :ip, :num, :addr, :web_list

    def initialize ip
	@ip = ip
	@num = 0
	@addr = nil
	@tmp_web_list = []
	@web_list = []
    end

    def query
	begin
		__query
		check
	rescue
	end
    end

    def __query
	html_response = nil
 	url = "http://dns.aizhan.com/index.php?r=index/domains&ip=#{@ip}&page=1&_=1416561981372"
	open(url) do |http|
		html_response = http.read
	end
	sleep 0.1
	tmp_json = JSON.parse html_response
	@num = tmp_json['count']
	@tmp_web_list = tmp_json['domains']
    end

    def check
	@tmp_web_list.each do |web|
		ip_addr = nil
		
		begin
			Timeout.timeout(2) { ip_addr = Resolv.getaddress(web) }
		rescue
		end
		@web_list.push web if ip_addr == @ip
	end
    end

end

end
end
