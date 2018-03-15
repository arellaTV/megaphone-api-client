require "megaphone"

module MegaphoneClient
  class << self
    attr_accessor :token, :network_id, :organization_id
  end
  
  def self.setup
    yield self
  end
end