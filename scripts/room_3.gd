extends Node2D

@onready var backgrounddoor: Sprite2D = $backgrounddoor
@onready var youescaped: Sprite2D = $Youescaped

@onready var s_1: Node2D = $FinalItems/S1
@onready var s_2: Node2D = $FinalItems/S2
@onready var s_3: Node2D = $FinalItems/S3
@onready var s_4: Node2D = $FinalItems/S4



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.finish_quest_finished.connect(_fade_in_sprite)
	GameManager.finish_item_added.connect(_show_shelf_object)
	
	backgrounddoor.modulate.a = 0.0
	youescaped.modulate.a = 0.0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _fade_in_sprite():
	var tween = get_tree().create_tween()
	tween.tween_property(backgrounddoor, "modulate:a", 1.0, 2.0)
	tween.tween_property(youescaped, "modulate:a", 1.0, 2.0)
	
func _show_shelf_object(item_name: String, shelf_nr: String):
	if shelf_nr == "1":
		s_1.get_node(item_name).visible = true
	if shelf_nr == "2":
		s_2.get_node(item_name).visible = true
	if shelf_nr == "3":
		s_3.get_node(item_name).visible = true
	if shelf_nr == "4":
		s_4.get_node(item_name).visible = true
	
