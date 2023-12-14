module Gemini
  module HTTP
    def get(path:)
      to_json(conn.get(uri(path: path)) do |req|
        req.headers = headers
      end&.body)
    end

    def json_post(path:, parameters:)
      to_json(conn.post(uri(path: adjusted_path(path: path, parameters: parameters))) do |req|
        if parameters[:stream].is_a?(Proc)
          req.options.on_data = to_json_stream(user_proc: parameters[:stream])
        end

        req.headers = headers
        req.body = parameters.to_json
      end&.body)
    end

    def multipart_post(path:, parameters: nil)
      adjusted_path = adjusted_path(path: path, parameters: parameters)
      to_json(conn(multipart: true).post(uri(path: adjusted_path)) do |req|
        req.headers = headers.merge({ "Content-Type" => "multipart/form-data" })
        req.body = multipart_parameters(parameters)
      end&.body)
    end

    def delete(path:)
      to_json(conn.delete(uri(path: path)) do |req|
        req.headers = headers
      end&.body)
    end

    private

    def adjusted_path(path:, parameters:)
      prefix = "#{Gemini.configuration.api_version}beta/models/#{parameters[:model] || Gemini.configuration.default_model}:"
      api_suffix = URI.encode_www_form({
        key: Gemini.configuration.access_token
      })

      if parameters[:stream]
        path = "stream" + text.sub(/\A./) { |match| match.upcase }
      end

      "#{prefix}#{path}?#{api_suffix}"
    end

    def to_json(string)
      return unless string

      JSON.parse(string)
    rescue JSON::ParserError
      # Convert a multiline string of JSON objects to a JSON array.
      JSON.parse(string.gsub("}\n{", "},{").prepend("[").concat("]"))
    end

    # Given a proc, returns an outer proc that can be used to iterate over a JSON stream of chunks.
    # For each chunk, the inner user_proc is called giving it the JSON object. The JSON object could
    # be a data object or an error object as described in the Gemini API documentation.
    #
    # If the JSON object for a given data or error message is invalid, it is ignored.
    #
    # @param user_proc [Proc] The inner proc to call for each JSON object in the chunk.
    # @return [Proc] An outer proc that iterates over a raw stream, converting it to JSON.
    def to_json_stream(user_proc:)
      proc do |chunk, _|
        chunk.scan(/(?:data|error): (\{.*\})/i).flatten.each do |data|
          user_proc.call(JSON.parse(data))
        rescue JSON::ParserError
          # Ignore invalid JSON.
        end
      end
    end

    def conn(multipart: false)
      Faraday.new do |f|
        f.options[:timeout] = Gemini.configuration.request_timeout
        f.request(:multipart) if multipart
      end
    end

    def uri(path:)
      Gemini.configuration.uri_base + path
    end

    def headers
      {
        "Content-Type" => "application/json",
      }.merge(Gemini.configuration.extra_headers)
    end

    def multipart_parameters(parameters)
      parameters&.transform_values do |value|
        next value unless value.is_a?(File)

        # Doesn't seem like Gemini needs mime_type yet, so not worth
        # the library to figure this out. Hence the empty string
        # as the second argument.
        Faraday::UploadIO.new(value, "", value.path)
      end
    end
  end
end
