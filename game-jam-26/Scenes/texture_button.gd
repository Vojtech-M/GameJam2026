extends TextureButton

@export_file("*.tscn") var target_scene: String = "res://Scenes/cutscene/IntroCutscene.tscn"
@export var video_player: VideoStreamPlayer

func _ready() -> void:
	# Tady už nic nepřipojujeme, protože se o to stará editor (nebo to připojíme bezpečně níže)
	pass

# Tuto funkci Godot spustí automaticky, jakmile je propojená v editoru
func _on_pressed() -> void:
	disabled = true # Zamezí vícenásobnému kliknutí
	
	if video_player:
		# Zviditelníme video přehrávač
		video_player.visible = true
		# Spustíme .ogv video
		video_player.play()
		
		# Počkáme, dokud video neskončí
		await video_player.finished
	else:
		print("CHYBA: VideoStreamPlayer není přiřazen v Inspectoru!")
	
	# Bezpečná změna scény po skončení videa
	call_deferred("_change_scene_safely")

func _change_scene_safely() -> void:
	if target_scene != "":
		var error = get_tree().change_scene_to_file(target_scene)
		if error != OK:
			print("CHYBA: Nepodařilo se načíst scénu! Kód: ", error)
	else:
		print("CHYBA: Cesta k cílové scéně je prázdná!")
