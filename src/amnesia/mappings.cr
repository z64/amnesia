require "json"

module Amnesia
  # Converter for temp-mail's timestamp format
  # I have no idea why they did this.
  module FloatMillisConverter
    def self.from_json(value : JSON::PullParser) : Time
      t = value.read_float * 1000
      Time.epoch_ms(t.to_i64)
    end

    def self.to_json(value : Time, io : IO)
      io.puts(value.epoch_ms.to_f / 1000)
    end
  end

  # Email object from temp-mail
  class Email
    JSON.mapping({
      id: { type: String, key: "mail_id" },
      address_id: { type: String, key: "mail_address_id" },
      from: { type: String, key: "mail_from" },
      subject: { type: String, key: "mail_subject" },
      preview: { type: String, key: "mail_preview" },
      text_only: { type: String, key: "mail_text_only" },
      text: { type: String, key: "mail_text" },
      html: { type: String, nilable: true, key: "mail_html" },
      timestamp: { type: Time, key: "mail_timestamp", converter: FloatMillisConverter }
    }, strict: false)

    # Overload inspect for easier to read output
    def inspect : String
      "<Amnesia::Email @id=#{id} @from=\"#{from}\" @subject=\"#{subject}\">"
    end

    # Makes a request to delete an email
    def delete : String
      REST.delete id
    end
  end
end
