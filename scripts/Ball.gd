extends CharacterBody2D
class_name Ball

@export var speed : int = 100
var direction:Vector2 = Vector2.ZERO
@onready var audio_stream_player_2d = $AudioStreamPlayer2D


func _ready():
	set_physics_process(true)
	randomize()
	EventBus.serve_ball.connect( _on_serve_ball )


func _physics_process(delta):
	var collision = move_and_collide(velocity * speed * delta)

	if collision:
		var collider : Object = collision.get_collider()
		print("Ball hit a ", collider.get_class())
		if !special_collision( collider ):
			# if the velocity was not handled after collision, just bounce
			velocity = velocity.bounce(collision.get_normal())

		# what bounce sound should be played?
		if collider is StaticBody2D:
			audio_stream_player_2d.stream = preload("res://assets/audio/Bleep_06.wav")
		else:
			audio_stream_player_2d.stream = preload("res://assets/audio/Bleep_03.wav")
		audio_stream_player_2d.play()



func reset_and_serve():
	# Pick and Set Random Direction and Velocity
	direction = Vector2( [-1,1].pick_random(), randf_range(-1,1) )
	velocity = direction.normalized()
	
	# Reset Position to Center
	position = Vector2( 0, 0 )
	visible = true


func special_collision( obj : Object ) -> bool:
	
	if obj.has_method( "new_ball_velocity" ):
		speed += 20
		velocity = obj.new_ball_velocity( velocity, position )
		return true
	
	return false


func _on_serve_ball():
	speed = 300
	reset_and_serve()


func _on_visible_on_screen_notifier_2d_screen_exited():
	# Who missed their bounce?
	if position.x < 0:
		visible = false
		EventBus.screen_exited_left.emit()
	else:
		visible = false
		EventBus.screen_exited_right.emit()
