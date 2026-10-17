extends RichTextLabel

@export var speed: float = 0.05 

@export_multiline var lines: Array[String] = [
	"Hm, další den v práci",
	"Zákazníci čekají !",
	"Nemám čas ty pizzy nosit !",
	"Rychle než vychladne a zmizí !"
]

var current_line_index: int = 0
var tween: Tween

func _ready():
	show_current_line()

func show_current_line():
	if current_line_index < lines.size():
		text = lines[current_line_index]
		visible_ratio = 0.0
		
		var duration = text.length() * speed
		
		if tween and tween.is_running():
			tween.kill()
			
		tween = create_tween()
		tween.tween_property(self, "visible_ratio", 1.0, duration)
	else:
		# --- TADY KONČÍ VŠECHNY TEXTY ---
		finish_cutscene()

func _input(event):
	if event.is_action_pressed("ui_accept") or (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
		
		if tween and tween.is_running():
			tween.kill()
			visible_ratio = 1.0
		else:
			current_line_index += 1
			show_current_line()

func finish_cutscene():
	# 1. Skryjeme okno s textem
	hide()
	
	# 2. TADY ODEMKNETE HRÁČE PODLE TOHO, JAK JSTE HO ZABLOKOVALI:
	
	# MOŽNOST A: Pokud jsi pauznul celou hru
	# get_tree().paused = false
	
	# MOŽNOST B: Pokud máš hráče ve skupině "Player" a chceš mu zapnout pohyb:
	var players = get_tree().get_nodes_in_group("Player")
	if players.size() > 0:
		var player = players[0]
		# Pokud má hráč proměnnou can_move:
		if "can_move" in player:
			player.can_move = true
			
	# MOŽNOST C: Pokud celou scénu / cutscénu spravuje Autoload / Singleton (např. GameState):
	# GameState.is_cutscene_active = false
