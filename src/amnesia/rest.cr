require "http/client"
require "openssl/ssl/context"
require "./mappings.cr"

module Amnesia
  # REST bindings
  module REST
    extend self

    # SSL context
    SSL_CONTEXT = OpenSSL::SSL::Context::Client.new

    # temp-mail API base URL
    API_BASE = "https://api.temp-mail.org/request"

    # API format request - must be JSON to use mappings.cr
    FORMAT = "format/json"

    # Generic GET request handler
    def get(path : String) : String
      response = HTTP::Client.get "#{API_BASE}/#{path}/#{FORMAT}", tls: SSL_CONTEXT
      response.body
    end

    # Request the available domains from temp-mail
    def domains : Array(String)
      Array(String).from_json get "domains"
    end
  end
end
