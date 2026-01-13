extends Node2D

var original_position: Vector2
var is_lamp_selected = false
var is_lamp_away_from_home = false  

@onready var uv: Sprite2D = $Uv

func _ready() -> void:
	original_position = global_position
	uv.visible = false

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if is_lamp_selected:
			var mouse_pos = get_global_mouse_position()
			if not is_mouse_over_lamp(mouse_pos):
				move_uv_to_position(mouse_pos)

func is_mouse_over_lamp(mouse_pos: Vector2) -> bool:
	var distance = global_position.distance_to(mouse_pos)
	return distance < 60 

func _process(delta: float) -> void:
	pass

func _on_area_2d_mouse_entered() -> void:
	scale = Vector2(1.05, 1.05)

func _on_area_2d_mouse_exited() -> void:
	if not is_lamp_selected:
		scale = Vector2(1, 1)

func _on_lamp_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if is_lamp_selected:
			return_to_original()
		else:
			select_lamp()

func select_lamp():
	is_lamp_selected = true
	modulate = Color(1.2, 1.2, 1.0)  
	
	if not is_lamp_away_from_home:
		uv.visible = true

func move_uv_to_position(target_pos: Vector2):
	is_lamp_away_from_home = true
	var correct_pos = target_pos + Vector2(0, -300)
	if not uv.visible:
		uv.visible = true
	
	var tween = create_tween()
	tween.tween_property(self, "global_position", correct_pos, 0.3).set_ease(Tween.EASE_OUT)
	

func return_to_original():
	is_lamp_selected = false
	is_lamp_away_from_home = false
	
	modulate = Color(1.0, 1.0, 1.0)
	scale = Vector2(1, 1)
	
	var tween = create_tween()
	tween.tween_property(self, "global_position", original_position, 0.4).set_ease(Tween.EASE_IN)
	
	tween.tween_callback(func():
		uv.visible = false
	)
