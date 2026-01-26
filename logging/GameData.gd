extends Resource
class_name GameData

@export var user_id: String = ""
@export var version: String = "Click"

# Sekcja Czasu
@export var total_time_seconds: float = 0.0          # całkowity czas sesji
@export var total_mouse_move_time: float = 0.0       # czas gdy mysz była w ruchu
@export var total_drag_time: float = 0.0            # czas przeciągania przedmiotów

# Sekcja Dystansu i Akcji
@export var total_mouse_dist: float = 0.0           # całkowity dystans myszy
@export var total_drag_dist: float = 0.0            # dystans tylko podczas przeciagania
@export var total_clicks: int = 0                   # liczba kliknięć myszką

@export var total_time_in_minutes: String = "" 

@export var items_collected: Array = []             #do pytania o półki
@export var gems_order_of_placement: Array = []		#do pytania o kolejność włożenia klejnotów


				#2.
#4.								#3.
				#1.
