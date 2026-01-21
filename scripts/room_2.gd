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
@onready var miejsce_area: Node2D = $Miejsce

@onready var spider: Node2D = $Spider
@onready var spider_sprite: Sprite2D = $Spider/SpiderSprite
@onready var dreamcatcher: Node2D = $Dreamcatcher


@onready var fly_1: Node2D = $Fly1
@onready var fly_2: Node2D = $Fly2
@onready var fly_3: Node2D = $Fly3
@onready var fly_4: Node2D = $Fly4
@onready var fly_5: Node2D = $Fly5

@onready var flies = [fly_1, fly_2, fly_3, fly_4, fly_5]
@onready var start_positions = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for fly in flies:
		start_positions.append(fly.position)
	GameManager.gem_is_placed.connect(show_gem)
	GameManager.all_gems_placed.connect(show_board)
	
	GameManager.lighted_candle.connect(light_candle)
	
	GameManager.wrong_flies.connect(_on_spider_fed_wrong)
	GameManager.right_flies.connect(_on_spider_fed_well)
	GameManager.fly_added.connect(_on_fly_added)
	
	candle_1.modulate.a = 0.0
	candle_2.modulate.a = 0.0
	candle_3.modulate.a = 0.0
	
	green.modulate.a = 0.0
	orange.modulate.a = 0.0
	yellow.modulate.a = 0.0
	purple.modulate.a = 0.0
	
	miejsce_area.process_mode = Node.PROCESS_MODE_DISABLED
	
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
		tween.tween_property(obraz, "rotation", rotation + deg_to_rad(-140), 1.0).set_ease(Tween.EASE_IN_OUT)
		miejsce_area.process_mode = Node.PROCESS_MODE_INHERIT
		
#SPIDER
func _on_fly_added():
	GameManager.input_locked = true
	var tween = get_tree().create_tween()
	var base_scale: Vector2 = spider.scale
	tween.tween_property(spider, "scale", Vector2(1.05, 1.05), 0.2)
	tween.tween_property(spider, "scale", Vector2(base_scale.x, base_scale.y), 0.3)
	tween.finished.connect(GameManager._on_anim_finished)
	

func _on_spider_fed_well():
	dreamcatcher.visible = true
	var start_pos = spider.position.y
	GameManager.input_locked = true
	var tween = get_tree().create_tween()
	tween.tween_property(spider, "position:y", start_pos + 60, 0.3).set_ease(Tween.EASE_OUT)
	tween.tween_property(spider, "position:y", start_pos - 1000, 2.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.finished.connect(GameManager._on_anim_finished)
	fly_1.queue_free()
	fly_2.queue_free()
	fly_3.queue_free()
	fly_4.queue_free()
	fly_5.queue_free()
	
func _on_spider_fed_wrong():
	GameManager.input_locked = true
	var original_pos = spider_sprite.position
	var spider_scale = spider_sprite.scale
	
	var tween = get_tree().create_tween()
	
	# Czerwony + powiększenie
	tween.tween_property(spider_sprite, "modulate", Color.RED, 0.3)
	tween.parallel().tween_property(spider_sprite, "scale", Vector2(spider_scale.x * 1.1, spider_scale.y * 1.1), 0.3)
	
	# Shake rozpoczyna się
	var shake_tween = get_tree().create_tween()
	shake_tween.tween_interval(0.15)  # Mały delay przed shake
	for i in range(15):
		var offset = Vector2(randf_range(-6, 6), randf_range(-6, 6))
		shake_tween.tween_property(spider_sprite, "position", original_pos + offset, 0.03)
	
	# ✅ WYPLUCIE w połowie shake (najbardziej dramatyczne)
	tween.tween_interval(0.3)  # Poczekaj chwilę po zaczerwienieniu
	tween.tween_callback(spit_flies_out)
	
	# Poczekaj aż muchy odlecą
	tween.tween_interval(0.4)
	
	# Powrót do normalnego
	tween.tween_property(spider_sprite, "modulate", Color.WHITE, 0.3)
	tween.parallel().tween_property(spider_sprite, "scale", spider_scale, 0.3)
	tween.parallel().tween_property(spider_sprite, "position", original_pos, 0.3)
	
	tween.finished.connect(GameManager._on_anim_finished)

func spit_flies_out():
	for fly in flies:
		fly.position = spider.position
		fly.visible = true
	
	for i in range(flies.size()):
		var fly_tween = get_tree().create_tween()
		var duration = randf_range(0.4, 0.7)
		
		# Każda mucha leci w losowym kierunku najpierw (eksplozja)
		var explosion_dir = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * 30
		var mid_point = spider.position + explosion_dir
		
		fly_tween.tween_property(flies[i], "position", mid_point, duration * 0.3).set_ease(Tween.EASE_OUT)
		fly_tween.tween_property(flies[i], "position", start_positions[i], duration * 0.7).set_ease(Tween.EASE_IN_OUT)
		fly_tween.parallel().tween_property(flies[i], "rotation", randf_range(-TAU * 2, TAU * 2), duration)
		
	
	
