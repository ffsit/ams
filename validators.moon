-- file to add custom input validators e.g. recaptcha validation
config = require("lapis.config").get!
tables = require "tables"

import validate_functions, assert_valid, validate from require "lapis.validate"
import from_json from require "lapis.util"

http = require "lapis.nginx.http"

validate_functions.recaptcha_verify = (response, remote_addr) ->
	body, status, headers = http.simple "https://www.google.com/recaptcha/api/siteverify", {
		secret: config.recaptcha_secret
		response: response
		remoteip: remote_addr
	}

	data = from_json body
	data.success, "ReCaptcha validation failed, please try again."

validate_functions.is_valid_email = (email) ->
	match = email\match "[A-Za-z0-9%.%%%+%-]+@[A-Za-z0-9%.%%%+%-]+%.%w%w%w?%w?"
	match, "The e-mail address provided is not a valid address."

validate_functions.username_available = (username) ->
	count = tables.Users\count "username LIKE ?", username
	count == 0, "An account with the specified username already exists."

validate_functions.email_available = (email) ->
	count = tables.Users\count "email LIKE ?", email
	count == 0, "An account with the specified email address already exists."

{ :validate_functions, :assert_valid, :validate }
