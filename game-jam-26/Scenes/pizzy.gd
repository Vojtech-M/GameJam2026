extends Label

const TARGET_PIZZAS: int = 6
static var delivered_pizzas: int = 0

@export var customer_patience_time: float = 45.0
var current_timer: float = 0.0
var is_game_over: bool = false

func _ready() -> void:
	delivered_pizzas = 0
	current_timer = customer_patience_time

func _process(delta: float) -> void:
	if is_game_over:
		return
		
	current_timer -= delta
	
	# Text, který se ukáže na obrazovce
	text = "Pizzzzy: " + str(delivered_pizzas) + " / " + str(TARGET_PIZZAS) + "\nČas: " + str(ceil(current_timer)) + "s"
	
	if current_timer <= 0.0:
		is_game_over = true
		get_tree().reload_current_scene()

# Tuto funkci zavolá zákazník/brána, když doručíte pizzu
static func add_pizza() -> void:
	delivered_pizzas += 1
