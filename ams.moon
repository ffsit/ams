
lapis = require "lapis"
csrf = require "lapis.csrf"
tables = require "tables"
bcrypt = require "bcrypt"

import capture_errors_json, respond_to from require "lapis.application"
import validate_functions, assert_valid from require "validators"
import to_json from require "lapis.util"

class extends lapis.Application

	[index: "/"]: =>
		render: true

	[new_user: "/new_user"]: respond_to {
		GET: =>
			@csrf_token = csrf.generate_token @
			render: true

		POST: capture_errors_json =>
			csrf.assert_token @
			assert_valid @params, {
				{
					"username"
					exists: true
					min_length: 2
					username_available: @params.username
				}
				{ "password", exists: true, min_length: 8 }
				{ "password_repeat", equals: @params.password }
				{
					"email"
					exists: true
					is_valid_email: @params.email
					email_available: @params.email
				}
				{
					"g-recaptcha-response"
					exists: true
					recaptcha_verify: {
						@params["g-recaptcha-response"]
						@req.remote_addr
					}
				}
			}
			-- if we can spare more than 2^10 rounds for bcrypt that'd be better
			hash = bcrypt.digest @params.password, 10
			user = tables.Users\create {
				username: @params.username
				password_hash: hash
				email: @params.email
			}
			json: user
	}
