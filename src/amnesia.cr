require "crypto/md5"
require "./amnesia/*"

# Amnesia
module Amnesia
  # Email address for use with temp-mail.
  # This provides a struct for a string with a name
  # and domain part, as well as converting the email
  # to an MD5 for use with the temp-mail API.
  struct EmailAddress
    # Name part of the address
    property name : String

    # Domain part of the address
    property domain : String

    # Build an address from a name and a domain
    def initialize(@name, @domain)
      raise "Domain unavailable: #{domain}" unless valid_domain?
    end

    # Build an address from a single string
    def initialize(string : String)
      data = string.split "@"
      @name = data[0]
      @domain = data[1]

      raise "Domain unavailable: #{domain}" unless valid_domain?
    end

    # Render the address to a single string
    def to_s : String
      "#{name}@#{domain}"
    end

    # Render the address to an MD5 string
    def to_md5 : String
      Crypto::MD5.hex_digest to_s
    end

    # TODO: Initiate a REST call to list available temp-mail domains.
    def self.domains : Array(String)
    end

    # TODO: Checks if this email has a valid domain
    def valid_domain? : Bool
      true
    end
  end

  # temp-mail client for managing an inbox.
  class Client
    # Email address this client should use
    getter email : EmailAddress

    # Cache of emails in this account
    getter inbox

    # Initialize a client with an EmailAddress object
    def initialize(@email)
    end

    # Initialize a client, building an EmailAddress
    def initialize(string : String)
      @email = EmailAddress.new string
    end

    # TODO: Initiate a REST call to fetch the current inbox
    def poll : Nil
    end
  end

  # TODO: A daemon class for managing a collection of temp-mail addresses
  class Daemon
  end
end
