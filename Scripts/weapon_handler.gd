extends Node3D
class_name WeaponHandler

var weapon: Weapon
@onready var update_sound := $UpgradeSound

signal upgraded

func shoot():
	if weapon != null:
		weapon.shoot()

func set_weapon(new_weapon: PackedScene):
	if weapon != null:
		weapon.queue_free()
	var inst_weapon = new_weapon.instantiate() as Weapon
	add_child(inst_weapon)

func receive_power_bonus(value: int):
	if weapon.upgrades_to != null:
		weapon.power_to_upgrade -= value
		if weapon.power_to_upgrade <= 0:
			set_weapon(weapon.upgrades_to)
			if update_sound != null:
				update_sound.play()
			upgraded.emit(weapon.power_to_upgrade)

func _on_child_entered_tree(node: Node) -> void:
	if node is Weapon:
		weapon = node as Weapon
