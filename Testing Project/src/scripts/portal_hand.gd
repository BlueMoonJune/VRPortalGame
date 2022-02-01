extends Spatial


export var path = "res://src/scenes/orange_portal_orb.tscn"
var scene : Spatial = null
var projectile : PackedScene
var controller : ARVRController
var pressed2 : bool = false
var prevpos : Vector3 = Vector3(0,0,0)

func _ready():
	projectile = load(path)
	controller = get_parent()
	scene = controller.get_tree().root.get_child(0)

func _process(delta):
	var velocity : Vector3 = controller.global_transform.origin - prevpos
	if controller.is_button_pressed(2) or Input.is_action_pressed("ui_accept"):
		if !pressed2:
			print(velocity)
			var orb : RigidBody = projectile.instance()
			scene.add_child(orb)
			orb.global_transform = Transform(Basis(Vector3(1,0,0),Vector3(0,1,0),Vector3(0,0,1)),global_transform.origin)
			orb.linear_velocity = velocity / delta
			pressed2 = true
	else:
		pressed2 = false
	prevpos = controller.global_transform.origin
