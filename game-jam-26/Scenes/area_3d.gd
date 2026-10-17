extends Area3D

@export_file("*.tscn") var next_scene: String = "res://Scenes/Farma/stadionCutscene.tscn"

func _ready() -> void:
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node3D) -> void:
	# Ověření, zda do překážky narazil hráč
	if body.is_in_group("Player"):
		print("Kolize s hráčem! Odkládám změnu scény...")
		# Změna scény maže uzly, což fyzika nedovolí – proto voláme call_deferred
		call_deferred("_change_scene_safely")

func _change_scene_safely() -> void:
	if next_scene:
		var error = get_tree().change_scene_to_file(next_scene)
		if error != OK:
			print("CHYBA: Nepodařilo se načíst scénu! Kód: ", error)
	else:
		print("CHYBA: Cesta k další scéně je prázdná!")
