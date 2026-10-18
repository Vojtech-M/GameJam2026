extends CharacterBody3D

# Nastavení pohybu
@export var forward_speed: float = 200.0      
@export var lane_distance: float = 10        # Vráceno na 2.5, aby to odpovídalo startu (-2.5)
@export var lane_change_speed: float = 15.0 

# Stavové promény (3 pruhy: -1, 0, 1)
var current_lane: int = -1                   
var target_x: float = -2.5

# Definice startovní pozice
const START_POSITION = Vector3(-2.5, 0.0, 1864.0)

func _ready() -> void:
	reset_position()

# Zpracování jednorázového stisknutí kláves A a D (bez držení)
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_A and current_lane > -1:
			current_lane -= 1
		elif event.keycode == KEY_D and current_lane < 1:
			current_lane += 1

func _physics_process(delta: float) -> void:
	# 2. Výpočet cílové pozice X podle pruhu
	target_x = current_lane * lane_distance
	
	# 3. Výpočet rychlosti pro fyziku
	var new_x = lerp(global_position.x, target_x, lane_change_speed * delta)
	velocity.x = (new_x - global_position.x) / delta
	velocity.z = -forward_speed # Pohyb dopředu
	
	# 4. Pohyb pomocí Godot fyziky
	move_and_slide()
	
	# 5. Kontrola kolize - pokud do něčeho narazíš, resetujeme pozici
	if get_slide_collision_count() > 0:
		reset_position()

# Funkce pro reset na začátek
func reset_position() -> void:
	global_position = START_POSITION
	current_lane = -1       # Musí odpovídat levému pruhu pro X = -2.5
	target_x = START_POSITION.x
	velocity = Vector3.ZERO # Vynuluje rychlost, aby auto nebylo "rozjeté"

func _on_area_3d_2_body_entered(body: Node3D) -> void:
	pass # Replace with function body.
