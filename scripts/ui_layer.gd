extends CanvasLayer

@onready var lup = $ScoreBar/LUP
@onready var rup = $ScoreBar/RUP
@onready var game_over = $GameOver

# Called when the node enters the scene tree for the first time.
func _ready():
	EventBus.reset_game.connect( _on_game_reset )
	EventBus.update_points.connect( _on_update_points )
	EventBus.gameover.connect( _on_game_over )

func _on_game_reset():
	lup.text = "0"
	rup.text = "0"
	game_over.visible = false


func _on_update_points( who: String, points: int ):
	if who == "lup_points":
		lup.text = str(points)
	elif who == "rup_points":
		rup.text = str(points)


func _on_game_over():
	game_over.visible = true
