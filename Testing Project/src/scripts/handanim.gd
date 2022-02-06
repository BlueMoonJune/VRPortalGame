extends Spatial

var skel : Skeleton
var time : float = 0
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
	
	#zxy
	


func oscil(t : float):
	return abs(fmod(t,2)-1)

func _ready():
	skel = $Armature/Skeleton

func _process(delta):
   #lerp(0,-90,smoothstep(0,1,oscil(time)))

	fingers[1] = move_toward(fingers[1],int(Input.is_action_pressed("indexclose")),delta*10)
	fingers[2] = Input.get_action_strength("indexclench")
	fingers[3] = move_toward(fingers[3],int(Input.is_action_pressed("middleclose")),delta*10)
	fingers[4] = Input.get_action_strength("middleclench")
	
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
