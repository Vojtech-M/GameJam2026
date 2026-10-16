extends Area2D

# V Inspectoru zaškrtneš, jestli je to branka pro soupeře, nebo tvoje
@export var is_enemy_goal: bool = false 

# Lokální proměnné pro skóre přímo v brance
static var player_score: int = 0
static var enemy_score: int = 0

func _ready() -> void:
	print("Brána je aktivní: ", name)

func _on_body_entered(body: Node2D) -> void:
	print("Něco narazilo do brány: ", body.name)
	
	# Zkontrolujeme, jestli objekt má ve jméně "Ball"
	if "Ball" in body.name:
		if is_enemy_goal:
			player_score += 1
			print("GÓL! Tvoje skóre: ", player_score, " | Soupeř: ", enemy_score)
		else:
			enemy_score += 1
			print("GÓL! Skóroval soupeř. Tvoje skóre: ", player_score, " | Soupeř: ", enemy_score)
			
		# Reset míče do středu obrazovky
		body.position = get_viewport_rect().size / 2
		body.linear_velocity = Vector2.ZERO
