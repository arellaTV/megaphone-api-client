require 'megaphone_client'
require 'ostruct'
require 'spec_helper'
require 'webmock/rspec'

describe MegaphoneClient do
  describe "Megaphone.config" do
    it "should equal MegaphoneClient if MegaphoneClient is set up" do
      @megaphone = MegaphoneClient.new({
        network_id: "STUB_NETWORK_ID",
        organization_id: "STUB_ORGANIZATION_ID",
        token: "STUB_TOKEN"
      })

      expect(@megaphone.episode.config.token).to eq "STUB_TOKEN"
      expect(@megaphone.episode.config.network_id).to eq "STUB_NETWORK_ID"
      expect(@megaphone.episode.config.organization_id).to eq "STUB_ORGANIZATION_ID"
      expect(@megaphone.podcast.config.token).to eq "STUB_TOKEN"
      expect(@megaphone.podcast.config.network_id).to eq "STUB_NETWORK_ID"
      expect(@megaphone.podcast.config.organization_id).to eq "STUB_ORGANIZATION_ID"
    end
  end

  describe "Megaphone.default_headers" do
    it "should apply a token from configuration" do
      @megaphone = MegaphoneClient.new({ token: "STUB_TOKEN" })
      expect(@megaphone.default_headers[:authorization]).to include "STUB_TOKEN"
    end
  end
end