extends Node2D

@onready var backgrounddoor: Sprite2D = $backgrounddoor
@onready var youescaped: Sprite2D = $Youescaped


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	backgrounddoor.modulate.a = 0.0
	youescaped.modulate.a = 0.0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func fade_in_sprite():
	var tween = get_tree().create_tween()
	tween.tween_property(backgrounddoor, "modulate:a", 1.0, 2.0)
	tween.tween_property(youescaped, "modulate:a", 1.0, 2.0)
	
