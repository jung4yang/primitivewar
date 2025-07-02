extends Area2D

@export var speed = 300

func _ready():
	# 시그널 연결
	connect("area_entered", Callable(self, "_on_area_entered"))
	print("시그널 연결됨")

func _physics_process(delta):
	position.y += speed * delta

func _on_area_entered(area):
	if area.name == "Player":
		print("플레이어와 충돌!")
		area.die()
		queue_free()
	if area.name.begins_with("StoneShield"):
		if area.has_method("damaged"):
			area.damaged()
		queue_free()
