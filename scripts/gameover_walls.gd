extends StaticBody2D

func _ready():
	set_collision_layer_value(1, false)
	EventBus.gameover.connect( _on_gameover )

func _on_gameover():
	set_collision_layer_value(1, true)
