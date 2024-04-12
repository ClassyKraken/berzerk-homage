extends CSGBox3D

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalBus.connect("open_secret", open_secret)
	self.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func open_secret() -> void:
	self.visible = true
