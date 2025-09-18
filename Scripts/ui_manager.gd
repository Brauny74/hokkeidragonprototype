extends CanvasLayer
class_name UIManager

var health_bar: ConnectedProgressBar
var power_bar: ConnectedProgressBar

@onready var game_over_screen = $GameOverScreen
@onready var victory_screen = $VictoryScreen

func _ready() -> void:
	health_bar = find_child("HealthBar") as ConnectedProgressBar
	power_bar = find_child("PowerBar") as ConnectedProgressBar
	game_over_screen.visible = false
	victory_screen.visible = false

func init(health: int, power_bonus: int):
	health_bar.init(health, health)
	power_bar.init(power_bonus, power_bonus)

func show_game_over_screen():
	game_over_screen.visible = true

func show_victory_screen():
	victory_screen.visible = true

func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()


func _on_quit_button_pressed() -> void:
	get_tree().quit()
