extends Control
class_name CountDown

@onready var screen_size = get_viewport_rect().size

signal countdown_finished

func _ready():
	print("In Countdown _ready()\nPosition: " + str(Vector2(screen_size.x/2,screen_size.y/2)))
	position = Vector2( 0, 0 )

func _on_animation_player_animation_finished(anim_name):
	emit_signal("countdown_finished")
	self.queue_free()
