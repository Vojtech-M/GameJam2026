extends CharacterBody2D

@export var speed: float = 300.0
@export var ball_path: NodePath

var ball: RigidBody2D

func _ready() -> void:
	ball = get_node_or_null(ball_path) as RigidBody2D

func _physics_process(_delta: float) -> void:
	if ball == null:
		return

	var direction = ball.global_position.y - global_position.y

	velocity.y = sign(direction) * speed if abs(direction) > 10.0 else 0.0
	velocity.x = 0.0

	move_and_slide()
