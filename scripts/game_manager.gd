extends Node

var input_locked := false

var selected_item = null
var selected_vial = null
var is_drag_mode = false  

func _on_anim_finished() -> void:
	input_locked = false

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
			print(selected_item)

func _process(delta: float) -> void:
	if is_drag_mode:
		selected_item = null
		
#zagadka z kotłem
var cauldron_items = ["Ball", "Board", "Dreamcatcher"]
var finish_items = ["Ball", "Board", "Dreamcatcher", "Amulet"]
var finish_items_collected = ["","","",""]
var collected_items = []
var all_items_added = false

var added_vials = []
var pattern = ["Red","Red","Green","Green","Blue","Blue","Blue"]

signal spawn_amulet
signal vial_quest_finished
signal finish_quest_finished
signal finish_item_added(item_name: String, shelf_nr: String)

func add_to_cauldron(item_name: String):
	if item_name in cauldron_items and item_name not in collected_items:
		collected_items.append(item_name)
		if collected_items.size() == 3:
			spawn_amulet.emit()
			
func add_vial_to_cauldron(color: String):
	added_vials.append(color)
	if ends_with_pattern(added_vials, pattern):
		vial_quest_finished.emit()
		spawn_amulet.emit()
		print("TRAFIONY WZÓR!")

func ends_with_pattern(seq: Array, pat: Array) -> bool:
	if seq.size() < pat.size():
		return false
	for i in pat.size():
		if seq[seq.size() - pat.size() + i] != pat[i]:
			return false
	return true
	
func correct_finish_item(item_name: String, shelf_nr: String) -> bool:
	if item_name in finish_items and item_name not in finish_items_collected:
		var shelf_int = int(shelf_nr)
		if finish_items_collected[shelf_int - 1] == "":
			finish_items_collected[shelf_int - 1] = item_name
			finish_item_added.emit(item_name, shelf_nr)
		else:
			return false
		if not "" in finish_items_collected:
			finish_quest_finished.emit()
		return true
	else:
		return false
		
		
var candles_lighten = [0,0,0]
var light_quest_finished = false
signal lighted_candle(candle_nr: String)

func correct_light_item(item_name: String, candle_nr: String) -> bool:
	if item_name == "Matches":
		var candle_int = int(candle_nr)
		if candles_lighten[candle_int - 1] == 0:
			candles_lighten[candle_int - 1] = 1
			lighted_candle.emit(candle_nr)
			if not 0 in candles_lighten:
				light_quest_finished = true
				InventoryManager.remove_item(item_name)
				return false
			return true
		else:
			return true
	return true
		
signal gem_is_placed(color: String)
signal all_gems_placed
var gems_found = []
func gem_placed(gem_color: String) -> bool:
	if gem_color not in gems_found:
		gems_found.append(gem_color)
		gem_is_placed.emit(gem_color)
		InventoryManager.remove_item(gem_color + "Gem")
		if gems_found.size() == 4:
			all_gems_placed.emit()
		return true
	else:
		return false
	

#spider
signal fly_added
signal wrong_flies
signal right_flies
var flies_added = []
var flies_pattern = ["4","5","1","2","3"]

func check_fly(fly_nr: String):
	flies_added.append(fly_nr)
	if flies_added.size() < 5:
		fly_added.emit()
	if flies_added.size() == 5:
		if flies_added == flies_pattern:
			right_flies.emit()
		else:
			wrong_flies.emit()
			flies_added = []
