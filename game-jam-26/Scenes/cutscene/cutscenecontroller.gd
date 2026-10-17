extends Control

# V Godotu 4 používáme anotaci @export s tipem pro výběr souboru
@export_file("*.tscn") var next_scene_path: String

# V Godotu 4 se onready píše jako @onready
@onready var video_player = $VideoStreamPlayer

func _ready():
	# V Godotu 4 se signály připojují moderním způsobem bez řetězců
	video_player.finished.connect(_on_video_finished)
	video_player.play()

func _input(event):
	# Přeskočení videa mezerníkem nebo enterem
	if event.is_action_pressed("ui_accept"):
		go_to_next_scene()

func _on_video_finished():
	go_to_next_scene()

func go_to_next_scene():
#
	get_tree().change_scene_to_file("res://Scenes/TestScene.tscn")
	
