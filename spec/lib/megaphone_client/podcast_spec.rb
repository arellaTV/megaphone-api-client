require 'megaphone_client'
require 'ostruct'
require 'spec_helper'
require 'webmock/rspec'

describe MegaphoneClient::Podcast do
  describe "list" do
    before :each do
      @megaphone = MegaphoneClient.new({ network_id: "STUB_NETWORK_ID" })
      @podcasts = @megaphone.podcasts
    end

    it "should only perform GET requests" do
      request_uri = "https://cms.megaphone.fm/api/networks/STUB_NETWORK_ID/podcasts"
      VCR.use_cassette("podcast_list_result_01") do
        @podcasts.list
        expect(WebMock).to have_requested(:get, request_uri)
        expect(WebMock).not_to have_requested(:put, request_uri)
        expect(WebMock).not_to have_requested(:post, request_uri)
        expect(WebMock).not_to have_requested(:patch, request_uri)
        expect(WebMock).not_to have_requested(:delete, request_uri)
      end
    end
  end
end