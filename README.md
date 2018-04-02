# Megaphone Client
Unofficial Ruby client for the Megaphone API

## Installation
    gem 'megaphone_client', github:"scpr/megaphone_client"

## Usage
### Configuration
Configure your app to connect to Megaphone, either in an initializer or your environment files:

```ruby
  @megaphone = MegaphoneClient.new({
    token: "{megaphone api token}",
    network_id: "{megaphone network id}",
    organization_id: "{megaphone organization id}"
  })
```

### Searching

```ruby
@megaphone.episode.search({ externalId: obj_key })
```

### Updating

Note: the properties in `body` are written in camelCase because it's expected by the Megaphone API

```ruby
  @megaphone.episode.update({
    podcast_id: "{podcast id}",
    episode_id: "{episode id}",
    body: {
      preCount: 1,
      postCount: 2,
      insertionPoints: ["10.1", "15.23", "18"]
    }
  })
```

### Listing Podcasts

```ruby
@megaphone.podcast.list
```

### Creating

**(TO:DO)**
```ruby
Megaphone::Episode.create(attributes)
```

## Contributing

Pull Requests are encouraged!
