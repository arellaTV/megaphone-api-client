require 'faraday'
require 'ostruct'
require 'json'

module Megaphone
  class Episode
    class << self
      def config
        @config ||= MegaphoneClient
      end
      
      def find external_id
        episode = connection("https://cms.megaphone.fm/api/search/episodes?externalId=#{external_id}")
        
        episode.first
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
