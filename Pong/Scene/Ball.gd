extends RigidBody2D

@export var speed:int = 100
@export var force_scalar:int = 5

@onready var paddle2Path := $PathFacingPaddle2/PathFollow2D
@onready var paddle1Path := $PathFacingPaddle1/PathFollow2D

var reset = false

const natural_scale = Vector2(0.75, 0.75)
const natural_alpha = 200


func _ready():
	paddle1Path.progress_ratio = 0.5
	paddle2Path.progress_ratio = 0.5

func _process(_delta):
	$PathFacingPaddle1/Sprite2D.position = paddle1Path.position
	$PathFacingPaddle2/Sprite2D.position = paddle2Path.position
	paddle1Path.look_at(global_position)
	paddle2Path.look_at(global_position)


func _on_paddle_1_paddle_1_movement(direction):
	if direction == 0:
		pass
	elif direction > 0: 
		paddle1Path.progress_ratio -= 0.015
		
	else:
		paddle1Path.progress_ratio += 0.015
	
	paddle1Path.progress_ratio = clampf(paddle1Path.progress_ratio, 0.0, 1.0)

func _on_paddle_2_paddle_2_movement(direction):
	if direction == 0:
		pass
	elif direction > 0:
		paddle2Path.progress_ratio += 0.015
		
	else:
		paddle2Path.progress_ratio -= 0.015
		
	paddle2Path.progress_ratio = clampf(paddle2Path.progress_ratio, 0.0, 1.0)

func _on_paddle_1_ball_force(force):
	var force_direction: Vector2 = global_position - paddle1Path.global_position
	force_direction.normalized()
	var tween = get_tree().create_tween()
	
	tween.tween_property($PathFacingPaddle1/Sprite2D, "scale", Vector2(4, 4), 0.1)
	tween.tween_property($PathFacingPaddle1/Sprite2D, "modulate:a", 0, 0.1)
	apply_force(force_direction * force * force_scalar)
	tween.tween_property($PathFacingPaddle1/Sprite2D, "scale", natural_scale, 0.1)
	tween.tween_property($PathFacingPaddle1/Sprite2D, "modulate:a8", natural_alpha, 0.01)
	
	
func _on_paddle_2_ball_force(force):
	var force_direction: Vector2 = global_position - paddle2Path.global_position
	force_direction.normalized()
	var tween = get_tree().create_tween()
	
	tween.tween_property($PathFacingPaddle2/Sprite2D, "scale", Vector2(4, 4), 0.1)
	tween.tween_property($PathFacingPaddle2/Sprite2D, "modulate:a", 0, 0.1)
	apply_force(force_direction * force * force_scalar)
	tween.tween_property($PathFacingPaddle2/Sprite2D, "scale", natural_scale, 0.1)
	tween.tween_property($PathFacingPaddle2/Sprite2D, "modulate:a8", natural_alpha, 0.01)

func _integrate_forces(state):
	if reset:
		state.transform = Transform2D(0.0, Vector2(576, 324))
		state.linear_velocity = Vector2()
		reset = false
