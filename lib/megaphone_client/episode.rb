require "ostruct"
require "json"
require "rest-client"

module MegaphoneClient

  # @author Jay Arella
  class Episode
    class << self

      # @return a MegaphoneClient
      # @note This is used as a way to access top level attributes
      # @example Accessing a network id
      #   config.network_id #=> '{network id specified in initialization}'

      def config
        @config ||= MegaphoneClient
      end

      # @return a struct that represents the episode that was created
      # @note If a :podcast_id, :title, and :pubdate aren't given, it raises an error.
      # @see MegaphoneClient#connection
      # @example Create an episode
      #   megaphone.episode.update({
      #     podcast_id: '12345',
      #     episode_id: '56789',
      #     body: { preCount: 2 }
      #   })
      #   #=> A struct representing episode '56789' with preCount 2

      def create options={}
        if !options[:podcast_id] || !options[:body] || !options[:body][:title] || !options[:body][:pubdate]
          raise MegaphoneClient::ConnectionError.new("podcast_id, body.title, and body.pubdate options are required.")
        end

        MegaphoneClient.connection({
          :url => "#{config.api_base_url}/networks/#{config.network_id}/podcasts/#{options[:podcast_id]}/episodes",
          :method => :post,
          :body => options[:body] || {}
        })
      end

      # @return a struct (or array of structs) that represents the search results by episode
      # @note If an organizationId wasn't given in options and there is an organization_id in config,
      #   it merges the organization_id from config into the params object that will be passed into MegaphoneClient#connection
      # @see MegaphoneClient#connection
      # @example Search for an episode with externalId 'show_episode-12345'
      #   megaphone.episode.search({
      #     externalId: 'show_episode-1245'
      #   })
      #   #=> A struct representing 'show_episode-12345'

      def search params={}
        # If an organizationId wasn't given in params and there is an organization_id in config
        if !params[:organizationId] && config.organization_id
          # Merge the organization_id from config into the params object
          params.merge!({ organizationId: config.organization_id })
        end

        MegaphoneClient.connection({
          :url => "#{config.api_base_url}/search/episodes",
          :method => :get,
          :params => params
        })
      end

      # @return a struct that represents the episode that was updated
      # @note If neither a :podcast_id and :episode_id are given, it raises an error
      # @see MegaphoneClient#connection
      # @example Update an episode's preCount
      #   megaphone.episode.update({
      #     podcast_id: '12345',
      #     episode_id: '56789',
      #     body: { preCount: 2 }
      #   })
      #   #=> A struct representing episode '56789' with preCount 2

      def update options={}
        if !options[:podcast_id] || !options[:episode_id]
          raise MegaphoneClient::ConnectionError.new("Both podcast_id and episode_id options are required.")
        end

        MegaphoneClient.connection({
          :url => "#{config.api_base_url}/networks/#{config.network_id}/podcasts/#{options[:podcast_id]}/episodes/#{options[:episode_id]}",
          :method => :put,
          :body => options[:body] || {}
        })
      end
    end
  end
end
