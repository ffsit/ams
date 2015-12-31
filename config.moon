
import config from require "lapis.config"

config "production", ->
	num_workers 4
	code_cache "on"
	port 80
	postgres ->
		host "127.0.0.1"
		user "lapis"
		password "thisisnotsecureatallbutwhocares"
		database "lapis"
	email ->
		host "127.0.0.1"
		hostname ""
		user "lapis"
		password "thisisnotsecureatalleither"
		use_ssl true
	secret "itsasecret"
	recaptcha_sitekey ""
	recaptcha_secret ""

config "development", ->
	num_workers 1
	code_cache "off"
	port 8080
	postgres ->
		host "127.0.0.1"
		user "lapis"
		password "thisisnotsecureatallbutwhocares"
		database "lapis"
	email ->
		host "127.0.0.1"
		hostname ""
		user "lapis"
		password "thisisnotsecureatalleither"
		use_ssl true
	secret "itsasecret"
	recaptcha_sitekey ""
	recaptcha_secret ""
