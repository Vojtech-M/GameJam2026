extends Area2D

@export var is_enemy_goal: bool = false
@export_file("*.tscn") var win_scene_path: String = "res://Scenes/Garáž/pacenoi.tscn"

const TARGET_PIZZAS: int = 6
var delivered_pizzas: int = 0

@export var customer_patience_time: float = 20.0
var current_customer_timer: float = 20.0
var game_over: bool = false

var processed_pizzas: Array = []

@export var label_pizzas: Label
@export var patience_bar: TextureProgressBar # Můžeš změnit na TextureProgressBar, pokud používáš vlastní obrázek

func _ready() -> void:
	print("Zákazník/Brána je aktivní: ", name)
	body_entered.connect(_on_body_entered)
	
	delivered_pizzas = 0
	current_customer_timer = customer_patience_time
	processed_pizzas.clear()
	
	# Inicializace health baru
	if patience_bar:
		patience_bar.max_value = customer_patience_time
		patience_bar.value = current_customer_timer


func _process(delta: float) -> void:
	if game_over:
		return
		
	current_customer_timer -= delta
	
	if label_pizzas:
		label_pizzas.text = "Pizzy doručeny: " + str(delivered_pizzas) + " / " + str(TARGET_PIZZAS)
		
	if patience_bar:
		# Pokud se čas navýší nad původní maximum, přizpůsobíme max_value baru
		if current_customer_timer > patience_bar.max_value:
			patience_bar.max_value = current_customer_timer
		patience_bar.value = current_customer_timer
	
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

	if body in processed_pizzas:
		return

	processed_pizzas.append(body)

	if not is_enemy_goal:
		delivered_pizzas += 1
		current_customer_timer += 10.0
		
		# Okamžitě aktualizujeme max_value i při přičtení času
		if patience_bar and current_customer_timer > patience_bar.max_value:
			patience_bar.max_value = current_customer_timer

		print("Pizza doručena! Celkem: ", delivered_pizzas, " / ", TARGET_PIZZAS)

		if delivered_pizzas >= TARGET_PIZZAS:
			game_over = true
			print("🎉 VYHRÁLI JSTE! Všech 6 pizz doručeno!")
			
			if win_scene_path and ResourceLoader.exists(win_scene_path):
				get_tree().change_scene_to_file(win_scene_path)
			else:
				print("Chyba: Výherní scéna nebyla nalezena!")
			return 
	else:
		print("Pizza spadla do špatné brány!")

	body.reset_ball()
	
	if is_inside_tree():
		await get_tree().create_timer(0.5).timeout
		processed_pizzas.erase(body)
