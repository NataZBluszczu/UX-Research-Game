extends Node

var selected_item = null
var selected_vial = null
var is_drag_mode = false  

func _ready() -> void:
	DisplayServer.window_set_size(Vector2i(1280,720))
	var centre_screen = DisplayServer.screen_get_position() + DisplayServer.screen_get_size()/2
	var window_size = get_window().get_size_with_decorations()
	get_window().set_position(centre_screen - window_size/2)

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_Q:
			is_drag_mode = !is_drag_mode
			print("Tryb: ", "Drag-Drop" if is_drag_mode else "Point-Click")
		if event.is_action_pressed("2"):
			print(added_vials)

func _process(delta: float) -> void:
	if is_drag_mode:
		selected_item = null
		
#zagadka z kotłem
var cauldron_items = ["Ball", "Board", "Dreamcatcher"]
var collected_items = []
var all_items_added = false

var added_vials = []
var pattern = ["Blue","Blue","Blue","Purple","Purple"]

signal spawn_amulet
signal vial_quest_finished

func add_to_cauldron(item_name: String):
	if item_name in cauldron_items and item_name not in collected_items:
		collected_items.append(item_name)
		if collected_items.size() == 3:
			spawn_amulet.emit()
			
func add_vial_to_cauldron(color: String):
	added_vials.append(color)
	if ends_with_pattern(added_vials, pattern):
		vial_quest_finished.emit()
		print("TRAFIONY WZÓR!")

func ends_with_pattern(seq: Array, pat: Array) -> bool:
	if seq.size() < pat.size():
		return false
	for i in pat.size():
		if seq[seq.size() - pat.size() + i] != pat[i]:
			return false
	return true
