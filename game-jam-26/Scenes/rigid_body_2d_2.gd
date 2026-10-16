extends RigidBody2D

# Načasování a síla kopu
@export var kick_force: float = 600.0
const INITIAL_SPEED = 100.0
const MAX_SPEED = 800.0

func _ready() -> void:
	# Na začátku míči udělíme náhodný počáteční impuls, ať se rozjede
	var random_angle = randf_range(0, TAU) # TAU je 2 * PI (celý kruh)
	var direction = Vector2(cos(random_angle), sin(random_angle))
	linear_velocity = direction * INITIAL_SPEED

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	# Kontrola srážek s hráčem
	for i in range(state.get_contact_count()):
		var collider = state.get_contact_collider_object(i)
		
		if collider and collider is CharacterBody2D:
			# Vypočítáme směr od hráče k míči
			var push_dir = (global_position - collider.global_position).normalized()
			
			# Připočteme i část aktuální rychlosti hráče, pokud se hýbe směrem k míči
			var player_velocity = collider.velocity
			
			# Vypočítáme odrazový impuls kombinací síly kopu a rychlosti hráče
			var impulse = push_dir * kick_force + player_velocity * 0.5
			
			# Udělíme míči impulz
			state.apply_central_impulse(impulse)

	# Přísné omezení maximální rychlosti fyzikálního tělesa na konci
	if state.linear_velocity.length() > MAX_SPEED:
		state.linear_velocity = state.linear_velocity.limit_length(MAX_SPEED)
