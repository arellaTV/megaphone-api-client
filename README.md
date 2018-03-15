# Megaphone Client
Ruby client for the Megaphone API

## Installation
    gem 'megaphone-api-client', github:"scpr/megaphone_client"

## Usage
### Configuration
Configure your app to connect to Megaphone, either in an initializer or your environment files:

```ruby
  MegaphoneClient.setup do |config|
      config.token = "{megaphone api token}"
      config.network = "{megaphone network id}"
      config.organization = "{megaphone organization id}"
  end
```

### Searching

`Megaphone::Episode.search({ externalId: obj_key })`

### Updating

`Megaphone::Episode.update({
  podcast_id: "{podcast id}",
  episode_id: "{episode id}",
  body: {
    preCount: 1,
    postCount: 2,
    insertionPoints: ["10.1, "15.23", "18"]
  }
})`

### Listing Podcasts

`Megaphone::Podcast.list`

### Creating

**(TO:DO)**
`Megaphone::Episode.create(attributes)`


## Contributing

Pull Requests are encouraged!
