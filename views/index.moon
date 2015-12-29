
import Widget from require "lapis.html"

class extends Widget
	content: =>
			link rel: "stylesheet", href: "/static/style.css"
			
			h1 "Hello World"
			p "If you found this, please go away."
