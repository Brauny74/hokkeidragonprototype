extends Controller3D
class_name EnemyController

enum MoveType {
	STRAIGHT, 
	CURVE
}

@export var direction: Vector2
@export var death_time: float
@export var bonuses_to_drop: Array[PackedScene]
@export var damage_on_touch: int

@export_category("Curve")
@export var movement: MoveType
@onready var y_dir: float = direction.y
var cur_y: float = 0.0
var is_moving_up: bool = false
@export var curve_speed: float = 0.1

var death_timer: Timer

func _ready() -> void:
	super._ready()
	death_timer = Timer.new()
	add_child(death_timer)
	death_timer.autostart = false
	death_timer.wait_time = death_time
	death_timer.timeout.connect(finish_die)

func _process(delta: float) -> void:
	if not active:
		return
	if weapon_handler != null:
		weapon_handler.shoot()

func _physics_process(delta: float) -> void:
	set_movement(direction)
	super._physics_process(delta)

func set_movement(direction: Vector2):	
	if movement == MoveType.CURVE:
		cur_y += curve_speed if is_moving_up else -curve_speed
		if cur_y < -y_dir or cur_y > y_dir:
			is_moving_up = not is_moving_up
		direction.y = cur_y
	super.set_movement(direction)

func damage(value: float):
	if not active:
		return
	health.damage(value)

#func process_collision():
	#var col_info: KinematicCollision3D
	#var other
	#if health == null:
		#return
	#for i in range(get_slide_collision_count()):
		#col_info = get_slide_collision(i)
		#other = col_info.get_collider()
		#if other is Projectile3D:
			#if health != null:
				#health.damage((other as Projectile3D).damage)
				#print(self.name + ": " + str(health.CurrentHealth))

func die():
	if len(bonuses_to_drop) > 0:
		var bonus_index = randi_range(0, len(bonuses_to_drop) - 1)
		var new_bonus = bonuses_to_drop[bonus_index].instantiate()
		get_parent().add_child(new_bonus)
		new_bonus.global_position = global_position
	#TODO: rebuild this for better VFX system
	$Mesh.visible = false
	$DeathVFX.restart()
	$DeathVFX.visible = true
	$DeathVFX.emitting = true
	$DeathSound.pitch_scale = randf_range(0.8, 1.5)
	$DeathSound.play()
	print($DeathSound.playing)
	active = false
	death_timer.start()

func finish_die():
	queue_free()
