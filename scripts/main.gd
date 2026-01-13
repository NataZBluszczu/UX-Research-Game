extends Node2D

var rooms: Array[Node2D] = []
var current_index := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rooms = [ $Room1, $Room2, $Room3 ]
	_update_rooms_visibility()

func _update_rooms_visibility() -> void:
	for i in rooms.size():
		rooms[i].visible = (i == current_index)
		
func _go_left() -> void:
	current_index -= 1
	if current_index < 0:
		current_index = rooms.size() - 1
	_update_rooms_visibility()

func _go_right() -> void:
	current_index += 1
	if current_index >= rooms.size():
		current_index = 0
	_update_rooms_visibility()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
