require 'megaphone_client'
require 'megaphone'
require 'ostruct'
require 'spec_helper'
require 'webmock/rspec'

## config
# Should equal MegaphoneClient if MegaphoneClient is set up

## default_headers
# Should apply a token from configuration

## search
# Should merge in the configuration organization_id if none is given in options
# Should stick with option organizationId if given
# Should pass a `GET` option to connection

## update
# Should return a an Error OpenStruct if no podcast_id or episode_id is given
# Should pass in an empty object for the body param if no body option is given in update
# Should pass a `PUT` option to connection

## connection
# Should add params to request_headers if they exist
# Should respond with Error OpenStruct with at least the following properties
# Should respond with a Success OpenStruct

describe Megaphone::Episode do
  describe "Megaphone.config" do
    it "should equal MegaphoneClient if MegaphoneClient is set up" do
      MegaphoneClient.setup do |config|
        config.token = "STUB_TOKEN"
        config.network_id = "STUB_NETWORK_ID"
        config.organization_id = "STUB_ORGANIZATION_ID"
      end
      
      expect(Megaphone::Episode.config.token).to eq "STUB_TOKEN"
      expect(Megaphone::Episode.config.network_id).to eq "STUB_NETWORK_ID"
      expect(Megaphone::Episode.config.organization_id).to eq "STUB_ORGANIZATION_ID"
    end
  end
  
  describe "Megaphone.default_headers" do
    it "should apply a token from configuration" do
      MegaphoneClient.setup do |config|
        config.token = "STUB_TOKEN"
      end
      
      expect(Megaphone::Episode.default_headers[:authorization]).to include "STUB_TOKEN"
    end
  end
  
  describe "Megaphone.search" do
    it "should merge in the configuration organization_id if none is given in options" do      
      stub_request(:get, "https://cms.megaphone.fm/api/search/episodes?organizationId=STUB_ORGANIZATION_ID")
        .with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip, deflate', 'Authorization'=>'Token token=STUB_TOKEN', 'Content-Length'=>'4', 'Content-Type'=>'application/json', 'Host'=>'cms.megaphone.fm', 'User-Agent'=>'rest-client/2.0.1 (darwin16.4.0 x86_64) ruby/2.1.0p0'})
        .to_return(:status => 200, :body => FIXTURES[:search_result], :headers => {})
      
      expected_struct = load_fixture("search_result.json")

      response = Megaphone::Episode.search({ organizationId: "STUB_ORGANIZATION_ID" })
      expect(WebMock).to have_requested(:get, "https://cms.megaphone.fm/api/search/episodes?organizationId=STUB_ORGANIZATION_ID").once
      expect(response).to eq expected_struct
    end
  end
end