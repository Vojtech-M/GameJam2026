extends Area2D

# Cesta k tvé garážové scéně (opraveno z .tscm na .tscn)
@export_file("*.tscn") var next_scene: String = "res://Scenes/Lockpick.tscn"

func _ready() -> void:
	# Propojení signálu, pokud už není spojený přes editor
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	# Zkontroluje, jestli do oblasti vstoupil hráč (podle skupiny nebo typu CharacterBody2D)
	if body.is_in_group("Player") or body is CharacterBody2D:
		print("2D Kolize detekována! Měním scénu na garáž...")
		# Bezpečná změna scény po skončení fyzikálního kroku
		call_deferred("_change_scene_safely")

func _change_scene_safely() -> void:
	if next_scene:
		var error = get_tree().change_scene_to_file(next_scene)
		if error != OK:
			print("CHYBA: Nepodařilo se načíst scénu! Kód: ", error)
	else:
		print("CHYBA: Cesta k další scéně je prázdná!")
