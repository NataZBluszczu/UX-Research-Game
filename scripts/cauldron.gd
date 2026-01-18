extends Node2D

@onready var cauldron_sprite: Sprite2D = $CauldronSprite

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func pulse_animation():
	var tween = get_tree().create_tween()
	tween.tween_property(cauldron_sprite, "scale", Vector2(1.3, 1.3), 0.2)
	tween.tween_property(cauldron_sprite, "scale", Vector2(1, 1), 0.3)
	

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		var selected_item = GameManager.selected_item
		if selected_item and selected_item.name in GameManager.cauldron_items:
			GameManager.add_to_cauldron(selected_item.name)
			selected_item.queue_free()
			GameManager.selected_item = null
			pulse_animation()
			InventoryManager.remove_item(selected_item.name)
		elif selected_item and GameManager.selected_vial:
			GameManager.add_vial_to_cauldron(selected_item.name)
			pulse_animation()
			#ANIMACJA DLA VIAL 
