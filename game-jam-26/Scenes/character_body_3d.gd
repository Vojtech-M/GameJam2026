extends CharacterBody3D

# Nastavení pohybu
@export var forward_speed: float = 200.0      
@export var lane_distance: float = 10       # Doporučuji menší hodnotu (např. 2.5 nebo 3.5)
@export var lane_change_speed: float = 15.0 

# Stavové proměnné (startovní X je -2.5, což při lane_distance 2.5 odpovídá pruhu -1)
var current_lane: int = -1                  
var target_x: float = -2.5

# Definice startovní pozice
const START_POSITION = Vector3(-2.5, 0.0, 1864.0)

func _ready() -> void:
	reset_position()

func _physics_process(delta: float) -> void:
	# 1. Zpracování vstupů od hráče
	if Input.is_action_just_pressed("ui_left") and current_lane > -1:
		current_lane -= 1
	elif Input.is_action_just_pressed("ui_right") and current_lane < 1:
		current_lane += 1
		
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
	velocity = Vector3.ZERO # Vynuluje rychlost, aby auto nebylo "rozjeté"s


func _on_area_3d_2_body_entered(body: Node3D) -> void:
	pass # Replace with function body.
