extends StaticBody2D

func _ready():
	modulate = Color(Color.MEDIUM_PURPLE, 0.3)
	
func _process(delta):
	if global.is_dragging:
		modulate = Color(Color.MEDIUM_PURPLE, 0.7)
	else:
		modulate = Color(Color.MEDIUM_PURPLE, 0.3)

func get_slot_index() -> int:
	var name_str = name
	var num_str = name_str.right(-1)
	return num_str.to_int()
	
