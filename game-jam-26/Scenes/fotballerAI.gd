extends CharacterBody2D

@export var speed: float = 200.0
@export var ball: Node2D # Sem přetáhni míč v Inspektoru

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Pokud míč v Inspektoru chybí (nebo se zapomněla uložit scéna)
	if not ball:
		velocity = Vector2.ZERO # Zastavíme ho, aby neutíkal pryč
		move_and_slide()
		return

	# Vypočítáme směr k míči
	var direction = global_position.direction_to(ball.global_position)
	
	# Nastavíme rychlost a pohybujeme se
	velocity = direction * speed
	move_and_slide()

	
