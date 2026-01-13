extends Control

@onready var grid: GridContainer = $Panel/GridContainer

var ITEM_SCENES := {
	"Ball": preload("res://prefabs/Ball.tscn"),
	"Board": preload("res://prefabs/Board.tscn"),
	"Dreamcatcher": preload("res://prefabs/Dreamcatcher.tscn"),
	"Amulet": preload("res://prefabs/Amulet.tscn")
}

func _ready():
	InventoryManager.inventory_updated.connect(_update_slots)
	_update_slots()

func _update_slots():
	var i := 0
	for slot in grid.get_children():
		var icon_container = slot.get_node("Item")
		
		for child in icon_container.get_children():
			child.queue_free()
		
		# 2. sprawdź co siedzi w logice
		var item_id = InventoryManager.items[i]
		if item_id != null and ITEM_SCENES.has(item_id):
			var item_scene: PackedScene = ITEM_SCENES[item_id]
			var item_instance = item_scene.instantiate()
			item_instance.position = Vector2.ZERO
			icon_container.add_child(item_instance)
		
		i += 1
