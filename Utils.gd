extends Node

const PASSWORD = "password"
const FILE_NAME = "user://KecoakAttack.bin"
const DEFAULT_GAME_DATA = {"best_score": 0}

func save_game_data(data):
	print(str("Persisting game data: ", data))
	
	var file = File.new()
	file.open_encrypted_with_pass(FILE_NAME, File.WRITE, PASSWORD)
	file.store_string(to_json(data))
	file.close()

func load_game_data():
	var file = File.new()
	file.open_encrypted_with_pass(FILE_NAME, File.READ, PASSWORD)
	var data = parse_json(file.get_as_text())
	print(str("Loading game data: ", data))
	if data == null:
		return DEFAULT_GAME_DATA
	return data