extends Weapon

@onready var gun_rays = $GunRays

# Called when the node enters the scene tree for the first time.
func _ready():
	print("readying hand")
	SignalBus.connect("weapon_action", weapon_action)
	SignalBus.connect("interaction_started", interaction_started)
	SignalBus.connect("interaction_stopped", interaction_stopped)
	SignalBus.connect("interaction_complete", interaction_stopped)
	self.hide()
	print("hand ready")


func hide_weapon():
	var children = self.get_children()
	for child in children:
		child.hide()


func show_weapon():
	var children = self.get_children()
	for child in children:
		child.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func weapon_action(muzzle):
	if can_act == true:
		can_act = false
		weapon_sprite.play("action")
		weapon_sprite.animation_finished.connect(ready_to_act)


func ready_to_act():
	can_act = true
	weapon_sprite.play("walking")


func interaction_started():
	weapon_sprite.play("action-loop")


func interaction_stopped():
	weapon_sprite.play("walking")
