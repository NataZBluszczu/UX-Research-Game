extends Node2D

@onready var fly_nr = []

var draggable = false
var clickable = false
var is_inside_dropable = false
var body_ref
var offset: Vector2
var initialPos : Vector2
var is_selected = false

var above_cauldron = false

@onready var bookshelf: Node2D = $".."


func _ready() -> void:
	fly_nr = name.right(1)

func _process(delta):
	if GameManager.input_locked:
		return
	if GameManager.is_drag_mode == true:
		if draggable:
			if Input.is_action_just_pressed("click"):
				initialPos = global_position
				offset = get_global_mouse_position() - global_position
				global.is_dragging = true
				_on_drag_start()
			if Input.is_action_pressed("click"):
				global_position = get_global_mouse_position() - offset
			elif Input.is_action_just_released("click"):
				global.is_dragging = false
				_on_drag_end()
				var tween = get_tree().create_tween()
				if above_cauldron:
					tween.tween_property(self,"position",body_ref.get_parent().position,0.2).set_ease(Tween.EASE_OUT)
					var place_nr = body_ref.get_parent().name.right(1)
					var book_nr = name.right(1)
					bookshelf.book_dragged(book_nr, place_nr)
					
				else:
					GameManager.input_locked = true
					tween.tween_property(self,"global_position",initialPos,0.2).set_ease(Tween.EASE_OUT)
					await tween.finished
					GameManager.input_locked = false
	else:
		if clickable:
			if Input.is_action_just_pressed("click"):
				toggle_selected()
	
func toggle_selected():
	if GameManager.selected_item == self:  # kliknięto na zaznaczony
		GameManager.selected_item = null
		GameManager.selected_vial = null
		is_selected = false
		scale = Vector2(1, 1)
	else:  # zaznacz nowy
		# odznacz poprzedni
		var prev_selected = GameManager.selected_item
		if GameManager.selected_item:
			GameManager.selected_item.is_selected = false
			GameManager.selected_item.scale = Vector2(1, 1)
			GameManager.selected_item.clickable = false
		if prev_selected and prev_selected.name.contains("Book"):
			return
		GameManager.selected_item = self
		GameManager.selected_vial = self
		is_selected = true
		scale = Vector2(1.2, 1.2)
		clickable = true

func _on_area_2d_body_entered(body:StaticBody2D) -> void:
	if body.is_in_group("bookshelf"):
		above_cauldron = true
		body_ref = body

func _on_area_2d_body_exited(body) -> void:
	above_cauldron = false

func _on_area_2d_mouse_entered() -> void:
	if not global.is_dragging:
		draggable = true
		clickable = true
		if not is_selected:
			scale = Vector2(1.05, 1.05)

func _on_area_2d_mouse_exited() -> void:
	if not global.is_dragging and not is_selected:
		draggable = false
		clickable = false
		scale = Vector2(1,1)
	if is_selected:
		clickable = false
		

func _on_drag_start():
	z_index = 100 

func _on_drag_end():
	z_index = 0
