extends CharacterBody3D
class_name Projectile3D

@export var direction: Vector2
@export var speed: float
@export var life_time: float

@export var damage: int = 5
@export var self_damage: int = 1

@onready var health: Health = $Health

var active := false: set = _set_active, get = _get_active

func _set_active(value: bool) -> void:
	call_deferred("switch_process_mode", value)
	active = value

func _get_active() -> bool:
	return active

func switch_process_mode(value: bool) -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS if value else Node.PROCESS_MODE_DISABLED

func _ready() -> void:
	health.died.connect(die)
	var sound := $FireSound
	if sound != null:
		sound.pitch_scale = randf_range(0.5, 2)
		sound.play()

func _process(delta: float) -> void:
	if active:
		life_time -= delta
		if life_time <= 0.0:
			queue_free()

func _physics_process(delta: float) -> void:
	if active:
		velocity = Vector3(direction.x, direction.y, 0) * speed
		move_and_slide()

#func process_collision():
	#var col_info: KinematicCollision3D
	#var other
	#for i in range(get_slide_collision_count()):
		#col_info = get_slide_collision(i)
		#other = col_info.get_collider()
		#if other is EnemyController:
			#if health != null:
				#health.damage(self_damage)

func die():
	active = false
	queue_free()

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is EnemyController:
		if health != null:
			health.damage(self_damage)
		body.damage(damage)
