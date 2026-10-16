extends CharacterBody2D

# --- BALANCOVÁNÍ POHYBU HRÁČE ---
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const ACCELERATION = 1200.0
const FRICTION = 1500.0

# --- SÍLA RÁZU DO PINŮ ---
const PUSH_FORCE = 40.0 

func _physics_process(delta: float) -> void:
	# 1. Aplikace gravitace na hráče
	if not is_on_floor():
		velocity += get_gravity() * delta

	# 2. Skok
	if (Input.is_key_pressed(KEY_SPACE) or Input.is_key_pressed(KEY_W)) and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# 3. Horizontální pohyb (získání směru)
	var direction := 0.0
	if Input.is_key_pressed(KEY_D):
		direction += 1.0
	if Input.is_key_pressed(KEY_A):
		direction -= 1.0

	# Akcelerace a zabrzdění
	if direction != 0.0:
		velocity.x = move_toward(velocity.x, direction * SPEED, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, FRICTION * delta)

	# 4. Pohyb hráče
	move_and_slide()

	# --- 5. ODTLAČOVÁNÍ PINŮ / RIGIDBODY ---
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()

		# Pokud narazíme do RigidBody2D (pin / bedna)
		if collider is RigidBody2D:
			var normal = collision.get_normal()
			
			# Tlačíme pouze ze strany (ignorujeme, když na tom stojíme seshora)
			if abs(normal.x) > 0.5:
				# KLÍČOVÉ: Probudíme objekt, pokud spal, aby reagoval na fyziku
				collider.sleeping = false
				
				# Vypočítáme směr odtlačení pryč od hráče
				var push_dir = Vector2(-normal.x, 0.0)
				
				# Aplikujeme impuls závislý na rychlosti hráče
				collider.apply_impulse(push_dir * abs(velocity.x) * delta * PUSH_FORCE)
