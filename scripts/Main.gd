extends Node2D

const MAIN = "res://scenes/Main.tscn"
const COUNTDOWN_SCENE = preload("res://scenes/countdown.tscn")
@onready var audio_stream_player_2d = $AudioStreamPlayer2D

@onready var screen_size = get_viewport_rect().size
var lup_points := 0
var rup_points := 0
var game_is_over := false


func _ready():
	EventBus.screen_exited_left.connect( _on_ball_exited_left )
	EventBus.screen_exited_right.connect( _on_ball_exited_right )
	randomize()
	audio_stream_player_2d.stream = preload("res://assets/audio/1 - Adventure Begin.ogg")
	new_game()


func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	if game_is_over && Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file(MAIN)


func new_game():
	EventBus.reset_game.emit()
	lup_points = 0
	rup_points = 0
	countdown_and_serve()

func countdown_and_serve():
	# Check if the game has ended
	if lup_points > 1 || rup_points > 1:
		EventBus.gameover.emit()
		game_is_over = true
		# One Last Serve
		await get_tree().create_timer(1.0).timeout
		EventBus.serve_ball.emit()
		audio_stream_player_2d.play()
	else:
		var countdown_instance = COUNTDOWN_SCENE.instantiate()
		self.add_child(countdown_instance)
		countdown_instance.connect("countdown_finished", _on_Countdown_finished)


func _on_Countdown_finished():
	# Wait for just one second
	await get_tree().create_timer(1.0).timeout
	
	# Tell ball to serve itself
	EventBus.serve_ball.emit()
	
func _on_ball_exited_left():
	rup_points += 1
	EventBus.update_points.emit("rup_points", rup_points)
	await get_tree().create_timer(1.0).timeout
	countdown_and_serve()

func _on_ball_exited_right():
	lup_points += 1
	EventBus.update_points.emit("lup_points", lup_points)
	await get_tree().create_timer(1.0).timeout
	countdown_and_serve()
