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
      config.network_id = "{megaphone network id}"
      config.organization_id = "{megaphone organization id}"
  end
```

### Searching

```ruby
Megaphone::Episode.search({ externalId: obj_key })
```

### Updating

Note: the properties in `body` are written in camelCase because it's expected by the Megaphone API

```ruby
  Megaphone::Episode.update({
    podcast_id: "{podcast id}",
    episode_id: "{episode id}",
    body: {
      preCount: 1,
      postCount: 2,
      insertionPoints: ["10.1, "15.23", "18"]
    }
  })
```

### Listing Podcasts

```ruby
Megaphone::Podcast.list
```

### Creating

**(TO:DO)**
```ruby
Megaphone::Episode.create(attributes)
```

## Contributing

Pull Requests are encouraged!
