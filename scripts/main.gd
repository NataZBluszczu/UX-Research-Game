extends Node2D

@onready var transition_rect: ColorRect = $TransitionLayer/ColorRect

var rooms: Array[Node2D] = []
var current_index := 0
var is_transitioning := false 

func _ready() -> void:
	transition_rect.color = Color.BLACK
	transition_rect.modulate.a = 0
	
	rooms = [ $Room1, $Room2, $Room3 ]
	_update_rooms_visibility()

func change_room(next_index: int) -> void:
	if is_transitioning: return
	is_transitioning = true

	var tween = create_tween()
	tween.tween_property(transition_rect, "modulate:a", 1.0, 0.3) 
	
	await tween.finished
	
	current_index = next_index
	_update_rooms_visibility()
	
	var tween_back = create_tween()
	tween_back.tween_property(transition_rect, "modulate:a", 0.0, 0.3)
	
	await tween_back.finished
	is_transitioning = false

func _update_rooms_visibility() -> void:
	for i in rooms.size():
		var is_current = (i == current_index)
		rooms[i].visible = is_current
		rooms[i].process_mode = Node.PROCESS_MODE_DISABLED if not is_current else Node.PROCESS_MODE_INHERIT

func _go_left() -> void:
	var next = current_index - 1
	if next < 0: next = rooms.size() - 1
	change_room(next)

func _go_right() -> void:
	var next = current_index + 1
	if next >= rooms.size(): next = 0
	change_room(next)
