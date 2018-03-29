require "megaphone/podcast"
require "megaphone/episode"

module MegaphoneClient
  class << self
    attr_accessor :api_base_url, :network_id, :organization_id, :token

    def new(options)
      @api_base_url = options[:api_base_url] || "https://cms.megaphone.fm/api"
      @network_id = options[:network_id]
      @organization_id = options[:organization_id]
      @token = options[:token]

      self
    end

    def episode
      self::Episode
    end

    def podcast
      self::Podcast
    end
  end
end