extends Area2D

@export var is_enemy_goal: bool = false
@export_file("*.tscn") var win_scene_path: String = "res://Scenes/linguiniPizzeria/Linguini.tscn"

const TARGET_PIZZAS: int = 6
static var delivered_pizzas: int = 0

@export var customer_patience_time: float = 45.0
var current_customer_timer: float = 0.0
var game_over: bool = false

# Seznam pizz, které už byly v tomto kole započítány, aby se nepočítaly dvakrát
var processed_pizzas: Array = []

var label_pizzas: Label
var label_timer: Label

func _ready() -> void:
	print("Zákazník/Brána je aktivní: ", name)
	body_entered.connect(_on_body_entered)
	
	delivered_pizzas = 0
	current_customer_timer = customer_patience_time
	processed_pizzas.clear()


func _process(delta: float) -> void:
	if game_over:
		return
		
	current_customer_timer -= delta
	
	if label_pizzas:
		label_pizzas.text = "Pizzy doručeny: " + str(delivered_pizzas) + " / " + str(TARGET_PIZZAS)
	if label_timer:
		label_timer.text = "Zákazník čeká: " + str(ceil(current_customer_timer)) + "s"
	
	if current_customer_timer <= 0.0:
		game_over = true
		print("😱 Zákazník odešel! Prohra!")
		get_tree().reload_current_scene()

func _on_body_entered(body: Node2D) -> void:
	if game_over:
		return

	if not body is RigidBody2D:
		return

	if not body.has_method("reset_ball"):
		return

	# Ochrana: Pokud už tato konkrétní pizza byla započítána a ještě nebyla zresetovaná, ignorujeme ji
	if body in processed_pizzas:
		return

	# Přidáme pizzu do seznamu zpracovaných
	processed_pizzas.append(body)

	if not is_enemy_goal:
		delivered_pizzas += 1
		current_customer_timer += 20.0 # Přidáme čas za doručení
		
		print("Pizza doručena! Celkem: ", delivered_pizzas, " / ", TARGET_PIZZAS)

		if delivered_pizzas >= TARGET_PIZZAS:
			game_over = true
			print("🎉 VYHRÁLI JSTE! Všech 6 pizz doručeno!")
			
			if win_scene_path and ResourceLoader.exists(win_scene_path):
				get_tree().change_scene_to_file(win_scene_path)
			else:
				print("Chyba: Výherní scéna nebyla nalezena!")
	else:
		print("Pizza spadla do špatné brány!")

	# Reset pizzy
	body.reset_ball()
	
	# Jakmile se pizza zresetuje, odstraníme ji ze seznamu zpracovaných, aby šla zase doručit
	await get_tree().create_timer(0.5).timeout
	processed_pizzas.erase(body)
