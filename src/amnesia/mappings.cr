require "json"

module Amnesia
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
      timestamp: { type: Float32, key: "mail_timestamp" }
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
