extends Node

signal inventory_updated

var items: Array = [null, null, null, null, null]

func add_item(item_id: String) -> void:
	if item_id not in items:
		for i in range(items.size()):
			if items[i] == null:
				items[i] = item_id
				inventory_updated.emit()
				return
				
func get_first_free_slot() -> int:
	for i in range(items.size()):
		if items[i] == null:
			return i + 1
	return 0
		
		
func add_item_index(item_id: String, slot_index: int) -> void:
	items[slot_index - 1] = item_id
	inventory_updated.emit()

func remove_item(item_id: String) -> void:
	for i in range(items.size()):
		if items[i] == item_id:
			items[i] = null
	inventory_updated.emit()

func has_item(item_id: String) -> bool:
	return item_id in items
	
func is_slot_free(slot_index: int) -> bool:
	if items[slot_index - 1] == null:
		return 1
	return 0
	
func _input(event: InputEvent):
	if event.is_action_pressed("2"):
		for i in range(items.size()):
			print(items[i])
			
func get_item_index(item_id: String) -> int:
	for i in range(items.size()):
		if items[i] == item_id:
			return i
	printerr("item not found")
	return 10

func replace_item(item_id: String, new_slot_index: int) -> void:
	var old_index = get_item_index(item_id)
	items[old_index] = null
	add_item_index(item_id, new_slot_index)
	
	
