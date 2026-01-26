extends Node2D

@onready var amulet: Node2D = $Amulet
@onready var cauldron: Node2D = $Cauldron

@onready var purple: Node2D = $Purple
@onready var blue: Node2D = $Blue
@onready var pink: Node2D = $Pink
@onready var yellow: Node2D = $Yellow
@onready var red: Node2D = $Red
@onready var green: Node2D = $Green


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.spawn_amulet.connect(_on_spawn_amulet)
	amulet.visible = false
	amulet.modulate.a = 0.0
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_spawn_amulet():
	var tween = get_tree().create_tween()
	print("haha")
	amulet.visible = true
	tween.tween_property(amulet, "modulate:a", 1.0, 0.8)  # fade in 0.8s
	tween.tween_property(amulet, "scale", Vector2(1.2, 1.2), 0.4).set_ease(Tween.EASE_OUT)
	tween.tween_property(amulet, "scale", Vector2(1, 1), 0.4)
	GameManager.all_items_added = true
	cauldron.process_mode = Node.PROCESS_MODE_DISABLED



func _on_cauldron_body_mouse_entered() -> void:
	print("KLIK NA KOCIOŁ!")
