
import create_table, types from require "lapis.db.schema"

{
	-- table index is a unix timestamp, to keep track of table layout versions
	[1451397695]: =>
		create_table "users", {
			{ "uuid", types.serial primary_key: true }
			{ "username", types.varchar unique: true }
			{ "password_hash", types.varchar }
			{ "email", types.varchar unique: true }
		}

	[1451397696]: =>
		create_table "groups", {
			{ "gid", types.serial primary_key: true }
			{ "groupname", types.varchar unique: true }
			{ "permissions", types.integer } -- stored as a bitfield for now
		}
		
	[1451397697]: =>
		create_table "user_group_pairs", {
			{ "uuid", types.foreign_key }
			{ "gid", types.foreign_key }
			"PRIMARY KEY(uuid, gid)" -- pairwise primary key
		}
		
	[1451397698]: =>
		create_table "profile_data", {
			{ "uuid", types.foreign_key primary_key: true }
			{ "gender", types.enum default: 0 }
			{ "minecraft", types.varchar default: "" }
			{ "steam", types.varchar default: "" }
			{ "xbox", types.varchar default: "" }
			{ "psn", types.varchar default: "" }
			{ "wiiu", types.varchar default: "" }
			{ "twitter", types.varchar default: "" }
			{ "google", types.varchar default: "" }
			{ "youtube", types.varchar default: "" }
		}
		
	[1451397699]: =>
		create_table "sessions", {
			{ "sid", types.serial primary_key: true }
			{ "uuid", types.foreign_key }
			{ "hash", types.varchar }
			{ "timestamp", types.time }
		}
		
	[1451509633]: =>
		create_table "email_verifications", {
			{ "evid", types.serial primary_key: true }
			{ "email", types.varchar }
			{ "hash", types.varchar }
			{ "timestamp", types.time }
		}
}
