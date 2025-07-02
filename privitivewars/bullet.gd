extends Area2D

@export var speed = 700           # y축 속도
@export var amplitude = 100       # S곡선의 진폭 (가로 이동 폭)
@export var frequency = 5.0       # S곡선의 빈도 (얼마나 빠르게 왔다 갔다 할지)

# 고인돌 노드들 경로 설정
@onready var shield = get_node("/root/World/StoneShield")

# 고인돌 충돌 영역들
@onready var shield_collision = shield.get_node("CollisionShape2D")

var _time_passed = 0.0
var _start_x = 0.0

func _ready():
	# 총알이 처음 생성된 위치를 기억
	_start_x = position.x
	add_to_group("PlayerBullet")  # PlayerBullet 그룹에 추가

func _physics_process(delta):
	_time_passed += delta
	
	# y축 직선 이동
	position.y -= speed * delta
	
	# x축에 S자 형태로 움직이는 오프셋 적용
	position.x = _start_x + amplitude * sin(_time_passed * frequency)

	# 고인돌들 뒤에 있을 경우 발사 안 되게 처리
	if is_colliding_with_shield():
		print("고인돌에 맞았으므로 총알 삭제")
		queue_free()  # 고인돌과 충돌 시 총알 삭제

# 고인돌과 충돌 여부를 확인하는 함수
func is_colliding_with_shield() -> bool:
	# 각 고인돌에 대해 충돌 여부를 확인
	if check_collision_with_shield(shield_collision):
		return true
	return false

# 각 고인돌 충돌 체크 함수
func check_collision_with_shield(shield_collision) -> bool:
	if shield_collision == null:
		return false
	if shield_collision.shape == null:
		return false
	
	var shield_pos = shield_collision.global_position
	var shield_size = shield_collision.shape.extents * 2  # 충돌 영역 크기

	if global_position.x > shield_pos.x - shield_size.x / 2 and global_position.x < shield_pos.x + shield_size.x / 2:
		return true
	
	return false

# 총알이 적과 충돌했을 때 처리
func _on_body_entered(body):
	if body.is_in_group("Enemy"):
		# 적에게 명시적으로 "피해 받음"을 요청
		if body.has_method("take_damage"):
			body.take_damage()
		queue_free()
