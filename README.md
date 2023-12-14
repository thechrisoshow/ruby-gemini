# Gemini

Use the [Gemini API](https://ai.google.dev/docs) with Ruby!

You can apply for access to the API [here](https://ai.google.dev/tutorials/setup).

### Bundler

Add this line to your application's Gemfile:

```ruby
gem "gemini"
```

And then execute:

$ bundle install

### Gem install

Or install with:

$ gem install gemini

and require with:

```ruby
require "gemini"
```

## Usage

- Get your API key from [https://makersuite.google.com/](https://ai.google.dev/tutorials/setup)

### Quickstart

For a quick test you can pass your token directly to a new client:

```ruby
client = Gemini::Client.new(access_token: "access_token_goes_here")
```

### With Config

For a more robust setup, you can configure the gem with your API keys, for example in an `gemini.rb` initializer file. Never hardcode secrets into your codebase - instead use something like [dotenv](https://github.com/motdotla/dotenv) to pass the keys safely into your environments.

```ruby
Gemini.configure do |config|
    config.access_token = ENV.fetch("GEMINI_API_KEY")
end
```

Then you can create a client like this:

```ruby
client = Gemini::Client.new
```

#### Change version or timeout


The default timeout for any request using this library is 120 seconds. You can change that by passing a number of seconds to the `request_timeout` when initializing the client.

```ruby
client = Gemini::Client.new(
    access_token: "access_token_goes_here",
    request_timeout: 240 # Optional
)
```

You can also set these keys when configuring the gem:

```ruby
Gemini.configure do |config|
    config.access_token = ENV.fetch("GEMINI_API_KEY")
    config.gemini_version = "2023-01-01" # Optional
    config.request_timeout = 240 # Optional
end
```

### Text content

Hit the Gemini API for text content:

```ruby
response = client.generate_content(
    parameters: {
        model: "gemini-pro",
        prompt: "How high is the sky?"
    })
puts response["content"]
# => " The sky has no definitive"
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. You can run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

### Warning

If you have an `GEMINI_API_KEY` in your `ENV`, running the specs will use this to run the specs against the actual API, which will be slow and cost you money - 2 cents or more! Remove it from your environment with `unset` or similar if you just want to run the specs against the stored VCR responses.

## Release

First run the specs without VCR so they actually hit the API. This will cost 2 cents or more. Set GEMINI_API_KEY in your environment or pass it in like this:

```
GEMINI_API_KEY=123abc bundle exec rspec
```

Then update the version number in `version.rb`, update `CHANGELOG.md`, run `bundle install` to update Gemfile.lock, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/thechrisoshow/gemini>. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/thechrisoshow/gemini/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Ruby Gemini project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/thechrisoshow/gemini/blob/main/CODE_OF_CONDUCT.md).
