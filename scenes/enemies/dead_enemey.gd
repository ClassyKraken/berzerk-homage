extends StaticBody3D

@onready var effects_explosion = $EffectsExplosion

# Called when the node enters the scene tree for the first time.
func _ready():
	effects_explosion.explode()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
