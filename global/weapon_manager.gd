extends Node


signal weapon_changed(new_weapon)


@onready var inventory = $PlayerHand/Inventory


const PLAYER = preload("res://scenes/player/player.tscn")

var weapons: Array = []
var weapon_switch = 0
var current_weapon = null

func _ready() -> void:
	SignalBus.connect("interacting", interacting)
	SignalBus.connect("add_gun_nerf", add_to_inventory)
	#SignalBus.connect("interaction_stopped", interaction_stopped)
	weapons = inventory.get_children()
	print("weapon inventory ", weapons)
	current_weapon = weapons[0]
	print("current weapon ", current_weapon)


func _process(delta):
	pass


func interacting():
	pass


func _on_timer_button_press_timeout():
	var weapons_avail = weapons.size() - 1
	weapon_switch += 1
	if weapon_switch > weapons_avail:
		weapon_switch = 0
	switch_weapon(weapon_switch)


func switch_weapon(weapon_switch):
	var weapon_request = weapons[weapon_switch]
	if current_weapon == weapon_request:
		print("no weapon to switch to")
		return
	
	current_weapon.hide()
	print("hide ", current_weapon)
	current_weapon = weapon_request
	current_weapon.show()
	print("show ", current_weapon)
	
	print("switched to ", current_weapon)


func add_to_inventory():
	print("add to inv")
	weapons = inventory.get_children()
	

