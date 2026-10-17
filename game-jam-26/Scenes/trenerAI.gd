extends CharacterBody2D

@export var speed: float = 300.0
@export var ball_path: NodePath

var ball: RigidBody2D

func _ready() -> void:
	ball = get_node_or_null(ball_path) as RigidBody2D

	if ball == null:
		print("Ball not found! Set Ball Path in Inspector.")
	else:
		print("Enemy found the ball!")

func _physics_process(_delta: float) -> void:
	if ball == null:
		return

	# Follow the ball vertically only.
	var direction: float = ball.global_position.y - global_position.y

	if abs(direction) > 10.0:
		velocity.y = sign(direction) * speed
	else:
		velocity.y = 0.0

	# Never move horizontally.
	velocity.x = 0.0

	move_and_slide()
