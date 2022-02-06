extends ARVROrigin

# Future proofing.
const XRServer = ARVRServer

func _ready():
	var arvr_interface = ARVRServer.find_interface("OpenVR")
	if arvr_interface and arvr_interface.initialize():
		var viewport = get_viewport()
		viewport.arvr = true
		viewport.hdr = false
		OS.set_window_maximized(true)
		OS.vsync_enabled = false
		Engine.target_fps = 180
		
func _process(delta):
	var campos = $ARVRCamera.transform.origin
	transform.origin = -Vector3(campos.x,0,campos.z)
