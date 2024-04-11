extends Node3D

signal level_changed(level_name)

@export var level_name : String

func _change_level() -> void:
	SignalBus.level_changed.emit("level_changed", level_name)
