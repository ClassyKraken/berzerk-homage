class_name Weapon
extends Node3D

enum Type {INTERACT, SHOOT}

@export var weapon_name: String
@export var type: Type 

@onready var weapon_sprite = $CanvasLayer/Control/WeaponSprite

var can_act = true
