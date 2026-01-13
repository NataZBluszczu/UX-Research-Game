extends Node

var selected_item = null
var is_drag_mode = false  

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_Q:
			is_drag_mode = !is_drag_mode
			print("Tryb: ", "Drag-Drop" if is_drag_mode else "Point-Click")

func _process(delta: float) -> void:
	if is_drag_mode:
		selected_item = null
		
#zagadka z kotłem
var cauldron_items = ["Ball", "Board", "Dreamcatcher"]
var collected_items = []
var all_items_added = false

signal spawn_amulet

func add_to_cauldron(item_name: String):
	if item_name in cauldron_items and item_name not in collected_items:
		collected_items.append(item_name)
		if collected_items.size() == 3:
			spawn_amulet.emit()
			
		
	
