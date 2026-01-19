extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		var selected_item = GameManager.selected_item
		if selected_item and selected_item.name == "Matches":
			GameManager.correct_light_item(selected_item.name, self.name.right(1))
			if GameManager.light_quest_finished:
				selected_item.queue_free()
				GameManager.selected_item = null
				InventoryManager.remove_item(selected_item.name)

func _on_gems_place_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		var selected_item = GameManager.selected_item
		if selected_item:
			if selected_item.name == "GreenGem" or selected_item.name == "OrangeGem" or selected_item.name == "PurpleGem" or selected_item.name == "YellowGem":
				var gem_color = selected_item.name.left(-3)
				if GameManager.gem_placed(gem_color):
					selected_item.queue_free()
					GameManager.selected_item = null
					InventoryManager.remove_item(selected_item.name)
