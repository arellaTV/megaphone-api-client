require 'ostruct'
require 'json'
require 'rest-client'

module MegaphoneClient
  class Podcast
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

      def list options={}
        episode = connection({
          :url => "https://cms.megaphone.fm/api/networks/#{config.network_id}/podcasts",
          :method => :get
        })
      end
      
      def connection options={}
        request_headers = default_headers.merge({ params: options[:params] })
        
        begin
          response = RestClient::Request.execute(
            url: options[:url],
            method: options[:method],
            headers: request_headers,
            payload: options[:body].to_json
          )
          response_body = response.body
        rescue RestClient::ExceptionWithResponse => err
          response_body = {
            body: err.response.body,
            code: err.response.code,
            description: err.response.description,
            headers: err.response.headers,
            history: err.response.history
          }.to_json
        end

        JSON.parse(response_body, object_class: OpenStruct)
      end
      
    end
  end
end
