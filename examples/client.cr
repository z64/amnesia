require "../src/amnesia"

if ARGV.empty?
  puts "Usage:"
  puts " amnesia -d                       List available domains"
  puts " amnesia email@domain [interval]  Bind to an email and poll it at interval"
  exit
end

if ARGV[0] == "-d"
  puts Amnesia::EmailAddress.domains.join "\n"
  exit
end

begin
  client = Amnesia::Client.new ARGV[0]
rescue e
  puts "Could not bind client! #{e}"
  exit
end

poll_interval = ARGV[1]? || 5

puts "Press CTRL+C to terminate."

loop do
  client.poll! do |e|
    puts "from: #{e.from}"
    puts "subject: #{e.subject}"
    puts "timestamp: #{e.timestamp}"
    puts "body: #{e.text}"
  end
end
