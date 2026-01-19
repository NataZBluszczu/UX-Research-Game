extends Node2D

@onready var candle_1: Node2D = $Swiecznik/Candle1
@onready var candle_2: Node2D = $Swiecznik/Candle2
@onready var candle_3: Node2D = $Swiecznik/Candle3
@onready var obraz: Sprite2D = $Painting/Obraz


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.lighted_candle.connect(light_candle)
	candle_1.modulate.a = 0.0
	candle_2.modulate.a = 0.0
	candle_3.modulate.a = 0.0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func light_candle(candle_nr: String):
	if candle_nr == "1":
		var tween = get_tree().create_tween()
		tween.tween_property(candle_1, "modulate:a", 1.0, 2.0)
	if candle_nr == "2":
		var tween = get_tree().create_tween()
		tween.tween_property(candle_2, "modulate:a", 1.0, 2.0)
	if candle_nr == "3":
		var tween = get_tree().create_tween()
		tween.tween_property(candle_3, "modulate:a", 1.0, 2.0)
	



func _on_painting_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		var tween = get_tree().create_tween()
		tween.tween_property(obraz, "rotation", rotation + deg_to_rad(140), 1.0).set_ease(Tween.EASE_IN_OUT)
