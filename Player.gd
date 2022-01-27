extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var mouse_relative = Vector2(0,0)
var camera_angle = Vector3.ZERO
var velocity = Vector3.ZERO

var sensitivity = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	$Camera.rotation_degrees = camera_angle
	


func getInput():
	return [
		Input.is_action_just_pressed("blue-portal"),
		Input.is_action_just_pressed("orange-portal"),
		Input.is_action_just_pressed("teleport")
	]

func _input(event):
	if event is InputEventMouseMotion:
		camera_angle -= Vector3(event.relative.y,event.relative.x,0) * sensitivity
		camera_angle.x = clamp(camera_angle.x,-90,90)
