extends CharacterBody3D
class_name Controller3D

@export var speed: float = 1.0
var weapon_handler: WeaponHandler
var health: Health

var active : bool = false: set = _set_active, get = _get_active

@onready var back_up_collision_layer = collision_layer
@onready var back_up_collision_mask = collision_mask

func _set_active(value: bool) -> void:
#	process_mode = Node.PROCESS_MODE_ALWAYS if value else Node.PROCESS_MODE_DISABLED
	collision_mask = 0 if not value else back_up_collision_mask
	collision_layer = 0 if not value else back_up_collision_layer
	active = value

func _get_active() -> bool:
	return active

func _ready() -> void:
	if health != null:
		health.died.connect(die)

func _physics_process(delta: float) -> void:
	if not active:
		return
	move_and_slide()


func set_movement(direction: Vector2):
	velocity = Vector3(direction.x, direction.y, 0.0) * speed


func shoot_weapon():
	if not active or weapon_handler == null:
		return
	weapon_handler.shoot()


func _on_child_entered_tree(node: Node) -> void:
	if node is WeaponHandler:
		weapon_handler = node as WeaponHandler
	if node is Health:
		health = node as Health

func die():
	pass
