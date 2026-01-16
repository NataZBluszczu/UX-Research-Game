extends Node2D

var draggable = false
var clickable = false
var is_inside_dropable = false
var body_ref
var offset: Vector2
var initialPos : Vector2
var is_selected = false

var above_cauldron = false

func _process(delta):
	if GameManager.is_drag_mode == true:
		if draggable:
			if Input.is_action_just_pressed("click"):
				initialPos = global_position
				offset = get_global_mouse_position() - global_position
				global.is_dragging = true
			if Input.is_action_pressed("click"):
				global_position = get_global_mouse_position() - offset
			elif Input.is_action_just_released("click"):
				global.is_dragging = false
				var tween = get_tree().create_tween()
				if is_inside_dropable:
					var slot_index = body_ref.get_slot_index()
					if InventoryManager.is_slot_free(slot_index):
						if InventoryManager.has_item(name):
							tween.tween_property(self,"position",body_ref.global_position,0.2).set_ease(Tween.EASE_OUT)
							await tween.finished
							InventoryManager.replace_item(name, slot_index)
						else:
							tween.tween_property(self,"position",body_ref.global_position,0.2).set_ease(Tween.EASE_OUT)
							await tween.finished
							InventoryManager.add_item_index(name, slot_index)
							queue_free()
					else:
						tween.tween_property(self,"global_position",initialPos,0.2).set_ease(Tween.EASE_OUT)
				else:
					tween.tween_property(self,"global_position",initialPos,0.2).set_ease(Tween.EASE_OUT)
				if above_cauldron:
					if InventoryManager.has_item(name):
						GameManager.add_to_cauldron(name)
						body_ref.get_parent().pulse_animation()
						InventoryManager.remove_item(name)
						queue_free()
					else:
						tween.tween_property(self,"global_position",initialPos,0.2).set_ease(Tween.EASE_OUT)
	else:
		if clickable:
			if Input.is_action_just_pressed("click"):
				if InventoryManager.has_item(name):
					toggle_selected()
				else:
					var slot_index = InventoryManager.get_first_free_slot()
					var slot_name = "InventorySlot" + str(slot_index)
					var slot = get_tree().get_root().find_child(slot_name, true, false)
					var tween = get_tree().create_tween()
					tween.tween_property(self,"global_position",slot.global_position,0.2).set_ease(Tween.EASE_OUT)
					await tween.finished
					InventoryManager.add_item(name)
					queue_free()
	
func toggle_selected():
	if InventoryManager.has_item(name):
		if GameManager.selected_item == self:  # kliknięto na zaznaczony
			GameManager.selected_item = null
			is_selected = false
			scale = Vector2(1, 1)
		else:  # zaznacz nowy
			# odznacz poprzedni
			if GameManager.selected_item:
				GameManager.selected_item.is_selected = false
				GameManager.selected_item.scale = Vector2(1, 1)
				GameManager.selected_item.clickable = false
				 
			GameManager.selected_item = self
			is_selected = true
			scale = Vector2(1.2, 1.2)
			clickable = true

func _on_area_2d_body_entered(body:StaticBody2D) -> void:
	if body.is_in_group("usage"):
		if body.name == "CauldronBody":
			above_cauldron = true
			body_ref = body
	if body.is_in_group('dropable'):
		is_inside_dropable = true
		body.modulate = Color(Color.REBECCA_PURPLE, 1)
		body_ref = body

func _on_area_2d_body_exited(body) -> void:
	above_cauldron = false
	if body.is_in_group('dropable') and body_ref == body:
		is_inside_dropable = false
		body.modulate = Color(Color.MEDIUM_PURPLE, 0.7)

func _on_area_2d_mouse_entered() -> void:
	if not global.is_dragging:
		draggable = true
		clickable = true
		if not is_selected:
			scale = Vector2(1.05, 1.05)

func _on_area_2d_mouse_exited() -> void:
	if not global.is_dragging and not is_selected:
		draggable = false
		clickable = false
		scale = Vector2(1,1)
	if is_selected:
		clickable = false
