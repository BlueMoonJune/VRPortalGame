extends Spatial


var scene = load("res://src/scenes/orange_portal_orb.tscn")
var controller : ARVRController

func _ready():
	controller = get_parent()


# Called when the node enters the scene tree for the first time.
func _process(delta):
	if controller.is_button_pressed(2):
		var orb : RigidBody = scene.instance()
		orb.linear_velocity = global_transform.basis.z * -10.0
		add_child(orb)
		orb.global_transform = Transform(Basis(Vector3(1,0,0),Vector3(0,1,0),Vector3(0,0,1)),global_transform.origin)
