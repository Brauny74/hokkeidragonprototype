extends Node
class_name Health

@export var MaxHealth: int = 100
var CurrentHealth: int

@export var invicibility_frame: float = 0.0

var is_invincible = false

signal died
signal damaged
signal frame_ended

func _ready() -> void:
	CurrentHealth = MaxHealth

func damage(value: int):
	if is_invincible:
		return
	CurrentHealth -= value
	damaged.emit()
	if CurrentHealth <= 0:
		die()
	is_invincible = true
	await get_tree().create_timer(invicibility_frame).timeout
	is_invincible = false
	frame_ended.emit()

func die():
	died.emit()
