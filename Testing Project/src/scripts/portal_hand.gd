extends Spatial


export var path = "res://src/projectiles/orange_portal_orb.tscn"
var scene : Spatial = null
var projectile
var controller : ARVRController
var pressed2 : bool = false

func _ready():
	projectile = load(path)
	controller = get_parent()
	scene = controller.get_tree().root.get_child(0)

func _process(delta):
	if controller.is_button_pressed(2) or Input.is_action_pressed("ui_accept"):
		if !pressed2:
			var orb : RigidBody = projectile.instance()
			orb.linear_velocity = global_transform.basis.z * -10.0
			scene.add_child(orb)
			orb.global_transform = Transform(Basis(Vector3(1,0,0),Vector3(0,1,0),Vector3(0,0,1)),global_transform.origin)
			pressed2 = true
	else:
		pressed2 = false
