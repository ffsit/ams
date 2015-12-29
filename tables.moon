
import Model from require "lapis.db.model"

class Users extends Model
	@primary_key: "uuid"
	@constraints: {
		username: (value) =>
			if value\len! < 2
				"Username needs to be at least two characters long."

		email: (value) =>
			if not value\match "[A-Za-z0-9%.%%%+%-]+@[A-Za-z0-9%.%%%+%-]+%.%w%w%w?%w?"
				"The e-mail address provided is not a valid address."

	}

class Groups extends Model
	@primary_key: "gid"

class UserGroupPairs extends Model
	@primary_key: {"uuid", "gid"}
	@relations: {
		{"uuid", belongs_to: "Users"}
		{"gid", belongs_to: "Groups"}
	}

{
	:Users, :Groups, :UserGroupPairs
}
