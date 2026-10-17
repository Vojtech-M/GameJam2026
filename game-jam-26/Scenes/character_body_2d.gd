extends CharacterBody2D

@export var normal_speed: float = 800.0
@export var sprint_speed: float = 550.0

# Nastavení pro omezený sprint
@export var max_sprint_time: float = 1.5   # Jak dlouho v kuse může sprintovat (v sekundách)
@export var sprint_cooldown: float = 2.0   # Jak dlouho trvá, než se sprint opět nabije

var current_sprint_time: float = 0.0
var cooldown_timer: float = 0.0
var is_sprinting: bool = false

func _physics_process(delta: float) -> void:
	# Spravujeme časovače pro obnovu sprintu
	if cooldown_timer > 0:
		cooldown_timer -= delta

	# Čtení kláves WASD
	var direction := Vector2.ZERO
	if Input.is_key_pressed(KEY_W):
		direction.y -= 1.0
	if Input.is_key_pressed(KEY_S):
		direction.y += 1.0
	if Input.is_key_pressed(KEY_A):
		direction.x -= 1.0
	if Input.is_key_pressed(KEY_D):
		direction.x += 1.0

	direction = direction.normalized()

	# Logika sprintu (držíme Shift, pohybujeme se, a máme ještě energii)
	var active_speed = normal_speed
	
	if Input.is_key_pressed(KEY_SHIFT) and direction != Vector2.ZERO and cooldown_timer <= 0:
		if current_sprint_time < max_sprint_time:
			is_sprinting = true
			active_speed = sprint_speed
			current_sprint_time += delta # Přičítáme čas, co hráč sprintuje
			
			# Pokud vyčerpal všechen čas sprintu, zablokujeme ho a spustíme cooldown
			if current_sprint_time >= max_sprint_time:
				cooldown_timer = sprint_cooldown
		else:
			is_sprinting = false
	else:
		is_sprinting = false
		# Pokud nesprintuje, postupně mu obnovujeme energii sprintu
		if current_sprint_time > 0:
			current_sprint_time -= delta * 1.5 # Rychlost doplňování

	# Nastavení rychlosti a pohyb
	velocity = direction * active_speed
	move_and_slide()
	
	# Interakce s míčem / pizzou
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider is RigidBody2D:
			var push_dir = collision.get_normal() * -1
			# Pokud hráč sprintuje, odraz pizzy bude silnější!
			var current_push_force = sprint_speed if is_sprinting else normal_speed
			collider.apply_central_impulse(push_dir * current_push_force * 0.4)
