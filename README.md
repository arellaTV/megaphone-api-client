# Megaphone API Client
Ruby client for the Megaphone API

## Installation
    gem 'megaphone-api-client', github:"scpr/megaphone-api-client"

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

### Finding

`Megaphone::Episode.find(obj_key)`

### Creating

**(TO:DO)**
`Megaphone::Episode.create(attributes)`


## Contributing

Pull Requests are encouraged!
