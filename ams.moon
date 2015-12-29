lapis = require "lapis"
tables = require "tables"
bcrypt = require "bcrypt"

class extends lapis.Application

	[index: "/"]: =>
		render: true

	[new_user: "/new_user"]: =>
		-- if we can spare more than 2^10 rounds for bcrypt that'd be better
		hash = bcrypt.digest @params.password, 10
		user = tables.Users\create {
			username: @params.username
			password_hash: hash
			email: @params.email
		}
		json: user
