extends Node3D
class_name Weapon

@export var shoot_points: Array[Vector3]
@export var projectiles: Array[PackedScene]
@export var cooldown: float = 0.0
var can_shoot = true

@export var upgrades_to: PackedScene
@export var power_to_upgrade: int

func shoot():
	if can_shoot:
		can_shoot = false
		for projectile in projectiles:
			var new_projectile = projectile.instantiate() as Projectile3D
			get_tree().current_scene.add_child(new_projectile)
			if len(shoot_points) > 0:
				new_projectile.global_position = shoot_points[randi_range(0, len(shoot_points) - 1)] + self.global_position
			else:
				new_projectile.position = self.global_position
			new_projectile.active = true
		await get_tree().create_timer(cooldown).timeout
		can_shoot = true
