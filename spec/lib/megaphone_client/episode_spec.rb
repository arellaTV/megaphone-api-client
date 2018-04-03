require 'megaphone_client'
require 'ostruct'
require 'spec_helper'
require 'webmock/rspec'

describe MegaphoneClient::Episode do
  describe "search" do
    before :each do
      @megaphone = MegaphoneClient.new({ organization_id: "STUB_ORGANIZATION_ID" })
      @episode = @megaphone.episode
    end

    it "should merge in the configuration organization_id if none is given in options" do
      VCR.use_cassette("search_result_01") do
        response = @episode.search
        expect(WebMock).to have_requested(:get, "https://cms.megaphone.fm/api/search/episodes?organizationId=STUB_ORGANIZATION_ID").once
      end
    end

    it "should stick to the organizationId if given in options" do
      VCR.use_cassette("search_result_02") do
        response = @episode.search({ organizationId: "STUB_ORGANIZATION_FROM_OPTIONS" })
        expect(WebMock).to have_requested(:get, "https://cms.megaphone.fm/api/search/episodes?organizationId=STUB_ORGANIZATION_FROM_OPTIONS").once
        expect(WebMock).not_to have_requested(:get, "https://cms.megaphone.fm/api/search/episodes?organizationId=STUB_ORGANIZATION_ID")
      end
    end

    it "should only perform GET requests" do
      request_uri = "https://cms.megaphone.fm/api/search/episodes?organizationId=STUB_ORGANIZATION_ID"
      VCR.use_cassette("search_result_01") do
        @episode.search
        expect(WebMock).to have_requested(:get, request_uri)
        expect(WebMock).not_to have_requested(:put, request_uri)
        expect(WebMock).not_to have_requested(:post, request_uri)
        expect(WebMock).not_to have_requested(:patch, request_uri)
        expect(WebMock).not_to have_requested(:delete, request_uri)
      end
    end
  end

  describe "update" do
    request_uri = "https://cms.megaphone.fm/api/networks/STUB_NETWORK_ID/podcasts/STUB_PODCAST_ID/episodes/STUB_EPISODE_ID"

    before :each do
      @megaphone = MegaphoneClient.new({ network_id: "STUB_NETWORK_ID" })
      @episode = @megaphone.episode
    end

    it "should return a an MegaphoneClient::ConnectionError if no podcast_id or episode_id is given" do
      expect { @megaphone.episode.update }.to raise_error(MegaphoneClient::ConnectionError)
    end

    it "should pass options[:body] as the body of the request" do
      VCR.use_cassette("update_result_01") do
        @megaphone.episode.update({
          podcast_id: "STUB_PODCAST_ID",
          episode_id: "STUB_EPISODE_ID",
          body: {
            preCount: 1,
            postCount: 2,
            insertionPoints: ["10.1", "15.23", "18"]
          }
        })

        expect(WebMock).to have_requested(:put, request_uri)
          .with(body: "{\"preCount\":1,\"postCount\":2,\"insertionPoints\":[\"10.1\",\"15.23\",\"18\"]}")
      end
    end

    it "should pass an empty body if not given in options" do
      VCR.use_cassette("update_result_02") do
        @megaphone.episode.update({
          podcast_id: "STUB_PODCAST_ID",
          episode_id: "STUB_EPISODE_ID"
        })

        expect(WebMock).to have_requested(:put, request_uri)
          .with(body: "{}")
      end
    end

    it "should only perform PUT requests" do
      VCR.use_cassette("update_result_01") do
        @megaphone.episode.update({
          podcast_id: "STUB_PODCAST_ID",
          episode_id: "STUB_EPISODE_ID"
        })

        expect(WebMock).not_to have_requested(:get, request_uri)
        expect(WebMock).not_to have_requested(:post, request_uri)
        expect(WebMock).not_to have_requested(:patch, request_uri)
        expect(WebMock).not_to have_requested(:delete, request_uri)
      end
    end
  end
end