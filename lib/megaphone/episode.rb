require 'rest-client'
require 'ostruct'
require 'json'

module Megaphone
  class Episode
    class << self
      def config
        @config ||= MegaphoneClient
      end
      
      def default_headers
        {
          content_type: 'application/json',
          authorization: "Token token=#{config.token}",
          params: {}
        }
      end

      def search options={}
        episode = connection({
          :url => "https://cms.megaphone.fm/api/search/episodes",
          :method => :get,
          :params => options
        })
      end

      def update options={}
        episode = connection({
          :url => "https://cms.megaphone.fm/api/networks/#{config.network}/podcasts/#{options[:podcast_id]}/episodes/#{options[:episode_id]}",
          :method => :put,
          :body => options[:body] || {}
        })
      end

      def connection options={}
        request_headers = default_headers.merge({ params: options[:params] })
        
        response = RestClient::Request.execute(
          url: options[:url],
          method: options[:method],
          headers: request_headers,
          payload: options[:body].to_json
        )
        
        JSON.parse(response.body, object_class: OpenStruct)
      end
    end
  end
end
