extends Node2D

@onready var candle_1: Node2D = $Swiecznik/Candle1
@onready var candle_2: Node2D = $Swiecznik/Candle2
@onready var candle_3: Node2D = $Swiecznik/Candle3
@onready var obraz: Sprite2D = $Painting/Obraz

@onready var green: Sprite2D = $Miejsce/Miejsce/Green
@onready var orange: Sprite2D = $Miejsce/Miejsce/Orange
@onready var yellow: Sprite2D = $Miejsce/Miejsce/Yellow
@onready var purple: Sprite2D = $Miejsce/Miejsce/Purple

@onready var miejsce: Sprite2D = $Miejsce/Miejsce
@onready var board: Node2D = $Board


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.gem_is_placed.connect(show_gem)
	GameManager.all_gems_placed.connect(show_board)
	GameManager.lighted_candle.connect(light_candle)
	candle_1.modulate.a = 0.0
	candle_2.modulate.a = 0.0
	candle_3.modulate.a = 0.0
	
	green.modulate.a = 0.0
	orange.modulate.a = 0.0
	yellow.modulate.a = 0.0
	purple.modulate.a = 0.0
	
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
	

func show_gem(gem_color: String):
	if gem_color == "Green":
		var tween = get_tree().create_tween()
		tween.tween_property(green, "modulate:a", 1.0, 2.0)
	if gem_color == "Orange":
		var tween = get_tree().create_tween()
		tween.tween_property(orange, "modulate:a", 1.0, 2.0)
	if gem_color == "Yellow":
		var tween = get_tree().create_tween()
		tween.tween_property(yellow, "modulate:a", 1.0, 2.0)
	if gem_color == "Purple":
		var tween = get_tree().create_tween()
		tween.tween_property(purple, "modulate:a", 1.0, 2.0)
		
func show_board():
	board.visible = true
	var sprite_height = miejsce.texture.get_height() * miejsce.scale.y
	var tween = get_tree().create_tween()
	tween.tween_property(miejsce, "position", miejsce.position + Vector2(0, -sprite_height), 1.0)
	

func _on_painting_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		var tween = get_tree().create_tween()
		tween.tween_property(obraz, "rotation", rotation + deg_to_rad(140), 1.0).set_ease(Tween.EASE_IN_OUT)
