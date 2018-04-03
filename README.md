# Megaphone Client
Unofficial Ruby client for the Megaphone API

## Installation
```bash
gem 'megaphone_client', github:"scpr/megaphone_client"
```

## Usage
**Note:** Megaphone API props, such as `externalId`, is in camelCase instead of snake_case because Megaphone's API expects it when accessing their API. So when passing params or putting/posting a hash, use camelCase. When interfacing with the gem's API, use snake_case.

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

**Note:** the property `externalId` is written in camelCase because it's expected by the Megaphone API

```ruby
@megaphone.episode.search({ externalId: obj_key })
```

### Updating

**Note:** the properties in `body` are written in camelCase because it's expected by the Megaphone API

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
@megaphone.episode.create(attributes)
```

## Tests

To run the tests:
```bash
$ bundle exec rspec spec
```

## Contributing

Pull Requests are encouraged!
