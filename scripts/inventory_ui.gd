extends Control

@onready var grid: GridContainer = $Panel/GridContainer
@onready var inventory_items: Node2D = $"../InventoryItems"
var is_updating = false

var ITEM_SCENES := {
	"Ball": preload("res://prefabs/Ball.tscn"),
	"Board": preload("res://prefabs/Board.tscn"),
	"Dreamcatcher": preload("res://prefabs/Dreamcatcher.tscn"),
	"Amulet": preload("res://prefabs/Amulet.tscn"),
	"Matches": preload("res://prefabs/Matches.tscn"),
	"YellowGem": preload("res://prefabs/YellowGem.tscn"),
	"PurpleGem": preload("res://prefabs/PurpleGem.tscn"),
	"OrangeGem": preload("res://prefabs/OrangeGem.tscn"),
	"GreenGem": preload("res://prefabs/GreenGem.tscn"),
}


func _ready():
	InventoryManager.inventory_updated.connect(_update_slots)
	_update_slots()

func _update_slots():
	if is_updating:
		return
	is_updating = true
	for item in inventory_items.get_children():
		item.queue_free()
	await get_tree().process_frame
	
	var i := 0
	for slot in grid.get_children():
		var icon_container = slot.get_node("Item")
		
		var item_id = InventoryManager.items[i]
		if item_id != null and ITEM_SCENES.has(item_id):
			var item_scene: PackedScene = ITEM_SCENES[item_id]
			var item_instance = item_scene.instantiate()
			item_instance.name = item_id
			var icon_global = icon_container.get_global_position()
			inventory_items.add_child(item_instance)
			item_instance.position = icon_global
			item_instance.name = item_id
		
		i += 1
	is_updating = false
