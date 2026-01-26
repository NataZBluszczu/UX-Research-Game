extends Node

var current_data = GameData.new()
var start_time: int
var last_mouse_pos: Vector2

func _ready():
	current_data.user_id = get_next_user_id()
	start_time = Time.get_ticks_msec()
	last_mouse_pos = get_viewport().get_mouse_position()
	
func _process(delta):
	var current_mouse_pos = get_viewport().get_mouse_position()
	var frame_dist = last_mouse_pos.distance_to(current_mouse_pos)
	
	if frame_dist > 0:
		current_data.total_mouse_dist += frame_dist      # Całkowity dystans
		current_data.total_mouse_move_time += delta       # Czas poruszania myszką
	
	if global.is_dragging:
		current_data.total_drag_time += delta             # Całkowity czas draggowania
		if frame_dist > 0:
			current_data.total_drag_dist += frame_dist    # Całkowity dystans draggowania
	
	last_mouse_pos = current_mouse_pos

func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			current_data.total_clicks += 1

func save_final_log():
	var end_time = Time.get_ticks_msec()
	var duration_ms = end_time - start_time
	var total_seconds = int(duration_ms / 1000)
	
	var minutes = total_seconds / 60
	var seconds = total_seconds % 60
	
	current_data.total_time_seconds = duration_ms / 1000.0
	current_data.total_time_in_minutes = str(minutes) + " min " + str(seconds) + " s"
	
	current_data.items_collected = GameManager.finish_items_collected
	
	var build_folder = OS.get_executable_path().get_base_dir()
	var file_name = "/log_P" + current_data.user_id + ".tres"
	var full_path = build_folder + file_name
	var file_path = "user://log_" + current_data.user_id + ".tres"
	var error = ResourceSaver.save(current_data, full_path)
	#var error = ResourceSaver.save(current_data, file_path)
	
	if error == OK:
		print("Log zapisany w folderze builda: ", full_path)
	else:
		print("Błąd zapisu w folderze builda, próbuję w user://")
		ResourceSaver.save(current_data, "user://" + file_name)



func get_next_user_id() -> String:
	var path = OS.get_executable_path().get_base_dir()
	var dir = DirAccess.open(path)
	var max_id = 0
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if file_name.begins_with("log_P") and file_name.ends_with(".tres"):
				var id_string = file_name.get_slice("P", 1).get_slice(".", 0)
				var id_num = int(id_string)
				if id_num > max_id:
					max_id = id_num
			file_name = dir.get_next()
	
	return "%02d" % (max_id + 1)
