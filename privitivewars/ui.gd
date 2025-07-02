extends CanvasLayer

var score = 0
var time_elapsed = 0.0

var remaining_dino = 0  # 남은 공룡 수

@onready var score_label = $ScoreLabel
@onready var time_label = $TimeLabel


func _process(delta):
	time_elapsed += delta
	time_label.text = "TIME: " + str(int(time_elapsed))

func add_score(amount):
	score += amount
	score_label.text = "SCORE: " + str(score)
