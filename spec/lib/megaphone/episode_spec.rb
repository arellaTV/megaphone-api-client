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
    end
  end

  describe "Megaphone.default_headers" do
    it "should apply a token from configuration" do
      @megaphone = MegaphoneClient.new({ token: "STUB_TOKEN" })
      expect(@megaphone.default_headers[:authorization]).to include "STUB_TOKEN"
    end
  end

  describe "Megaphone.search" do
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
      VCR.use_cassette("search_result_01") do
        @episode.search
        expect(WebMock).to have_requested(:get, "https://cms.megaphone.fm/api/search/episodes?organizationId=STUB_ORGANIZATION_ID")
        expect(WebMock).not_to have_requested(:put, "https://cms.megaphone.fm/api/search/episodes?organizationId=STUB_ORGANIZATION_ID")
        expect(WebMock).not_to have_requested(:post, "https://cms.megaphone.fm/api/search/episodes?organizationId=STUB_ORGANIZATION_ID")
        expect(WebMock).not_to have_requested(:patch, "https://cms.megaphone.fm/api/search/episodes?organizationId=STUB_ORGANIZATION_ID")
        expect(WebMock).not_to have_requested(:delete, "https://cms.megaphone.fm/api/search/episodes?organizationId=STUB_ORGANIZATION_ID")
      end
    end
  end

  describe "Megaphone.update" do
    REQUEST_URI = "https://cms.megaphone.fm/api/networks/STUB_NETWORK_ID/podcasts/STUB_PODCAST_ID/episodes/STUB_EPISODE_ID"

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

        expect(WebMock).to have_requested(:put, REQUEST_URI)
          .with(body: "{\"preCount\":1,\"postCount\":2,\"insertionPoints\":[\"10.1\",\"15.23\",\"18\"]}")
      end
    end

    it "should pass an empty body if not given in options" do
      VCR.use_cassette("update_result_02") do
        @megaphone.episode.update({
          podcast_id: "STUB_PODCAST_ID",
          episode_id: "STUB_EPISODE_ID"
        })

        expect(WebMock).to have_requested(:put, REQUEST_URI)
          .with(body: "{}")
      end
    end

    it "should only perform PUT requests" do
      VCR.use_cassette("update_result_01") do
        @megaphone.episode.update({
          podcast_id: "STUB_PODCAST_ID",
          episode_id: "STUB_EPISODE_ID"
        })

        expect(WebMock).not_to have_requested(:get, REQUEST_URI)
        expect(WebMock).not_to have_requested(:post, REQUEST_URI)
        expect(WebMock).not_to have_requested(:patch, REQUEST_URI)
        expect(WebMock).not_to have_requested(:delete, REQUEST_URI)
      end
    end
  end

  describe "Megaphone.connection" do
    before :each do
      @megaphone = MegaphoneClient.new
    end

    it "should add params to request_headers if they exist" do
      VCR.use_cassette("connection_result_01") do
        @megaphone.connection({
          url: "https://cms.megaphone.fm/api/search/episodes",
          method: :get,
          params: {
            published: true
          }
        })
        expect(WebMock).to have_requested(:get, "https://cms.megaphone.fm/api/search/episodes?published=true").once
      end

    end
  end
end