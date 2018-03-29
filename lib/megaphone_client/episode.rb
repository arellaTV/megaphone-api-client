require "ostruct"
require "json"
require "rest-client"

module MegaphoneClient
  class Episode
    class << self
      def config
        @config ||= MegaphoneClient
      end

      def search options={}
        params = options

        # If an organizationId wasn't given in options and there is an organization_id in config
        if !options[:organizationId] && config.organization_id
          # Merge the organization_id from config into the params object
          params = options.merge({ organization_id: config.organization_id })
        end

        episode = MegaphoneClient.connection({
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

        episode = MegaphoneClient.connection({
          :url => "#{config.api_base_url}/networks/#{config.network_id}/podcasts/#{options[:podcast_id]}/episodes/#{options[:episode_id]}",
          :method => :put,
          :body => options[:body] || {}
        })
      end
    end
  end
end
