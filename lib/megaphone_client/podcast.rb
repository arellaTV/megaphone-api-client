require "ostruct"
require "json"
require "rest-client"

module MegaphoneClient
  class Podcast
    class << self
      def config
        @config ||= MegaphoneClient
      end

      def list options={}
        episode = MegaphoneClient.connection({
          :url => "#{config.api_base_url}/networks/#{config.network_id}/podcasts",
          :method => :get
        })
      end
    end
  end
end
