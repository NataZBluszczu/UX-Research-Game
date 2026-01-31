extends Node2D

@onready var cauldron_sprite: Sprite2D = $CauldronSprite
@onready var fire: Sprite2D = $CauldronSprite/Fire
@onready var fire_size = fire.scale
@onready var green: Sprite2D = $CauldronSprite/Green
@onready var blue: Sprite2D = $CauldronSprite/Blue
@onready var pink: Sprite2D = $CauldronSprite/Pink
@onready var yellow: Sprite2D = $CauldronSprite/Yellow
@onready var red: Sprite2D = $CauldronSprite/Red
@onready var purple: Sprite2D = $CauldronSprite/Purple
@onready var white: Sprite2D = $CauldronSprite/White

# Dictionary mapujący kolory na sprite'y
var smoke_sprites = {}
var current_smoke: Sprite2D = null

func _ready() -> void:
	fire.visible = false
	GameManager.reset_cauldron.connect(cauldron_switch)
	GameManager.vial_added.connect(pulse_animation)
	smoke_sprites = { 
		"White": white,
		"Green": green,
		"Blue": blue,
		"Pink": pink,
		"Yellow": yellow,
		"Red": red,
		"Purple": purple
	}
	
	for smoke in smoke_sprites.values():
		smoke.visible = true
		smoke.modulate.a = 0.0
	
	white.visible = true
	current_smoke = white

func _process(delta: float) -> void:
	pass

func pulse_animation(color: String):
	GameManager.input_locked = true
	var base_scale: Vector2 = cauldron_sprite.scale
	var tween = get_tree().create_tween()
	
	tween.tween_property(cauldron_sprite, "scale", Vector2(base_scale.x + 0.07,base_scale.y + 0.07), 0.2)
	tween.tween_property(cauldron_sprite, "scale", base_scale, 0.3)
	tween.finished.connect(GameManager._on_anim_finished)
	
	change_color(color)

func change_color(color: String):
	if color not in smoke_sprites:
		printerr("Nieznany kolor dymu: ", color)
		return
	
	var new_smoke = smoke_sprites[color]
	
	if new_smoke == current_smoke:
		return
	
	var tween = get_tree().create_tween()
	tween.set_parallel(true) 
	
	if current_smoke:
		tween.tween_property(current_smoke, "modulate:a", 0.0, 0.7)
	
	tween.tween_property(new_smoke, "modulate:a", 1.0, 0.7)
	
	current_smoke = new_smoke

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		if GameManager.input_locked:
			return
		var selected_item = GameManager.selected_item
		
		if selected_item and GameManager.selected_vial:
			if GameManager.is_cauldron_activated == true:
				var vial_color = selected_item.name
				GameManager.add_vial_to_cauldron(vial_color)
		
		if selected_item:
			if selected_item.name == "Matches":
				if GameManager.is_cauldron_activated == false:
					cauldron_switch()
					GameManager.selected_item.is_selected = false
					GameManager.selected_item.scale = Vector2(1,1)
					GameManager.selected_item = null
					
func cauldron_switch():
	GameManager.is_cauldron_activated = !GameManager.is_cauldron_activated
	if GameManager.is_cauldron_activated:
		fire.visible = true
		var tween = get_tree().create_tween()
		change_color("White")
		tween.tween_property(current_smoke, "modulate:a", 1.0, 1.0)
	else:
		fire.visible = false
		var tween = get_tree().create_tween()
		tween.tween_property(current_smoke, "modulate:a", 0.0, 1.0)
