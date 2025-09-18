extends Node3D

@onready var ui_manager: UIManager = $UILayer
@onready var player: PlayerController = $Player
@onready var moving_part: ConstantMovement = $MovingPart
@onready var activator: Activator = $Activator
@onready var boss: EnemyController = $MovingPart/Enemies/Boss

func _ready() -> void:
	randomize()
	ui_manager.init(player.health.MaxHealth, player.weapon_handler.weapon.power_to_upgrade)
	player.update_health.connect(ui_manager.health_bar.update)
	player.update_power_bonus.connect(ui_manager.power_bar.update)
	player.weapon_handler.upgraded.connect(ui_manager.power_bar.init)
	player.health.died.connect(ui_manager.show_game_over_screen)
	activator.stop.connect(stop_moving_part)
	boss.health.died.connect(ui_manager.show_victory_screen)

func stop_moving_part() -> void:
	moving_part.active = false
