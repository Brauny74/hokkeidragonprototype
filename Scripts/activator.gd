extends Area3D
class_name Activator

signal stop

func _on_body_entered(body: Node3D) -> void:
	if body is EnemyController:
		body.active = true
	elif body is Projectile3D:
		body.queue_free()


func _on_area_entered(area: Area3D) -> void:
	if area is Stopper:
		stop.emit()
