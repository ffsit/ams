-- simplyfied commands to send mail through the SMTP server configured in config.moon
-- utilizes sendmail lua module available through luarocks
config = require("lapis.config").get!
tables = require "tables"
sendmail = require "sendmail"

import build_url, encode_query_string from require "lapis.util"

send_email = (recipient, subject, text, html) ->
	sendmail.send {
		from: {
			title: "AMS"
			address: config.email.user .. "@" .. config.email.hostname
		}
		to: recipient
		server: {
			address: config.email.host
			user: config.email.user
			password: config.email.password
			ssl: config.email.use_ssl
		}
		message: {
			subject: subject
			text: text
			html: html
		}
	}

-- takes the result from a create or search query with an email verifications entry
send_verification_email = (ev) =>
	url = build_url {
		path: "new_user"
		host: @req.parsed_url.host
		scheme: @req.parsed_url.scheme
		port: if @req.parsed_url.port == 80 then nil else @req.parsed_url.port
		query: encode_query_string {
			email: ev.email
			evid: ev.evid
			verify: ev.hash
		}
	}

-- annoyingly multiline strings don't take indentation into account.
-- probably will end up pulling any messages displayed to users out into some
-- sort of string table or database, so I guess it's only a temporary headache.
	message = "Hello

You recently requested to create a new account using this e-mail address.
Use the following link to complete registraiton:

" .. url .. "

If you did not request to create an user account you may ignore this e-mail.

Best Regards"

	send_email ev.email, "Verify your E-Mail address", message

{ :send_email, :send_verification_email }
