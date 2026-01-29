extends Node

# DATABASE
var database: SQLite
var is_connected: bool = false

# PLAYER
var player_id: int = -1
var player: CharacterBody2D = null
var can_move: bool = true

func _ready() -> void:
	connect_db()		# Establish connection with database
	initialize_data()	# Checks if all tables are existing


# UTILITY FUNCTIONS
func connect_db():
	database = SQLite.new()				# Creates an instance
	database.path="res://data.db"		# Locates the db, creates if not found
	is_connected = database.open_db()	# Opens the db and captures response

func initialize_data():
	var result: Array[Dictionary]
	
	# CHECK IF tbl_account EXIST
	database.query("SELECT COUNT(*) as count FROM sqlite_master WHERE TYPE='table' AND NAME='tbl_account'")
	result = database.query_result
	
	if result[0]["count"] <= 0: # Create table if not exist
		var tbl_account: Dictionary = {
			"id": {
				"data_type": "int",
				"primary_key": true,
				"not_null": true,
				"auto_increment": true
			},
			"username": {
				"data_type": "text",
				"not_null": true,
			},
			"password": {
				"data_type": "text",
				"not_null": true,
			},
			"type": {
				"data_type": "text",
				"not_null": true,
				"default": "student"
			}
		}
		
		database.create_table("tbl_account", tbl_account) # Creates the table
	
	# CHECK IF tbl_scores EXIST
	database.query("SELECT COUNT(*) as count FROM sqlite_master WHERE TYPE='table' AND NAME='tbl_scores'")
	result = database.query_result
	
	if result[0]["count"] <= 0: # Create table if not exist
		var tbl_scores: Dictionary = {
			"id": {
				"data_type": "int",
				"primary_key": true,
				"not_null": true,
				"auto_increment": true
			},
			"username": {
				"data_type": "text",
				"not_null": true,
			},
			"score": {
				"data_type": "int",
				"not_null": true,
			},
			"created_at": {
				"data_type": "datetime",
				"default": "CURRENT_TIMESTAMP"
			}
		}
		
		database.create_table("tbl_scores", tbl_scores) # Creates the table
	
	# CHECK IF tbl_choices EXIST
	database.query("SELECT COUNT(*) as count FROM sqlite_master WHERE TYPE='table' AND NAME='tbl_choice'")
	result = database.query_result
	
	if result[0]["count"] <= 0: # Create table if not exist
		var tbl_choices: Dictionary = {
			"id": {
				"data_type": "int",
				"primary_key": true,
				"not_null": true,
				"auto_increment": true
			},
			"question": {
				"data_type": "text",
				"not_null": true,
			},
			"choices": {
				"data_type": "text",
				"not_null": true,
			},
			"answer": {
				"data_type": "text",
				"not_null": true,
			}
		}
		
		database.create_table("tbl_choices", tbl_choices) # Creates the table
	
	# CHECK IF tbl_identify EXIST
	database.query("SELECT COUNT(*) as count FROM sqlite_master WHERE TYPE='table' AND NAME='tbl_identify'")
	result = database.query_result
	
	if result[0]["count"] <= 0: # Create table if not exist
		var tbl_identify: Dictionary = {
			"id": {
				"data_type": "int",
				"primary_key": true,
				"not_null": true,
				"auto_increment": true
			},
			"question": {
				"data_type": "text",
				"not_null": true,
			},
			"answer": {
				"data_type": "text",
				"not_null": true,
			}
		}
		
		database.create_table("tbl_identify", tbl_identify) # Creates the table
	
	# CHECK IF tbl_bool EXIST
	database.query("SELECT COUNT(*) as count FROM sqlite_master WHERE TYPE='table' AND NAME='tbl_bool'")
	result = database.query_result
	
	if result[0]["count"] <= 0: # Create table if not exist
		var tbl_bool: Dictionary = {
			"id": {
				"data_type": "int",
				"primary_key": true,
				"not_null": true,
				"auto_increment": true
			},
			"question": {
				"data_type": "text",
				"not_null": true,
			},
			"answer": {
				"data_type": "text",
				"not_null": true,
			}
		}
		
		database.create_table("tbl_bool", tbl_bool) # Creates the table
	
	# CHECK IF tbl_enum EXIST
	database.query("SELECT COUNT(*) as count FROM sqlite_master WHERE TYPE='table' AND NAME='tbl_enum'")
	result = database.query_result
	
	if result[0]["count"] <= 0: # Create table if not exist
		var tbl_enum: Dictionary = {
			"id": {
				"data_type": "int",
				"primary_key": true,
				"not_null": true,
				"auto_increment": true
			},
			"question": {
				"data_type": "text",
				"not_null": true,
			},
			"answer": {
				"data_type": "text",
				"not_null": true,
			}
		}
		
		database.create_table("tbl_enum", tbl_enum) # Creates the table

func add_player(username: String, password: String) -> bool:
	var condition: String
	var data: Dictionary = {
		"username": username,
		"password": password
	}
	
	# Username must be unique
	condition = "username = '" + username + "'"
	var userResult = database.select_rows("tbl_account", condition, ["username"])
	
	if userResult.size() >= 1:
		return false # Usernames must be unique!
	
	var result: bool = database.insert_row("tbl_account", data) # Inserts into the table
	
	return result

func find_player(username: String, password: String, type: String = "student") -> bool:	
	var condition = "username = '" + username + "' AND password = '" + password + "' AND type = " + type + "'"
	var result: Array = database.select_rows("tbl_account", condition, ["*"])
	
	if result.size() <= 0:
		# Notify player of failed attempt
		return false
	
	# Assign player with player id
	for row in result:
		player_id = row["id"]

	return true

func hash_password(password: String) -> String:
	const SECRET_KEY: String = "Chano" # Acts like a salt
	
	var combined_key: String = password + SECRET_KEY # Combine the password and secret key (salt)
	var hashed_buffer: PackedByteArray = combined_key.sha256_buffer() # Hash the key with SHA-256
	var hashed_key: String = hashed_buffer.hex_encode() # Encode into hex for storage
	
	return hashed_key

func announce_status(text: String):
	player.add_status_label(text)
