
config = require("lapis.config").get!

import Widget from require "lapis.html"

class extends Widget
	content: =>
			link rel: "stylesheet", href: "/static/style.css"
			
			h1 "Create New User"
			form method: "POST", action: @url_for("new_user"), ->
				input type: "hidden", name: "csrf_token", value: @csrf_token
				input type: "hidden", name: "evid", value: @params.evid
				input type: "hidden", name: "verify", value: @params.verify
				input type: "hidden", name: "email", value: @params.email

				label for: "username", "Username"
				input type: "text", name: "username"
				raw "<br>"
				
				label for: "email", "E-Mail address"
				input type: "text", name: "email-show", value: @params.email, disabled: "true"
				raw "<br>"
				
				label for: "password", "Password"
				input type: "password", name: "password"
				raw "<br>"
				
				label for: "password_repeat", "Password repeat"
				input type: "password", name: "password_repeat"
				raw "<br>"

				input type: "submit"
