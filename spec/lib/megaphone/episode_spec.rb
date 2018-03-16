require 'megaphone_client'
require 'megaphone'
require 'ostruct'
require 'spec_helper'
require 'webmock/rspec'

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
    before :each do
      stub_request(:get, "https://cms.megaphone.fm/api/search/episodes?organizationId=STUB_ORGANIZATION_ID")
        .with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip, deflate', 'Authorization'=>'Token token=STUB_TOKEN', 'Content-Length'=>'4', 'Content-Type'=>'application/json', 'Host'=>'cms.megaphone.fm', 'User-Agent'=>'rest-client/2.0.1 (darwin16.4.0 x86_64) ruby/2.1.0p0'})
        .to_return(:status => 200, :body => FIXTURES[:search_result], :headers => {})

      stub_request(:get, "https://cms.megaphone.fm/api/search/episodes?organizationId=STUB_ORGANIZATION_FROM_OPTIONS")
        .with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip, deflate', 'Authorization'=>'Token token=STUB_TOKEN', 'Content-Length'=>'4', 'Content-Type'=>'application/json', 'Host'=>'cms.megaphone.fm', 'User-Agent'=>'rest-client/2.0.1 (darwin16.4.0 x86_64) ruby/2.1.0p0'})
        .to_return(:status => 200, :body => FIXTURES[:search_result], :headers => {})
    end

    it "should merge in the configuration organization_id if none is given in options" do
      expected_struct = load_fixture("search_result.json")
      response = Megaphone::Episode.search
      expect(WebMock).to have_requested(:get, "https://cms.megaphone.fm/api/search/episodes?organizationId=STUB_ORGANIZATION_ID").once
      expect(response).to eq expected_struct
    end

    it "should stick to the organizationId if given in options" do
      expected_struct = load_fixture("search_result.json")
      response = Megaphone::Episode.search({ organizationId: "STUB_ORGANIZATION_FROM_OPTIONS" })
      expect(WebMock).to have_requested(:get, "https://cms.megaphone.fm/api/search/episodes?organizationId=STUB_ORGANIZATION_FROM_OPTIONS").once
      expect(WebMock).not_to have_requested(:get, "https://cms.megaphone.fm/api/search/episodes?organizationId=STUB_ORGANIZATION_ID")
      expect(response).to eq expected_struct
    end

    it "should only perform GET requests" do
      Megaphone::Episode.search
      expect(WebMock).to have_requested(:get, "https://cms.megaphone.fm/api/search/episodes?organizationId=STUB_ORGANIZATION_ID")
      expect(WebMock).not_to have_requested(:put, "https://cms.megaphone.fm/api/search/episodes?organizationId=STUB_ORGANIZATION_ID")
      expect(WebMock).not_to have_requested(:post, "https://cms.megaphone.fm/api/search/episodes?organizationId=STUB_ORGANIZATION_ID")
      expect(WebMock).not_to have_requested(:patch, "https://cms.megaphone.fm/api/search/episodes?organizationId=STUB_ORGANIZATION_ID")
      expect(WebMock).not_to have_requested(:delete, "https://cms.megaphone.fm/api/search/episodes?organizationId=STUB_ORGANIZATION_ID")
    end
  end

  describe "Megaphone.update" do
    before :each do
      MegaphoneClient.setup do |config|
        config.token = "STUB_TOKEN"
        config.network_id = "STUB_NETWORK_ID"
        config.organization_id = "STUB_ORGANIZATION_ID"
      end

      stub_request(:put, "https://cms.megaphone.fm/api/networks/STUB_NETWORK_ID/podcasts/STUB_PODCAST_ID/episodes/STUB_EPISODE_ID")
        .with(:body => "{}", :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip, deflate', 'Authorization'=>'Token token=STUB_TOKEN', 'Content-Length'=>'2', 'Content-Type'=>'application/json', 'Host'=>'cms.megaphone.fm', 'Params'=>'', 'User-Agent'=>'rest-client/2.0.1 (darwin16.4.0 x86_64) ruby/2.1.0p0'})
        .to_return(:status => 200, :body => FIXTURES[:episode], :headers => {})

      stub_request(:put, "https://cms.megaphone.fm/api/networks/STUB_NETWORK_ID/podcasts/STUB_PODCAST_ID/episodes/STUB_EPISODE_ID")
        .with(:body => "{\"preCount\":1,\"postCount\":2,\"insertionPoints\":[\"10.1\",\"15.23\",\"18\"]}", :headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip, deflate', 'Authorization'=>'Token token=STUB_TOKEN', 'Content-Length'=>'68', 'Content-Type'=>'application/json', 'Host'=>'cms.megaphone.fm', 'Params'=>'', 'User-Agent'=>'rest-client/2.0.1 (darwin16.4.0 x86_64) ruby/2.1.0p0'})
        .to_return(:status => 200, :body => FIXTURES[:episode], :headers => {})
    end

    it "should return a an Error OpenStruct if no podcast_id or episode_id is given" do
      expected_struct = load_fixture("error.json")
      response = Megaphone::Episode.update
      expect(response).to eq expected_struct
    end

    it "should pass options[:body] as the body of the request" do
      response = Megaphone::Episode.update({
        podcast_id: "STUB_PODCAST_ID",
        episode_id: "STUB_EPISODE_ID",
        body: {
          preCount: 1,
          postCount: 2,
          insertionPoints: ["10.1", "15.23", "18"]
        }
      })

      expect(WebMock).to have_requested(:put, "https://cms.megaphone.fm/api/networks/STUB_NETWORK_ID/podcasts/STUB_PODCAST_ID/episodes/STUB_EPISODE_ID")
        .with(body: "{\"preCount\":1,\"postCount\":2,\"insertionPoints\":[\"10.1\",\"15.23\",\"18\"]}")
    end

    it "should pass an empty body if not given in options" do
      Megaphone::Episode.update({
        podcast_id: "STUB_PODCAST_ID",
        episode_id: "STUB_EPISODE_ID"
      })

      expect(WebMock).to have_requested(:put, "https://cms.megaphone.fm/api/networks/STUB_NETWORK_ID/podcasts/STUB_PODCAST_ID/episodes/STUB_EPISODE_ID")
        .with(body: {})
    end

    it "should only perform PUT requests" do
      Megaphone::Episode.update({
        podcast_id: "STUB_PODCAST_ID",
        episode_id: "STUB_EPISODE_ID"
      })

      expect(WebMock).not_to have_requested(:get, "https://cms.megaphone.fm/api/search/episodes?organizationId=STUB_ORGANIZATION_ID")
      expect(WebMock).not_to have_requested(:post, "https://cms.megaphone.fm/api/search/episodes?organizationId=STUB_ORGANIZATION_ID")
      expect(WebMock).not_to have_requested(:patch, "https://cms.megaphone.fm/api/search/episodes?organizationId=STUB_ORGANIZATION_ID")
      expect(WebMock).not_to have_requested(:delete, "https://cms.megaphone.fm/api/search/episodes?organizationId=STUB_ORGANIZATION_ID")
    end
  end

  describe "Megaphone.connection" do
    before :each do
      MegaphoneClient.setup do |config|
        config.token = "STUB_TOKEN"
        config.network_id = "STUB_NETWORK_ID"
        config.organization_id = "STUB_ORGANIZATION_ID"
      end

      stub_request(:get, "https://cms.megaphone.fm/api/search/episodes?published=true")
        .with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip, deflate', 'Authorization'=>'Token token=STUB_TOKEN', 'Content-Length'=>'4', 'Content-Type'=>'application/json', 'Host'=>'cms.megaphone.fm', 'User-Agent'=>'rest-client/2.0.1 (darwin16.4.0 x86_64) ruby/2.1.0p0'})
        .to_return(:status => 200, :body => FIXTURES[:search_result], :headers => {})
    end

    it "should add params to request_headers if they exist" do
      Megaphone::Episode.connection({
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