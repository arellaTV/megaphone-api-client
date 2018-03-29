require "megaphone/podcast"
require "megaphone/episode"

module MegaphoneClient
  class << self
    attr_accessor :token, :network_id, :organization_id

    def new(options)
      puts options[:token]
      @token = options[:token]
      @network_id = options[:network_id]
      @organization_id = options[:organization_id]

      self
    end
  end
end