extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var mouse_relative = Vector2(0,0)
var camera_angle = Vector3.ZERO
var velocity = Vector3.ZERO
var speed = 4

var sensitivity = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_and_slide(debugMove().rotated(Vector3.UP,rotation.y)*speed)

	$Camera.rotation_degrees.x = camera_angle.x
	self.rotation_degrees.y = camera_angle.y


func getInput():
	return [
		Input.is_action_just_pressed("blue-portal"),
		Input.is_action_just_pressed("orange-portal"),
		Input.is_action_just_pressed("teleport")
	]

func debugMove():
	return Vector3 (
		int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left")),
		0, int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	)

func _input(event):
	if event is InputEventMouseMotion:
		camera_angle -= Vector3(event.relative.y,event.relative.x,0) * sensitivity
		camera_angle.x = clamp(camera_angle.x,-90,90)
