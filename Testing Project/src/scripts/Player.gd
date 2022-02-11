tool

extends KinematicBody

var camera : Camera
var collider : CapsuleShape
var velocity = Vector3.ZERO
var speed : float = 3
var accel : float = 12
var grav : float = 9.8

var sensitivity = 1

export var VR : bool = true

var rotate = 0
var rotatestep = 30

func _ready():
	camera = $ARVROrigin/ARVRCamera
	collider = $CollisionShape.shape
	if !VR:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	
	if !Engine.editor_hint:
		if is_on_floor():
			var velxz : Vector2 = Vector2(velocity.x,velocity.z)
			if VR:
				velxz = velxz.move_toward(Vector2(
					Input.get_joy_axis(0,JOY_OPENVR_TOUCHPADX),
					-Input.get_joy_axis(0,JOY_OPENVR_TOUCHPADY)
					).rotated(-camera.rotation.y-rotation.y)*speed,accel*delta)
			else:
				velxz = velxz.move_toward(Vector2(
					Input.get_axis("ui_left","ui_right"),
					Input.get_axis("ui_up","ui_down")
					).rotated(-camera.rotation.y-rotation.y)*speed,accel*delta)
			velocity.x = velxz.x
			velocity.z = velxz.y
			velocity.y = -1
			if Input.is_action_just_pressed("ui_accept"):
				velocity.y = 5
		else:
			velocity.y -= grav * delta
			
		if VR:
			var shouldrotate = sign(Input.get_joy_axis(1,JOY_OPENVR_TOUCHPADX))
			if shouldrotate != rotate:
				rotate_y(deg2rad(rotatestep)*-shouldrotate)
				rotate = shouldrotate
			
				
	else:
		camera = $ARVROrigin/ARVRCamera
		collider = $CollisionShape.shape
	
	collider.height = camera.transform.origin.y - collider.radius
	$CollisionShape.translation.y = collider.height/2 + collider.radius
	
		
	velocity = move_and_slide(velocity, Vector3.UP, true)

func _unhandled_input(event):
	if !VR:
		if event is InputEventMouseMotion:
			$ARVROrigin/ARVRCamera.rotation_degrees -= Vector3(event.relative.y, 0, 0) * sensitivity
			rotation_degrees -= Vector3(0, event.relative.x, 0) * sensitivity
