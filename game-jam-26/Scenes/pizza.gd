extends RigidBody2D

@export var max_speed: float = 300.0
@export var cool_down_time: float = 45.0 # Čas, než pizza vychladne

# Startovací pozice pizzy (vlevo nahoře)
@export var spawn_position: Vector2 = Vector2(300, 300)

var current_timer: float = 0.0
var should_reset: bool = false

func _ready() -> void:
	current_timer = cool_down_time

func reset_ball() -> void:
	should_reset = true

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if should_reset:
		# Nastavení pozice na startovací místo vlevo nahoře
		state.transform = Transform2D(100.100, spawn_position)
		state.linear_velocity = Vector2.ZERO
		state.angular_velocity = 0.0
		current_timer = cool_down_time # Reset časovače chladnutí
		should_reset = false
		return

	# Odpočítávání chladnutí pizzy
	current_timer -= state.step
	if current_timer <= 0.0:
		print("Pizza vychladla! Vracíme na start.")
		should_reset = true
		return

	# Omezení maximální rychlosti
	if state.linear_velocity.length() > max_speed:
		state.linear_velocity = state.linear_velocity.normalized() * max_speed
