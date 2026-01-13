extends Node2D

var original_position: Vector2
var is_lamp_selected = false
var is_lamp_at_top = false
var is_animating = false  

@onready var uv: Sprite2D = $"../Uv"

func _ready() -> void:
	original_position = global_position
	uv.visible = false

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if is_animating:
			return  
		
		if is_lamp_selected and is_lamp_at_top:
			hide_uv_immediately()
			return_lamp_to_original()
		elif not is_lamp_selected and not is_lamp_at_top:
			if is_mouse_over_lamp(get_global_mouse_position()):
				move_lamp_to_top()

func is_mouse_over_lamp(mouse_pos: Vector2) -> bool:
	return global_position.distance_to(mouse_pos) < 60

func move_lamp_to_top():
	if is_animating:
		return
	is_animating = true
	
	is_lamp_selected = true
	is_lamp_at_top = true
	
	var viewport_size = get_viewport().get_visible_rect().size
	var top_position = Vector2(viewport_size.x / 2, 0)
	
	var tween = create_tween()
	tween.tween_property(self, "global_position", top_position, 0.5).set_ease(Tween.EASE_OUT)
	tween.tween_callback(func():
		uv.visible = true  
		is_animating = false
	)

func return_lamp_to_original():
	if is_animating:
		return
	is_animating = true
	
	is_lamp_selected = false
	is_lamp_at_top = false
	
	var tween = create_tween()
	tween.tween_property(self, "global_position", original_position, 0.5).set_ease(Tween.EASE_IN)
	tween.tween_callback(func():
		uv.visible = false  
		is_animating = false
	)

func hide_uv_immediately():
	uv.visible = false

func _on_area_2d_mouse_entered() -> void:
	if not is_lamp_selected:
		scale = Vector2(1.05, 1.05)  

func _on_area_2d_mouse_exited() -> void:
	if not is_lamp_selected:
		scale = Vector2(1, 1)

func _on_lamp_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if is_animating:
			return  
		
		if is_lamp_selected:
			hide_uv_immediately()
			return_lamp_to_original()
		else:
			move_lamp_to_top()
