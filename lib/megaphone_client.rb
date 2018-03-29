require "megaphone_client/podcast"
require "megaphone_client/episode"

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