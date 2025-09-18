extends Node3D
class_name ConstantMovement

@export var direction: Vector2
@export var speed: float = 0.0
@export var active := true

func _physics_process(delta: float) -> void:
	if not active:
		return
	global_position += Vector3(direction.x, direction.y, 0) * speed * delta
