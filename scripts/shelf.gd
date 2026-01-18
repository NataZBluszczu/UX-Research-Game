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
		if selected_item and GameManager.correct_finish_item(selected_item.name, self.name.right(1)):
			selected_item.queue_free()
			GameManager.selected_item = null
			InventoryManager.remove_item(selected_item.name)
