extends StaticBody3D

@onready var effects_explosion = $EffectsExplosion
@onready var audio_stream_player_3d = $AudioStreamPlayer3D


# Called when the node enters the scene tree for the first time.
func _ready():
	effects_explosion.explode()
	audio_stream_player_3d.play()
	StatManager.kills += 1
	StatManager.num_enemies -= 1
	StatManager.update_stats()
	print("dead enemy get tree ", get_tree())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

