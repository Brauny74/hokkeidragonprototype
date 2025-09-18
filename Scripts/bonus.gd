extends Area3D
class_name Bonus

enum BonusType
{POWER}

@export var type: BonusType
@export var value: int


func _on_body_entered(body: Node3D) -> void:
	if body is PlayerController:
		body.recieve_bonus(type, value)
		queue_free()


func _on_area_entered(area: Area3D) -> void:
	if area.get_parent() is PlayerController:
		area.get_parent().recieve_bonus(type, value)
		queue_free()
