extends CharacterBody3D

# Nastavení pohybu (Rychlost 20.0 * 60 sekund = 1200 metrů dlouhá trať)
@export var forward_speed: float = 2000.0     
@export var lane_distance: float = 12.5      # Vzdálenost mezi pruhy (zkus menší hodnotu než 10, např. 3.5)
@export var lane_change_speed: float = 15.0 # Jak rychle auto přejede do jiného pruhu

# Stavové proměnné
var current_lane: int = 0                   # -1 = Levý, 0 = Střed, 1 = Pravý
var target_x: float = 0.0

func _physics_process(delta: float) -> void:
	# 1. Zpracování vstupů od hráče
	if Input.is_action_just_pressed("ui_left") and current_lane > -1:
		current_lane -= 1
	elif Input.is_action_just_pressed("ui_right") and current_lane < 1:
		current_lane += 1
		
	# 2. Výpočet cílové pozice X podle pruhu
	target_x = current_lane * lane_distance
	
	# 3. Výpočet rychlosti pro fyziku (aby fungovaly kolize)
	var new_x = lerp(global_position.x, target_x, lane_change_speed * delta)
	velocity.x = (new_x - global_position.x) / delta
	velocity.z = -forward_speed # Pohyb dopředu        # Gravitace, ať auto nelevituje
	
	# 4. Pohyb pomocí Godot fyziky (aktivuje Area3D kolize!)
	move_and_slide()
