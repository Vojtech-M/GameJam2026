extends RigidBody2D

@export var kick_force: float = 600.0
const MAX_SPEED: float = 800.0

var fixed_x: float = 0.0

func _ready() -> void:
	# Úplné zamknutí rotace
	lock_rotation = true
	
	# Zapamatujeme si počáteční pozici X, aby pin neuhnul do strany
	fixed_x = global_position.x
	
	# Pokud chceš, aby pin přirozeně padal dolů, zapni gravitaci v Inspectoru (Gravity Scale > 0).
	# Pokud ho chceš mít plně pod kontrolou kódu/srážek, můžeš ji nechat na 0.

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	# 1. Zafixování osy X, aby pin nikdy necestoval do stran
	var current_transform = state.transform
	current_transform.origin.x = fixed_x
	state.transform = current_transform
	
	# 2. Vynulování jakékoliv náhodné boční rychlosti (pro jistotu)
	var vel = state.linear_velocity
	vel.x = 0.0
	state.linear_velocity = vel

	# 3. Srážka s klíčem (CharacterBody2D)
	for i in range(state.get_contact_count()):
		var collider = state.get_contact_collider_object(i)
		
		if collider and collider is CharacterBody2D:
			# Směr nárazu (řešíme primárně vertikální osu, protože X je zamknuté)
			var push_dir = (global_position - collider.global_position).normalized()
			push_dir.x = 0.0 # Ignorujeme případný boční posun od klíče
			
			var player_velocity = collider.velocity
			var impulse = push_dir * kick_force + player_velocity * 0.5
			
			state.apply_central_impulse(impulse)

	# 4. Omezení maximální rychlosti pinu
	if state.linear_velocity.length() > MAX_SPEED:
		state.linear_velocity = state.linear_velocity.limit_length(MAX_SPEED)
