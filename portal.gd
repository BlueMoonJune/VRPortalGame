extends Spatial


export var camera_path : NodePath
onready var p_camera = get_node(camera_path)
export var portal_path : NodePath
onready var paired_portal = get_node(portal_path)
onready var s_camera : Camera = $Sprite3D/Viewport/Camera
onready var area = $Area

func _ready():
	print(get_path())
	print(p_camera.get_parent())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var portal_transform = self.global_transform.affine_inverse() * p_camera.global_transform
	var paired_portal_transform = paired_portal.global_transform * portal_transform
	s_camera.global_transform = paired_portal_transform

	if area.overlaps_body(p_camera.get_parent()):
		p_camera.get_parent().set_collision_mask_bit(4,false)
		p_camera.get_parent().set_collision_layer_bit(4,false)
		print(p_camera.get_parent().collision_mask)
	else:
		p_camera.get_parent().set_collision_mask_bit(4,true)
		p_camera.get_parent().set_collision_layer_bit(4,true)
		print(p_camera.get_parent().collision_mask)
