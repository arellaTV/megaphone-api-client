require "megaphone_client/podcast"
require "megaphone_client/episode"

module MegaphoneClient
  class ConnectionError < StandardError
  end

  # @author Jay Arella
  class << self
    attr_accessor :api_base_url, :network_id, :organization_id, :token

    # @option options [String] :api_base_url The api base url that includes the domain and /api prefix
    # @option options [String] :network_id The id of the Megaphone network you'd like to interface with
    # @option options [String] :organization_id The id of the Megaphone organization you'd like to interface with
    # @option options [String] :token The api token taken from Megaphone's developer settings (https://developers.megaphone.fm/)
    def new options={}
      @api_base_url = options[:api_base_url] || "https://cms.megaphone.fm/api"
      @network_id = options[:network_id]
      @organization_id = options[:organization_id]
      @token = options[:token]

      self
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
      rescue RestClient::ExceptionWithResponse => err
        raise ConnectionError.new("Megaphone ConnectionError: #{err.response.description}")
      end

      JSON.parse(response.body, object_class: OpenStruct)
    end

    def default_headers
      {
        content_type: "application/json",
        authorization: "Token token=#{@token}",
        params: {}
      }
    end

    def episode
      self::Episode
    end

    def podcast
      self::Podcast
    end
  end
end