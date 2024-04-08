extends Weapon

const AMMO_WATER = preload("res://scenes/weapons/ammo_water.tscn")



@onready var gun_rays = $GunRays

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("weapon_action", weapon_action)
	#self.hide()


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
		var new_dart = AMMO_WATER.instantiate()
		gun_rays.add_child(new_dart)
		new_dart.global_transform = muzzle


func ready_to_act():
	can_act = true
	weapon_sprite.play("idle")
