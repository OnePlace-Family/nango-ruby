# Nango Ruby

## Installation

### Bundler

Add this line to your application's Gemfile:

```ruby
gem "nango-ruby"
```

And then execute:

```bash
$ bundle install
```

### Gem install

Or install with:

```bash
$ gem install nango-ruby
```

and require with:

```ruby
require "nango"
```

## Usage

### Quickstart

For a quick test you can pass your token directly to a new client:

```ruby
client = Nango::Client.new(
  access_token: "access_token_goes_here",
  log_errors: true # Highly recommended in development, so you can see what errors Nango is returning. Not recommended in production because it could leak private data to your logs.
)
```

### With Config

For a more robust setup, you can configure the gem with your API keys, for example in an `nango.rb` initializer file. Never hardcode secrets into your codebase - instead use something like [dotenv](https://github.com/motdotla/dotenv) to pass the keys safely into your environments.

```ruby
Nango.configure do |config|
  config.access_token = ENV.fetch("NANGO_ACCESS_TOKEN")
  config.log_errors = true # Highly recommended in development, so you can see what errors Nango is returning. Not recommended in production because it could leak private data to your logs.
end
```

Then you can create a client like this:

```ruby
client = Nango::Client.new
```

You can still override the config defaults when making new clients; any options not included will fall back to any global config set with Nango.configure. e.g. in this example the organization_id, request_timeout, etc. will fallback to any set globally using Nango.configure, with only the access_token overridden:

```ruby
client = Nango::Client.new(access_token: "access_token_goes_here")
```

#### Extra Headers per Client

You can dynamically pass headers per client object, which will be merged with any headers set globally with OpenAI.configure:

```ruby
client = Nango::Client.new(access_token: "access_token_goes_here")
client.add_headers("X-Proxy-TTL" => "43200")
```

#### Logging

##### Errors

By default, `nango-ruby` does not log any `Faraday::Error`s encountered while executing a network request to avoid leaking data (e.g. 400s, 500s, SSL errors and more - see [here](https://www.rubydoc.info/github/lostisland/faraday/Faraday/Error) for a complete list of subclasses of `Faraday::Error` and what can cause them).

If you would like to enable this functionality, you can set `log_errors` to `true` when configuring the client:

```ruby
client = Nango::Client.new(log_errors: true)
```

##### Faraday middleware

You can pass [Faraday middleware](https://lostisland.github.io/faraday/#/middleware/index) to the client in a block, eg. to enable verbose logging with Ruby's [Logger](https://ruby-doc.org/3.2.2/stdlibs/logger/Logger.html):

```ruby
client = Nango::Client.new do |f|
  f.response :logger, Logger.new($stdout), bodies: true
end
```
