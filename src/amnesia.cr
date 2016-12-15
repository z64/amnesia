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
    getter name : String

    # Domain part of the address
    getter domain : String

    # MD5 of the email address
    getter md5 : String

    # Build an address from a name and a domain
    def initialize(@name, @domain)
      @md5 = to_md5
      raise "Domain unavailable: #{domain}" unless valid_domain?
    end

    # Build an address from a single string
    def initialize(string : String)
      data = string.split "@"
      @name = data[0]
      @domain = "@#{data[1]}"
      @md5 = to_md5

      raise "Domain unavailable: #{domain}" unless valid_domain?
    end

    # Render the address to a single string
    def to_s : String
      "#{name}#{domain}"
    end

    # Render the address to an MD5 string
    def to_md5 : String
      Crypto::MD5.hex_digest to_s
    end

    # Initiate a REST call to list available temp-mail domains.
    def self.domains : Array(String)
      Amnesia::REST.domains
    end

    # Checks if this email has a valid domain
    def valid_domain? : Bool
      Amnesia::REST.domains.includes? @domain
    end

    # Requests this email addresses inbox
    def inbox : Array(Email)
      Amnesia::REST.inbox @md5
    end
  end

  # temp-mail client for managing an inbox.
  class Client
    # Email address this client should use
    getter email : EmailAddress

    # Cache of emails in this account
    getter inbox : Hash(String, Email)

    # Initialize a client with an EmailAddress object
    def initialize(@email : EmailAddress)
      @inbox = {} of String => Email
    end

    # Initialize a client, building an EmailAddress
    def initialize(string : String)
      @email = EmailAddress.new string
      @inbox = {} of String => Email
    end

    # Overload inspect for easier to read output
    def inspect : String
      "<Amnesia::Client @email=#{email.inspect} @inbox=#{inbox.map { |_, e| e.inspect}}>"
    end

    # Initiate a REST call to fetch the
    # current inbox and update the cache
    def poll! : Nil
      @email.inbox.each { |e| @inbox[e.id] = e }
      nil
    end

    # Overload to accept a block to process newly
    # cached emails as the user likes.
    def poll!(&block) : Nil
      @email.inbox.each do |e|
        yield e unless @inbox.has_key? e.id
        @inbox[e.id] = e
      end
      nil
    end
  end

  # TODO: A daemon class for managing a collection of temp-mail addresses
  class Daemon
  end
end
