class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def shopify_xml
    # Read the body once and rewind so Rails can still use it
    raw_body = request.body.read
    request.body.rewind

    # Filter headers to avoid circular references / Rails internals
    filtered_headers = request.headers.env.select do |k, _v|
      k.start_with?("HTTP_") || %w(CONTENT_TYPE CONTENT_LENGTH).include?(k)
    end

    # Combine headers + body into one JSON object
    data = {
      headers: filtered_headers,
      body: raw_body
    }

    # Write to file (overwrites each time, change 'w' to 'a' to append)
    File.open("api_xml.json", "w") do |f|
      f.write(JSON.pretty_generate(data))
    end

    head :ok
  end

  def shopify
      # Read the body once and rewind so Rails can still use it
      raw_body = request.body.read
      request.body.rewind

      # Filter headers to avoid circular references / Rails internals
      filtered_headers = request.headers.env.select do |k, _v|
        k.start_with?("HTTP_") || %w(CONTENT_TYPE CONTENT_LENGTH).include?(k)
      end

      # Try to parse the body as JSON, fallback to raw string
      parsed_body = begin
                      JSON.parse(raw_body)
                    rescue JSON::ParserError
                      raw_body
                    end

      # Combine headers + body into one JSON object
      data = {
        headers: filtered_headers,
        body: parsed_body
      }

      # Write to file (overwrites each time, change 'w' to 'a' to append)
      File.open("api.json", "w") do |f|
        f.write(JSON.pretty_generate(data))
      end

      head :ok
  end
end
