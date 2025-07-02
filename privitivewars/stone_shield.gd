extends Area2D

var hit_count = 0

func _ready():
	$AnimatedSprite2D.play("normal")
	set_process(true)

func _process(delta):
	for area in get_overlapping_areas():
		if area.is_in_group("attack"):
			damaged()
			area.queue_free()

func damaged():
	hit_count += 1
	update_state()

func update_state():
	match hit_count:
		3:
			$AnimatedSprite2D.play("cracked1")
		4:
			$AnimatedSprite2D.play("cracked2")
		5:
			$AnimatedSprite2D.play("broken")
		6:
			queue_free()
