extends Spatial


var scene = load("res://src/scenes/blue_portal_orb.tscn")


# Called when the node enters the scene tree for the first time.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		var orb : RigidBody = scene.instance()
		orb.linear_velocity = global_transform.basis.z * -2.0
		add_child(orb)
		orb.global_transform = Transform(Basis(Vector3(1,0,0),Vector3(0,1,0),Vector3(0,0,1)),global_transform.origin)
