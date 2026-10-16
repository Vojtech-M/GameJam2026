extends RigidBody2D

const INITIAL_SPEED = 100.0
const MAX_SPEED = 500.0

func _ready() -> void:
	# Na začátku míči udělíme náhodný počáteční impuls, ať se rozjede
	var random_angle = randf_range(0, TAU) # TAU je 2 * PI (celý kruh)
	var direction = Vector2(cos(random_angle), sin(random_angle))
	linear_velocity = direction * INITIAL_SPEED

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	# Přísné omezení maximální rychlosti fyzikálního tělesa
	if state.linear_velocity.length() > MAX_SPEED:
		state.linear_velocity = state.linear_velocity.limit_length(MAX_SPEED)

	# Kontrola srážek s hráčem
	for i in range(state.get_contact_count()):
		var collider = state.get_contact_collider_object(i)
		if collider and collider is CharacterBody2D:
			# Tady můžeš upravit chování, když míč trefí hráče
			pass
