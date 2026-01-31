extends Node2D

var color = name
var draggable = false
var clickable = false
var is_inside_dropable = false
var body_ref
var offset: Vector2
var initialPos : Vector2
var is_selected = false
var above_cauldron = false
var drag_started_here = false 
var actually_dragged = false

func _ready() -> void:
	GameManager.vial_quest_finished.connect(_on_vial_quest_finished)

func _process(delta):
	if GameManager.input_locked:
		return
		
	if GameManager.is_drag_mode == true:
		if draggable:
			if Input.is_action_just_pressed("click"):
				drag_started_here = true 
				actually_dragged = false
				initialPos = global_position
				offset = get_global_mouse_position() - global_position
				global.is_dragging = true
				global.non_eq_dragging = true
				_on_drag_start()
				
			if Input.is_action_pressed("click") and drag_started_here: 
				global_position = get_global_mouse_position() - offset
				if global_position.distance_to(initialPos) > 1:
					actually_dragged = true
				
			elif Input.is_action_just_released("click"):
				global.is_dragging = false
				global.non_eq_dragging = false
				_on_drag_end()
				
				drag_started_here = false
				if actually_dragged:
					draggable = false
				actually_dragged = false
				
				var tween = get_tree().create_tween()
				if above_cauldron:
					if GameManager.is_cauldron_activated == true:
						GameManager.add_vial_to_cauldron(name)
				GameManager.input_locked = true
				tween.tween_property(self,"global_position",initialPos,0.2).set_ease(Tween.EASE_OUT)
				await tween.finished
				GameManager.input_locked = false
	else:
		if clickable:
			if Input.is_action_just_pressed("click"):
				toggle_selected()

func toggle_selected():
	if GameManager.selected_item == self:
		GameManager.selected_item = null
		GameManager.selected_vial = null
		is_selected = false
		scale = Vector2(1, 1)
	else:
		if GameManager.selected_item:
			GameManager.selected_item.is_selected = false
			GameManager.selected_item.scale = Vector2(1, 1)
			GameManager.selected_item.clickable = false
			 
		GameManager.selected_item = self
		GameManager.selected_vial = self
		is_selected = true
		scale = Vector2(1.2, 1.2)
		clickable = true

func _on_area_2d_body_entered(body:StaticBody2D) -> void:
	if body.is_in_group("usage"):
		if body.name == "CauldronBody":
			above_cauldron = true
			body_ref = body

func _on_area_2d_body_exited(body) -> void:
	above_cauldron = false

func _on_area_2d_mouse_entered() -> void:
	if GameManager.input_locked: 
		return
	if Input.is_action_pressed("click"): 
		return
	if not global.is_dragging:
		draggable = true
		clickable = true
		if not is_selected:
			scale = Vector2(1.05, 1.05)

func _on_area_2d_mouse_exited() -> void:
	if GameManager.input_locked:
		return
	
	if global.is_dragging:
		return
	
	if not is_selected:
		draggable = false
		clickable = false
		scale = Vector2(1,1)
	if is_selected:
		clickable = false
	
	drag_started_here = false  
		
func _on_vial_quest_finished():
	print("finished")
	
func _on_drag_start():
	z_index = 100 

func _on_drag_end():
	z_index = 0
	if not is_selected:
		scale = Vector2(1,1)
