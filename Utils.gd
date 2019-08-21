extends Node

const PASSWORD = "password"
const FILE_NAME = "user://KecoakAttack.bin"
const DEFAULT_GAME_DATA = {"best_score": 0}

# Scene switcher
var loader
var wait_frames
var time_max = 100 # msec
var current_scene
var loading_scene

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	
	var ls = ResourceLoader.load("res://scenes/Loading.tscn")
	loading_scene = ls.instance()
	
func goto_scene(path): # game requests to switch to this scene
	loader = ResourceLoader.load_interactive(path)
	if loader == null: # check for errors
		#show_error()
		return
	set_process(true)

	current_scene.queue_free() # get rid of the old scene

	get_node("/root").add_child(loading_scene)
	
	wait_frames = 1

func _process(delta):
	if loader == null:
        # no need to process anymore
		set_process(false)
		return

	if wait_frames > 0: # wait for frames to let the "loading" animation to show up
		wait_frames -= 1
		return

	var t = OS.get_ticks_msec()
	while OS.get_ticks_msec() < t + time_max: # use "time_max" to control how much time we block this thread
        # poll your loader
		var err = loader.poll()

		if err == ERR_FILE_EOF: # load finished
			var resource = loader.get_resource()
			loader = null
			set_new_scene(resource)
			break
		elif err == OK:
			update_progress()
		else: # error during loading
			#show_error()
			loader = null
			break

func update_progress():
	var progress = float(loader.get_stage()) / loader.get_stage_count()
	print(str("Loading ", progress))
    # update your progress bar?
    #get_node("progress").set_progress(progress)

    # or update a progress animation?
    #var len = get_node("animation").get_current_animation_length()

    # call this on a paused animation. use "true" as the second parameter to force the animation to update
    #get_node("animation").seek(progress * len, true)

func set_new_scene(scene_resource):
	# remove loading
	get_node("/root").remove_child(loading_scene)
	
	current_scene = scene_resource.instance()
	get_node("/root").add_child(current_scene)

# =========== Game data saver and loader ==========
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