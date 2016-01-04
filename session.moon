-- Utility functions to create and verify session and email verification hashes
-- uses bcrypt with fewer rounds for now, should think about something better
config = require("lapis.config").get!
bcrypt = require "bcrypt"
tables = require "tables"

import encode_base64, decode_base64 from require "lapis.util.encoding"

--strips blowfish method and salt from hash, we don't want them to leak outside
strip_blowfish = (hash) ->
	s, e = hash\find "%$%w+%$%d+%$"
	-- this will cut off the first four bytes of the actual hash, but since
	-- we use this only for verification purposes, it should be totally fine
	salt_end = e + 23
	unless s
		nil, "Invalid blowfish hash provided."
	else
		hash\sub salt_end

email_secret = (ev) ->
	config.secret .. ev.evid .. ev.created_at

create_email_hash = (ev) ->
	ev.hash = bcrypt.digest email_secret(ev), 4
	ev\update "hash"
	strip_blowfish ev.hash

verify_email_hash = (ev, hash) ->
	expected = strip_blowfish ev.hash
	if expected and expected == hash
		bcrypt.verify email_secret(ev), ev.hash
	else
		nil, "Invalid verification hash provided."

{ :create_email_hash, :verify_email_hash }
