extends SplashScreenSlide


@onready var godotSprite = $VBoxContainer/MarginContainer/Control/GodotAnimatedSprite
@onready var lightFlikceringSound = $LightFlickerSound


func _ready():
	lightFlikceringSound.play()
	godotSprite.play("default")

func _on_GodotAnimatedSprite_animation_finished():
	#emit_signal("finished")
	pass

func _on_ChangeSceneTimer_timeout():
	pass
	# this is called upon completion fo the bootup
	# You should add a get_tree().change_scene() to your title screen
