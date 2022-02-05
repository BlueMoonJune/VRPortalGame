extends Spatial


export var camera_path : NodePath
onready var p_camera = get_node(camera_path)
export var portal_path : NodePath
onready var paired_portal = get_node(portal_path)
onready var s_camera : Camera = $Sprite3D/Viewport/Camera
onready var area : Area = $Area
onready var ray : RayCast = $RayCast
onready var baseCol : CollisionShape = $CollisionShape3
var teleported : float = 0

export var material : ShaderMaterial 

var tracked_bodies : Dictionary = {}

func _ready():
	material.set_shader_param("Texture Uniform", $Sprite3D/Viewport.get_texture())
	$Sprite3D.set_material_override(material)
	print(get_path())
	print(p_camera.get_parent())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var portal_transform = global_transform.affine_inverse() * p_camera.global_transform
	var paired_portal_transform = paired_portal.global_transform * portal_transform.rotated(Vector3.UP,PI)
	s_camera.global_transform = paired_portal_transform
	
	if ray.is_colliding():
		baseCol.scale.z = 0.5
	else:
		baseCol.scale.z = 0.1
		
	for body in tracked_bodies.keys():
		
		if !(body in area.get_overlapping_bodies()):
			body.set_collision_layer_bit(0,true)
			body.set_collision_mask_bit(0,true)
			print(body, " exited ", self)
			tracked_bodies.erase(body)
			break
			
		var newdot = sign((body.transform.origin - transform.origin).dot(transform.basis.z))
		if tracked_bodies[body] != newdot and teleported <= 0:
			
			portal_transform = global_transform.affine_inverse() * body.global_transform
			paired_portal_transform = paired_portal.global_transform * portal_transform#.rotated(Vector3.UP,PI)
			body.transform = paired_portal_transform
			
			print(body, " passed through portal ", self)
			
			tracked_bodies.erase(body)
			teleported = 1
			paired_portal.teleported = 1
			print(teleported)
			
		elif teleported > 0:
			
			teleported -= delta
			print(teleported)
			
		tracked_bodies[body] = newdot

func _on_Area_body_entered(body : PhysicsBody):
	body.set_collision_layer_bit(0,false)
	body.set_collision_mask_bit(0,false)
	print(body, " entered ", self)
	tracked_bodies[body] = sign((body.transform.origin - transform.origin).dot(transform.basis.z))
