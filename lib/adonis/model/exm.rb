#encoding: utf-8

module ADONIS
module MODEL

class Exm < ActiveRecord::Base
    belongs_to :host, :foreign_key => "host_id"
end

end
end
