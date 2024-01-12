extends AnimatableBody2D

@export var speed = 500
@onready var screen_bottom = get_viewport_rect().size.y

var isNot2ndPlayer = true

var no_delay = true

signal paddle2_movement(direction)
signal ball_force(force: int)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	
	if isNot2ndPlayer:
		var direction = Input.get_axis("p2_up", "p2_down")
		paddle2_movement.emit(direction)
		var velocity = Vector2(0, direction).normalized() * speed
		position += velocity * delta
		var sprite = ($Sprite2D as Sprite2D)
		if(($Top as Marker2D).global_position.y <= 0):
			position = Vector2(position.x, 0 + sprite.texture.get_height() * sprite.scale.y / 2) 
		if(($Bottom as Marker2D).global_position.y >= screen_bottom):
			position = Vector2(position.x, screen_bottom - sprite.texture.get_height() * sprite.scale.y / 2)
		
		if Input.is_action_just_pressed("p2_force") and no_delay:
			ball_force.emit($/root/PongGame.ball_magnitude)
			$/root/PongGame.ball_magnitude = 0
			no_delay = false
			await get_tree().create_timer(1.0).timeout
			no_delay = true


