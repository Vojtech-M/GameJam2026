extends Area2D

@export var is_enemy_goal: bool = false

static var player_score: int = 0
static var enemy_score: int = 0

func _ready() -> void:
	print("Brána je aktivní: ", name)

	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	print("Brána zaznamenala objekt: ", body.name)

	# Kontrolujeme typ objektu, ne jeho název.
	if not body is RigidBody2D:
		return

	if body.name != "Ball":
		return

	if is_enemy_goal:
		player_score += 1
	else:
		enemy_score += 1

	print(
		"SKÓRE — Hráč: ",
		player_score,
		" | Soupeř: ",
		enemy_score
	)

	# Zastavení míče a přesunutí do středu.
	body.linear_velocity = Vector2.ZERO
	body.angular_velocity = 0.0
	body.global_position = get_viewport_rect().size / 2
