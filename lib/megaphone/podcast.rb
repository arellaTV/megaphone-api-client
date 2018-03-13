require 'faraday'
require 'ostruct'
require 'json'

module Megaphone
  class Podcast
    class << self
      def config
        @config ||= MegaphoneClient
      end

      def list
        connection("https://cms.megaphone.fm/api/networks/#{config.network}/podcasts")
      end
      
      def connection url
        conn = Faraday.new(:url => url)
        
        response = conn.get do |req|
          req.headers['Content-Type'] = 'application/json'
          req.headers['Authorization'] = "Token token=#{config.token}"
        end
        
        JSON.parse(response.body, object_class: OpenStruct)
      end
      
    end
  end
end
