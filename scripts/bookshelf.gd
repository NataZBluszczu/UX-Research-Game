extends Node2D

@onready var book1: Node2D = $Book1
@onready var book2: Node2D = $Book2
@onready var book3: Node2D = $Book3
@onready var book4: Node2D = $Book4
@onready var book5: Node2D = $Book5

@onready var ball: Node2D = $"../Ball"


@onready var books = []
@onready var books_pattern = ["1","2","3","4","5"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	books = ["3","1","4","5","2"]
	books_pattern = ["1","2","3","4","5"]
	ball.modulate.a = 0
	ball.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func book_replaced(book_nr1: String, book_placed_on: String):
	var book_nr2 = books[int(book_placed_on) - 1]
	var first_book = get_node("Book" + book_nr1)
	var second_book = get_node("Book" + book_nr2)
	
	var pos1 = first_book.position
	var pos2 = second_book.position
	
	var tween = create_tween().set_parallel(true)
	tween.tween_property(first_book, "position", pos2, 0.4)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
		
	tween.tween_property(second_book, "position", pos1, 0.4)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	books_moved(book_nr1, book_nr2)
	if GameManager.selected_item != null:
		GameManager.selected_item.is_selected = false
		GameManager.selected_item.scale = Vector2(1, 1)
		GameManager.selected_item = null
	
func book_dragged(book_nr1: String, book_placed_on: String):
	var book_nr2 = books[int(book_placed_on) - 1]
	var book_index = books.find(book_nr1)
	var position_node = get_node("BookPlace" + str(book_index + 1))
	var book_to_move = get_node("Book" + book_nr2)
	var tween = get_tree().create_tween()
	
	tween.tween_property(book_to_move, "position", position_node.position, 0.4)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
	await tween.finished
	books_moved(book_nr1, book_nr2)
	

func books_moved(book_nr1: String, book_nr2: String):
	var book_nr1_index = books.find(book_nr1)
	var book_nr2_index = books.find(book_nr2)
	var buf = books[book_nr1_index]
	books[book_nr1_index] = books[book_nr2_index]
	books[book_nr2_index] = buf
	if books == books_pattern:
		riddle_finished()
		
func riddle_finished():
	var move_distance: float = 60.0 
	var move_duration: float = 0.8 
	
	var tween = create_tween().set_parallel(true)
	
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)

	tween.tween_property(book1, "position:x", book1.position.x - move_distance, move_duration)
	tween.tween_property(book2, "position:x", book2.position.x - move_distance - 100, move_duration)
	
	tween.tween_property(book3, "position:x", book3.position.x + move_distance + 200, move_duration)
	tween.tween_property(book4, "position:x", book4.position.x + move_distance + 100, move_duration)
	tween.tween_property(book5, "position:x", book5.position.x + move_distance, move_duration)
	
	ball.visible = true
	var tween2 = get_tree().create_tween()
	tween2.tween_property(ball, "modulate:a", 1.0, 2.0)
	
	for child in get_children():
		if child is Node2D:
			child.process_mode = Node.PROCESS_MODE_DISABLED
			
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	
	
func _input(event):
	if event.is_action_pressed("2"):
		print(books)
