extends Controller3D
class_name PlayerController

@onready var mesh: CharacterMesh = $Mesh

var constraint_border_size: Vector2i
var is_invincible: bool

signal init
signal update_health
signal update_power_bonus

func _ready() -> void:
	super._ready()
	is_invincible = false
	health.damaged.connect(damage)
	active = true
	calculate_border()
	var power := 0
	if weapon_handler.weapon != null:
		power = weapon_handler.weapon.power_to_upgrade

func _process(delta: float) -> void:
	process_input()


func calculate_border():
	var viewport_size = get_viewport().size
	constraint_border_size = viewport_size / 33


func process_input():
	var input_vector = Input.get_vector("left", "right", "down", "up")
	set_movement(input_vector)
	calculate_border()
	self.global_position.x = clamp(self.global_position.x, -constraint_border_size.x, constraint_border_size.x)
	self.global_position.y = clamp(self.global_position.y, -constraint_border_size.y, constraint_border_size.y)
	
	if Input.is_action_pressed("attack"):
		shoot_weapon()

func recieve_bonus(bonus_type: Bonus.BonusType, value: int) -> void:
	if bonus_type == Bonus.BonusType.POWER:
		weapon_handler.receive_power_bonus(value)
		update_power_bonus.emit(weapon_handler.weapon.power_to_upgrade)
		$BonusSound.play()


func damage(value: float):	
	health.damage(value)
	update_health.emit(health.CurrentHealth)
	mesh.start_blinking()
	await health.frame_ended
	mesh.stop_blinking()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is EnemyController:
		damage(body.damage_on_touch)
	elif body is Projectile3D:
		damage(body.damage)
