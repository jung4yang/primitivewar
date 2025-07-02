extends Area2D

var bullet = preload("res://bullet.tscn")
@export var speed = 400
var is_moving = false # 움직이는 지 여부 를 추적하는 변수
var velocity = Vector2.ZERO # Area2D에서 직접 움직임을 제어하기 위한 velocity 변수


func die():
	get_tree().change_scene_to_file("res://gameover.tscn")
	queue_free()
	print("죽음")


func _ready():
	# 초기 애니메이션 설정 (선택 사항)
	$AnimatedSprite2D.play("idle")
	print(self.name)

func _process(delta):
	var screensize = get_viewport_rect().size
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)
	
	# 총알 발사 (bullet 액션 키 현재 마우스 왼쪽 버튼)
	if Input.is_action_just_pressed("bullet"):
		shoot()
		$AnimatedSprite2D.play("hit")

	# 애니메이션 업데이트 (이동 상태에 따라)
	if is_moving:
		$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.play("idle")

	# Area2D에서 직접 위치 업데이트
	position += velocity * delta

func _physics_process(delta):
	velocity = Vector2.ZERO
	is_moving = false

	if Input.is_action_pressed("ui_left"):
		velocity.x -= speed
		$AnimatedSprite2D.flip_h = false
		is_moving = true
	if Input.is_action_pressed("ui_right"):
		velocity.x += speed
		$AnimatedSprite2D.flip_h = true
		is_moving = true

func shoot():
	# 총알 발사
	var bulletInstance = bullet.instantiate()
	bulletInstance.global_position = global_position + Vector2(0, -30)
	get_tree().current_scene.add_child(bulletInstance)
