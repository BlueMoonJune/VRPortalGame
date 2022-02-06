extends KinematicBody

var camera : Camera
var velocity = Vector3.ZERO
var speed : float = 100
var accel : float = 200
var grav : float = 980

var rotate = 0
var rotatestep = 30

func _ready():
	camera = $ARVROrigin/ARVRCamera

func _physics_process(delta):
	if is_on_floor():
		var velxz : Vector2 = Vector2(velocity.x,velocity.z)
		velxz = velxz.move_toward(Vector2(
			Input.get_joy_axis(0,JOY_OPENVR_TOUCHPADX),
			-Input.get_joy_axis(0,JOY_OPENVR_TOUCHPADY)
			).rotated(-camera.rotation.y-rotation.y)*speed,accel*delta)
		velocity.x = velxz.x
		velocity.z = velxz.y
		velocity.y = -1
	else:
		velocity.y -= grav * delta
		
	var shouldrotate = sign(Input.get_joy_axis(1,JOY_OPENVR_TOUCHPADX))
	if shouldrotate != rotate:
		rotate_y(deg2rad(rotatestep)*-shouldrotate)
		rotate = shouldrotate
	
		
	move_and_slide(velocity * delta, Vector3.UP)
