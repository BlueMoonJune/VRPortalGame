tool

extends Spatial


var progress = 0

# Called when the node enters the scene tree for the first time.
func _process(delta):
	if Engine.editor_hint:
		progress = progress+delta-floor(progress+delta)
		var mesh : MeshInstance = $MeshInstance
		var mat : ShaderMaterial = mesh.get_surface_material(0)
		mat.set_shader_param("Progress", progress)
