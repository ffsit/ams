
lapis = require "lapis"
csrf = require "lapis.csrf"
tables = require "tables"
bcrypt = require "bcrypt"

import capture_errors_json, respond_to from require "lapis.application"
import validate_functions, assert_valid, validate from require "validators"
import to_json from require "lapis.util"
import send_verification_email from require "email"

class extends lapis.Application

	[index: "/"]: =>
		render: true

	[request_account: "/request_account"]: respond_to {
		GET: =>
			@csrf_token = csrf.generate_token @
			render: true

		POST: capture_errors_json =>
			csrf.assert_token @
			assert_valid @params, {
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

			ev = tables.EmailVerifications\create {
				email: @params.email
				hash: "stub" --add something actually sensible here
			}

			ok, err = send_verification_email @, ev

			if ok
				@html ->
					link rel: "stylesheet", href: "/static/style.css"

					h1 "Success"
					p "We've sent you an e-mail containing a link to complete registration."
			else
				@write err, status: 500

	}

	[new_user: "/new_user"]: respond_to {
		before: =>
			errors = validate @params, {
				{
					"email"
					exists: true
					is_valid_email: @params.email
					email_available: @params.email
				}
				{
					"evid"
					exists: true
				}
				{
					"verify"
					exists: true
				}
			}
			@write "Invalid or expired registration session, please restart", status: 500 if errors
			@email = @params.email
			@hash = @params.verify

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
