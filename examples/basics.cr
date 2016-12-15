require "../src/amnesia"

# Print a list of available domains
puts Amnesia::EmailAddress.domains

# Bind an email address. This will perform a GET request
# to validate the domain is valid at the time of creation.
address = Amnesia::EmailAddress.new "bob@maileme101.com"
puts address.inspect

# Fetch this address' inbox.
emails = address.inbox
puts "bob has #{emails.size} emails."
puts emails.map { |e| e.inspect }.join "\n"

# Delete an email (uncomment this prodiding the account actually has emails)
# puts emails.first.delete
# puts address.inbox.size

# EmailAddress provides an interface to the basic REST
# binding. For cache functionality, use Amnesia::Client
# which has such functionality:
client = Amnesia::Client.new address
# You can also pass a string, like "bob@maileme101.com"
# like above with Amnesia::EmailAddress.

# Update the Client's inbox
# You can (optionally) pass a block to #poll! that
# will be called each time a *new* email is added to the cache.
client.poll! do |e|
  puts "new email! From #{e.from}: #{e.subject}"
end
