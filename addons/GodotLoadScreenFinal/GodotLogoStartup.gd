extends AnimatedSprite2D


@onready var particle_emitter = $ParticleEmitter

func ready():
	pass


func _on_frame_changed():
	if self.frame == 8:
		var children = particle_emitter.get_children()
		for child in children:
			child.emitting = true
