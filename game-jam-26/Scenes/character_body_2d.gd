extends CharacterBody2D

const SPEED = 400.0

func _physics_process(delta: float) -> void:
	# Vynulujeme směr na začátku každého snímku
	var direction := Vector2.ZERO

	# Čtení kláves WASD
	if Input.is_key_pressed(KEY_W):
		direction.y -= 4.0
	if Input.is_key_pressed(KEY_S):
		direction.y += 4.0
	if Input.is_key_pressed(KEY_A):
		direction.x -= 4.0
	if Input.is_key_pressed(KEY_D):
		direction.x += 4.0

	# Normalizace směru, aby se postava pohybovala šikmo stejně rychle jako rovně
	direction = direction.normalized()

	# Nastavení rychlosti a pohyb
	velocity = direction * SPEED
	move_and_slide()
	
	# Projdi všechny srážky, které hráč v tomto snímku zaznamenal
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		# Pokud narazíme na míč (RigidBody2D)
		if collider is RigidBody2D:
			# Udělíme míči ráz ve směru pohybu hráče
			var push_dir = collision.get_normal() * -1
			collider.apply_central_impulse(push_dir * SPEED * 0.5)
