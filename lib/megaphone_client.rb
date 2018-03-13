require "megaphone"

module MegaphoneClient
  class << self
    attr_accessor :token, :network, :organization
  end
  
  def self.setup
    yield self
  end
end