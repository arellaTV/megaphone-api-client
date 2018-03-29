require "ostruct"
require "json"
require "rest-client"

module MegaphoneClient
  class Episode
    class << self
      def config
        @config ||= MegaphoneClient
      end

      def default_headers
        {
          content_type: "application/json",
          authorization: "Token token=#{config.token}",
          params: {}
        }
      end

      def search options={}
        params = options

        # If an organizationId wasn't given in options and there is an organization_id in config
        if !options[:organizationId] && config.organization_id
          # Merge the organization_id from config into the params object
          params = options.merge({ organization_id: config.organization_id })
        end

        episode = connection({
          :url => "#{config.api_base_url}/search/episodes",
          :method => :get,
          :params => params
        })
      end

      def update options={}
        if !options[:podcast_id] || !options[:episode_id]
          return OpenStruct.new({
            error: "Both podcast_id and episode_id options are required."
          })
        end

        episode = connection({
          :url => "#{config.api_base_url}/networks/#{config.network_id}/podcasts/#{options[:podcast_id]}/episodes/#{options[:episode_id]}",
          :method => :put,
          :body => options[:body] || {}
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
