module Gemini
  class Client
    extend Gemini::HTTP

    def initialize(access_token: nil, organization_id: nil, uri_base: nil, request_timeout: nil,
                   extra_headers: {})
      Gemini.configuration.access_token = access_token if access_token
      Gemini.configuration.organization_id = organization_id if organization_id
      Gemini.configuration.uri_base = uri_base if uri_base
      Gemini.configuration.request_timeout = request_timeout if request_timeout
      Gemini.configuration.extra_headers = extra_headers
    end

    def generate_content(parameters: {})
      Gemini::Client.json_post(path: "generateContent", parameters: parameters)
    end
  end
end
