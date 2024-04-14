extends Node3D

@onready var menu_light = $DirectionalLight3D
@onready var stats_label = $CSGBox3D/BottomRightLable/StatsLabel

var light_rotation_deg = 45
var rotation_time = 2



# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("update_stat_display", update_stat_display)
	print("connected")
	light_swing()
	update_stat_display()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	rotation_time += delta * 0.4


func light_swing() -> void:
	pass




func update_stat_display():
	var total_kills = StatManager.total_kills
	var total_secrets = StatManager.total_secrets
	var total_stats = (str("Kills: ", total_kills, "\nSecrets Found: ", total_secrets))
	stats_label.text = total_stats
	print("new stats here")
