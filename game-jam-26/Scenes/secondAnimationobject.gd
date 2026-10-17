extends AnimatableBody2D

@export var speed: float = 2.0      # Rychlost pohybu
@export var distance: float = 200.0 # Jak daleko (v pixelech) se posune na každou stranu

var start_position: Vector2
var time_passed: float = 0.0

func _ready() -> void:
	# Uložíme si počáteční pozici překážky
	start_position = global_position

func _physics_process(delta: float) -> void:
	# Plynule přičítáme čas
	time_passed += delta * speed
	
	# Pomocí funkce sin() vypočítáme plynulý pohyb tam a zpátky (v rozmezí -1 až 1)
	# Můžete změnit Vector2.RIGHT na Vector2.DOWN, pokud chcete, aby se hýbala nahoru a dolů.
	var offset = Vector2.DOWN * sin(time_passed) * distance
	
	# Nastavíme novou pozici vzhledem k počátečnímu bodu
	# U AnimatableBody2D se používá global_position bezpečně i pro kolize s RigidBody2D
	global_position = start_position + offset
