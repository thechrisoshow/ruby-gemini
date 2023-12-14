require "faraday"
require "faraday/multipart"

require_relative "gemini/http"
require_relative "gemini/client"
require_relative "gemini/version"

module Gemini
  class Error < StandardError; end
  class ConfigurationError < Error; end

  class Configuration
    attr_writer :access_token
    attr_accessor :api_version, :extra_headers, :organization_id,
                  :request_timeout, :uri_base, :default_model

    DEFAULT_API_VERSION = "v1".freeze
    DEFAULT_URI_BASE = "https://generativelanguage.googleapis.com/".freeze
    DEFAULT_REQUEST_TIMEOUT = 120
    DEFAULT_MODEL = "gemini-pro".freeze

    def initialize
      @access_token = nil
      @api_version = DEFAULT_API_VERSION
      @organization_id = nil
      @uri_base = DEFAULT_URI_BASE
      @request_timeout = DEFAULT_REQUEST_TIMEOUT
      @default_model = DEFAULT_MODEL
    end

    def access_token
      return @access_token if @access_token

      error_text = "Gemini access token missing! See https://github.com/thechrisoshow/gemini#usage"
      raise ConfigurationError, error_text
    end
  end

  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Gemini::Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
