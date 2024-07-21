extends CharacterBody2D
class_name Paddle

@export var player : int
@export var myUp   : String = "_up"
@export var myDown : String = "_down"
@export var SPEED = 500.0
@export var texture : Texture2D
@onready var sprite_2d = $Sprite2D
@onready var shape = $CollisionShape2D.shape

@onready var x_lock = self.position.x

var screen_size

func _ready():
	sprite_2d.texture = texture
	velocity = Vector2.ZERO
	screen_size = get_viewport_rect().size
	position = Vector2( x_lock, 0 )

func _physics_process(delta):
	
	var direction = Input.get_axis(myUp, myDown)
	if direction != 0:
		velocity.y = direction * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)
		
	# Lock to X
	position.x = x_lock
	move_and_collide(velocity * delta)

func new_ball_velocity( ball_velocity: Vector2, ball_position: Vector2 ) -> Vector2:
	
	var new_x : float = -abs( ball_velocity.x ) if ball_position.x <= position.x else abs( ball_velocity.x )
	# how far from the center in y-axis was the hit?
	var from_center:float = ball_position.y - position.y
	# new y is calculated by normalizing from_center (20 to -20 range -> 1 to -1 range)
	# that's done by dividing from_center with max value (in this case: height / 2)
	var new_y:float = from_center / (shape.height / 2)
	# clamp new_y so it doesn't shoot straight up or down
	new_y = clampf(new_y, -0.9, 0.9)
	return Vector2(new_x, new_y).normalized()
