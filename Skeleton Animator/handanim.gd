extends Spatial

var skel : Skeleton
var time : float = 0
const VZERO : Vector3 = Vector3.ZERO
const VONE : Vector3 = Vector3(1,1,1)
var fingers : Array = [0,0,0,0]



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
	print(transf(VZERO,Vector3(45,0,45),VONE))
	skel = $Armature/Skeleton

func _process(delta):
   #lerp(-90,0,smoothstep(0,1,oscil(time)))

	fingers[0] -= Input.get_axis("indexup","indexdown") * delta
	fingers[1] -= Input.get_axis("middleup","middledown") * delta
	fingers[2] -= Input.get_axis("ringup","ringdown") * delta
	fingers[3] -= Input.get_axis("pinkyup","pinkydown") * delta

	time += delta 
	skel.set_bone_custom_pose(2,transf(VZERO,Vector3(lerp(-90,0,fingers[0]),0,0),VONE))
	skel.set_bone_custom_pose(6,transf(VZERO,Vector3(lerp(-90,0,fingers[1]),0,0),VONE))
	skel.set_bone_custom_pose(10,transf(VZERO,Vector3(lerp(-90,0,fingers[2]),0,0),VONE))
	skel.set_bone_custom_pose(14,transf(VZERO,Vector3(lerp(-90,0,fingers[3]),0,0),VONE))
	skel.set_bone_custom_pose(3,transf(VZERO,Vector3(lerp(-90,0,fingers[0]),0,0),VONE))
	skel.set_bone_custom_pose(7,transf(VZERO,Vector3(lerp(-90,0,fingers[1]),0,0),VONE))
	skel.set_bone_custom_pose(11,transf(VZERO,Vector3(lerp(-90,0,fingers[2]),0,0),VONE))
	skel.set_bone_custom_pose(15,transf(VZERO,Vector3(lerp(-90,0,fingers[3]),0,0),VONE))
	skel.set_bone_custom_pose(4,transf(VZERO,Vector3(lerp(-90,0,fingers[0]),0,0),VONE))
	skel.set_bone_custom_pose(8,transf(VZERO,Vector3(lerp(-90,0,fingers[1]),0,0),VONE))
	skel.set_bone_custom_pose(12,transf(VZERO,Vector3(lerp(-90,0,fingers[2]),0,0),VONE))
	skel.set_bone_custom_pose(16,transf(VZERO,Vector3(lerp(-90,0,fingers[3]),0,0),VONE))
