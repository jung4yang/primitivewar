extends CharacterBody2D

var move_speed = 30
var shootingcount = 0.0
@export var health = 3
var bullet = preload("res://attack.tscn")

var direction = Vector2.ZERO
var direction_timer = 0.0

func _ready():
	shootingcount = randf_range(0, 50)
	_change_direction()
	connect("body_entered", Callable(self, "_on_body_entered"))

func _physics_process(delta):
	velocity = direction * move_speed
	move_and_slide()
	
	# 방향을 일정 시간마다 바꾼다
	direction_timer -= delta
	if direction_timer <= 0:
		_change_direction()
	
	shootingcount += delta
	if shootingcount >= 13:
		var firedbullet = bullet.instantiate()
		firedbullet.global_position = global_position
		get_tree().current_scene.call_deferred("add_child", firedbullet)
		shootingcount = randf_range(0, 10)

func _change_direction():
	# -1 ~ 1 사이의 임의의 방향 설정 후 정규화
	direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	# 1초~3초마다 방향 전환
	direction_timer = randf_range(0.5, 2.0)


func take_damage():
	health -= 1
	if health <= 0:
		print("공룡 처치됨")
		var ui = get_node("/root/World/UI")  # 정확한 경로 확인 필수!
		if ui:
			ui.add_score(10)
		queue_free()
