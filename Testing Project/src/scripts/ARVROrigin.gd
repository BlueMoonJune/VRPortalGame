extends ARVROrigin


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var arvr_interface = ARVRServer.find_interface("OpenVR")
	if arvr_interface and arvr_interface.initialize():
		var viewport = get_viewport()
		viewport.arvr = true
		viewport.hdr = false
		OS.set_window_maximized(true)
		OS.vsync_enabled = false
		Engine.target_fps = 180


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
