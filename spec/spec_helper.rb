require "bundler/setup"
require "dotenv/load"
require "gemini"
require "gemini/compatibility"
require "vcr"

Dir[File.expand_path("spec/support/**/*.rb")].sort.each { |f| require f }

VCR.configure do |c|
  c.hook_into :webmock
  c.cassette_library_dir = "spec/fixtures/cassettes"
  c.default_cassette_options = {
    record: ENV.fetch("GEMINI_API_KEY", nil) ? :all : :new_episodes,
    match_requests_on: [:method, :uri, VCRMultipartMatcher.new]
  }
  c.filter_sensitive_data("<GEMINI_API_KEY>") { Gemini.configuration.access_token }
end

RSpec.configure do |c|
  # Enable flags like --only-failures and --next-failure
  c.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  c.disable_monkey_patching!

  c.expect_with :rspec do |rspec|
    rspec.syntax = :expect
  end

  if ENV.fetch("GEMINI_API_KEY", nil)
    warning = "WARNING! Specs are hitting the Gemini API using your GEMINI_API_KEY! This
costs at least 2 cents per run and is very slow! If you don't want this, unset
GEMINI_API_KEY to just run against the stored VCR responses.".freeze
    warning = RSpec::Core::Formatters::ConsoleCodes.wrap(warning, :bold_red)

    c.before(:suite) { RSpec.configuration.reporter.message(warning) }
    c.after(:suite) { RSpec.configuration.reporter.message(warning) }
  end

  c.before(:all) do
    Gemini.configure do |config|
      config.access_token = ENV.fetch("GEMINI_API_KEY", "dummy-token")
    end
  end
end

RSPEC_ROOT = File.dirname __FILE__
