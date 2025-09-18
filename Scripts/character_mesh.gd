extends Node3D
class_name CharacterMesh

@export_group("Blinking")
@export var visible_time: float
@export var invisible_time: float

var is_blinking = true
var visible_timer: Timer
var invisible_timer: Timer
var full_timer: Timer

func _ready() -> void:
	visible_timer = create_timer(visible_time)
	invisible_timer = create_timer(invisible_time)
	full_timer = create_timer(visible_time + invisible_time, false)
	full_timer.timeout.connect(blink)

func create_timer(time: float, one_shot:bool = true) -> Timer:
	var timer = Timer.new()
	timer.wait_time = time
	timer.one_shot = one_shot
	add_child(timer)
	return timer

func start_blinking():
	full_timer.autostart = true
	full_timer.start()
	blink()

func blink():
	visible = false
	invisible_timer.start()
	
	await invisible_timer.timeout
	visible = true
	visible_timer.start()
	await visible_timer.timeout

func stop_blinking():
	visible = true
	full_timer.autostart = false
	full_timer.stop()
