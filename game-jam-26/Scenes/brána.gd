extends Area2D

@export var is_enemy_goal: bool = false
@export var label_player_score: Label
@export var label_enemy_score: Label

# Cesta k výherní scéně (můžeš si ji v editoru změnit na jakoukoliv jinou scénu)
@export_file("*.tscn") var win_scene_path: String = "res://EndGame/GameOver.tscn"

# Cílový počet gólů pro výhru
const TARGET_SCORE: int = 3

static var player_score: int = 0
static var enemy_score: int = 0

func _ready() -> void:
	print("Brána je aktivní: ", name)

	body_entered.connect(_on_body_entered)
	_update_labels()


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

	_update_labels()

	# Kontrola výhry hráče (pokud dal 3 góly do soupeřovy brány)
	if player_score >= TARGET_SCORE:
		print("🎉 Hráč vyhrál! Měníme scénu...")
		if win_scene_path and ResourceLoader.exists(win_scene_path):
			get_tree().change_scene_to_file(win_scene_path)
		else:
			print("Chyba: Výherní scéna nebyla nalezena nebo není nastavená!")
		return

	# Zastavení míče a přesunutí do středu.
	body.linear_velocity = Vector2.ZERO
	body.angular_velocity = 0.0
	body.global_position = get_viewport_rect().size / 2


func _update_labels() -> void:
	if label_player_score:
		label_player_score.text = "Hráč: " + str(player_score)
	if label_enemy_score:
		label_enemy_score.text = "Soupeř: " + str(enemy_score)
