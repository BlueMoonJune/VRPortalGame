extends Spatial

export var path = "res://src/scenes/orange_portal_orb.tscn"
var scene : Spatial = null
var projectile : PackedScene
var controller : ARVRController
var pressed2 : bool = false
var prevpos : Vector3 = Vector3(0,0,0)

export var VR : bool = true

var skel : Skeleton
const VZERO : Vector3 = Vector3.ZERO
const VONE : Vector3 = Vector3(1,1,1)
var fingers : Array = [0,0,0,0,0]

const fingerbind : Array =      [ 0, 0, 1, 1, 1, 0, 2, 2, 2, 0, 2, 2, 2, 0, 2, 2, 2 ]
const secfingerbind : Array =   [ 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1 ]
const secfingerweight : Array = [ 0, 0, 0, 0, 0, 0,.3,.3,.2, 0,.2,.2,.1, 0,.1,.1, 0 ]

const fingersout : Array = [
	VZERO,
	VZERO,
	Vector3(-5,0,0),
	Vector3(-5,0,0),
	Vector3(-5,0,0),
	VZERO,
	Vector3(-6,0,0),
	Vector3(-6,0,0),
	Vector3(-6,0,0),
	VZERO,
	Vector3(-8,0,0),
	Vector3(-8,0,0),
	Vector3(-8,0,0),
	VZERO,
	Vector3(-6,0,6),
	Vector3(-6,0,0),
	Vector3(-6,0,0)
]
const fingerstouch : Array = [
	VZERO,
	VZERO,
	Vector3(-60,0,0),
	Vector3(-60,0,0),
	Vector3(-60,0,0),
	VZERO,
	Vector3(-60,0,0),
	Vector3(-60,0,0),
	Vector3(-60,0,0),
	VZERO,
	Vector3(-60,0,0),
	Vector3(-60,0,0),
	Vector3(-60,0,0),
	VZERO,
	Vector3(-60,0,0),
	Vector3(-60,0,0),
	Vector3(-60,0,0)
]
const fingersclench : Array = [
	VZERO,
	VZERO,
	Vector3(-90,0,0),
	Vector3(-90,0,0),
	Vector3(-90,0,0),
	VZERO,
	Vector3(-90,0,0),
	Vector3(-90,0,0),
	Vector3(-90,0,0),
	VZERO,
	Vector3(-90,0,0),
	Vector3(-90,0,0),
	Vector3(-90,0,0),
	VZERO,
	Vector3(-90,0,0),
	Vector3(-90,0,0),
	Vector3(-90,0,0)
]

func transf(t_position : Vector3, t_rotation : Vector3, t_scale : Vector3):
	
	var t_basis = Basis(Vector3(1,0,0),Vector3(0,1,0),Vector3(0,0,1)).scaled(t_scale).rotated(
		Vector3(0,0,1),deg2rad(t_rotation.z)).rotated(
		Vector3(1,0,0),deg2rad(t_rotation.x)).rotated(
		Vector3(0,1,0),deg2rad(t_rotation.y))
	
	return(Transform(t_basis,t_position))

func _ready():
	skel = $Armature/Skeleton
	print(skel)
	projectile = load(path)
	controller = get_parent()
	scene = controller.get_tree().root.get_child(0)

func _process(delta):
	if VR:
		var velocity : Vector3 = controller.global_transform.origin - prevpos
		if !controller.is_button_pressed(JOY_VR_TRIGGER) or Input.is_action_pressed("ui_accept"):
			if pressed2:
				print(velocity)
				var orb : RigidBody = projectile.instance()
				scene.add_child(orb)
				orb.global_transform = Transform(Basis(Vector3(1,0,0),Vector3(0,1,0),Vector3(0,0,1)),global_transform.origin)
				orb.linear_velocity = velocity / delta
				pressed2 = false
		else:
			pressed2 = true
		prevpos = controller.global_transform.origin
	else:
		if Input.is_mouse_button_pressed(controller.controller_id):
			if !pressed2:
				var orb : RigidBody = projectile.instance()
				scene.add_child(orb)
				orb.global_transform = Transform(Basis(Vector3(1,0,0),Vector3(0,1,0),Vector3(0,0,1)),global_transform.origin)
				orb.linear_velocity = -global_transform.basis.z * 5
			pressed2 = true
		else:
			pressed2 = false
	
	fingers[1] = move_toward(fingers[1],controller.is_button_pressed(11),delta*10)
	fingers[2] = controller.get_joystick_axis(JOY_VR_ANALOG_TRIGGER)
	fingers[3] = move_toward(fingers[3],controller.is_button_pressed(JOY_VR_GRIP),delta*10)
	fingers[4] = controller.get_joystick_axis(JOY_VR_ANALOG_GRIP)
	
	for i in range(0,skel.get_bone_count()-4):
		var bind = fingerbind[i]
		var secbind = secfingerbind[i]
		var weight = secfingerweight[i]
		
		var out = fingersout[i]
		var touch = fingerstouch[i]
		var clench = fingersclench[i]
		var val1 = max(fingers[bind*2-1],fingers[secbind*2-1]*weight)
		var pose = lerp(out,touch,val1)
		var val2 = fingers[bind*2]
		pose = lerp(pose,clench,val2)
		skel.set_bone_custom_pose(i,transf(VZERO,pose,VONE))
