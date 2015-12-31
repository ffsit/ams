
config = require("lapis.config").get!

import Widget from require "lapis.html"

class extends Widget
	content: =>
			link rel: "stylesheet", href: "/static/style.css"
			script src: "https://www.google.com/recaptcha/api.js"
			
			h1 "Request Account"
			form method: "POST", action: @url_for("request_account"), ->
				input type: "hidden", name: "csrf_token", value: @csrf_token
				
				label for: "email", "E-Mail address"
				input type: "text", name: "email"
				raw "<br>"

				input type: "submit"

				div class: "g-recaptcha", ["data-sitekey"]: config.recaptcha_sitekey
