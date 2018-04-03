# require 'megaphone_client'
# require 'megaphone'
# require 'ostruct'
# require 'spec_helper'
# require 'webmock/rspec'
#
# describe Megaphone::Podcast do
#   describe "Megaphone.config" do
#     it "should equal MegaphoneClient if MegaphoneClient is set up" do
#       MegaphoneClient.setup do |config|
#         config.token = "STUB_TOKEN"
#         config.network_id = "STUB_NETWORK_ID"
#         config.organization_id = "STUB_ORGANIZATION_ID"
#       end
#
#       expect(Megaphone::Podcast.config.token).to eq "STUB_TOKEN"
#       expect(Megaphone::Podcast.config.network_id).to eq "STUB_NETWORK_ID"
#       expect(Megaphone::Podcast.config.organization_id).to eq "STUB_ORGANIZATION_ID"
#     end
#   end
#
#   describe "Megaphone.default_headers" do
#     it "should apply a token from configuration" do
#       MegaphoneClient.setup do |config|
#         config.token = "STUB_TOKEN"
#       end
#
#       expect(Megaphone::Podcast.default_headers[:authorization]).to include "STUB_TOKEN"
#     end
#   end
# end