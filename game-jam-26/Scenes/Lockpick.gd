extends CharacterBody2D

# --- NASTAVENÍ POHYBU KLÍČE ---
@export var speed: float = 400.0

func _physics_process(delta: float) -> void:
	var direction := Vector2.ZERO

	# Pohyb nahoru / dolů (W, S nebo Šipky)
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
		direction.y += 1.0
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
		direction.y -= 1.0

	# Pohyb vlevo / vpravo (A, D nebo Šipky) - Klíč se teď může hýbat jakkoliv
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		direction.x += 1.0
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		direction.x -= 1.0

	# Normalizujeme směr, aby se úhlopříčně nepohyboval rychleji
	direction = direction.normalized()

	# Aplikace rychlosti a pohybu
	velocity = direction * speed
	move_and_slide()
