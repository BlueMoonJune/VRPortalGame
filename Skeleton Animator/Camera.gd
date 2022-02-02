extends Camera

var sensitivity = 0.5

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _process(delta):
	
	var move : Vector2 = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	
	transform.origin += Vector3(move.x, 0, move.y).rotated(Vector3.RIGHT, rotation.x).rotated(Vector3.UP, rotation.y)
	
	
func _input(event):
	
	if event is InputEventMouseMotion:
		var motion = event.relative
		rotation_degrees.x = clamp(rotation_degrees.x - motion.y * sensitivity, -90, 90)
		rotation_degrees.y -= motion.x * sensitivity
