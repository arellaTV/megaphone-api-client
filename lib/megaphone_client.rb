require "megaphone_client/podcast"
require "megaphone_client/episode"

# @author Jay Arella
module MegaphoneClient
  class ConnectionError < StandardError
  end

  class << self
    attr_accessor :api_base_url, :network_id, :organization_id, :token

    # @option options [String] :api_base_url The api base url includes the domain and `/api` endpoint
    # @option options [String] :network_id The id of the Megaphone network
    # @option options [String] :organization_id The id of the Megaphone organization
    # @option options [String] :token The api token taken from Megaphone's developer settings (https://developers.megaphone.fm/)
    # @return a new instance of MegaphoneClient
    # @example Initialize MegaphoneClient into an instance
    #   @megaphone = MegaphoneClient.new({
    #     network_id: '1234',
    #     organization_id: '5678',
    #     token: '910'
    #   })
    #
    #   @megaphone #=> new MegaphoneClient

    def new options={}
      @api_base_url = options[:api_base_url] || "https://cms.megaphone.fm/api"
      @network_id = options[:network_id]
      @organization_id = options[:organization_id]
      @token = options[:token]

      self
    end

    # @option options [Symbol] :method  Request method
    # @option options [Hash] :params Request params in a hash
    # @option options [String] :payload If the request method is `POST`, the body of the post
    # @option options [String] :url Request url
    # @note This is a generalized REST method that is used by both the Episode and Podcast class.
    #   If it's successful, it returns a struct representing the data. If it fails, it raises a ConnectionError.
    # @example Get a list of podcasts
    #   @megaphone.connection({
    #     method: :get,
    #     url: "https://cms.megaphone.fm/api/podcasts"
    #   })
    #
    #   #=> Array of structs representing podcasts

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

    # @return a hash with the default request headers, includes the token
    # @example Calling #default_headers after initializing with a token
    #   @megaphone = MegaphoneClient.new({
    #     network_id: '1234',
    #     organization_id: '5678',
    #     token: '910'
    #   })
    #
    #   @megaphone.default_headers #=> { content_type: "application/json", authorization: "Token token=910", params: {} }

    def default_headers
      {
        content_type: "application/json",
        authorization: "Token token=#{@token}",
        params: {}
      }
    end

    # @return a new instance of MegaphoneClient::Episode
    # @example Initialize MegaphoneClient into an instance
    #   @megaphone = MegaphoneClient.new({
    #     network_id: '1234',
    #     organization_id: '5678',
    #     token: '910'
    #   })
    #
    #   @megaphone.episode #=> new MegaphoneClient::Episode

    def episode
      self::Episode
    end

    # @return a new instance of MegaphoneClient::Podcast
    # @example Initialize MegaphoneClient into an instance
    #   @megaphone = MegaphoneClient.new({
    #     network_id: '1234',
    #     organization_id: '5678',
    #     token: '910'
    #   })
    #
    #   @megaphone.episode #=> new MegaphoneClient::Podcast

    def podcast
      self::Podcast
    end
  end
end