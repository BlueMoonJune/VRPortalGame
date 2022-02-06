extends RigidBody

var shrinking : bool = false
var size : float = 1

func _ready():
	contact_monitor = true
	contacts_reported = 1

func _process(delta):
	if shrinking:
		size -= delta
		scale = Vector3(size,size,size)
		if size <= 0:
			queue_free()
			
func _on_Portal_Orb_body_entered(body):
	$CPUParticles.emitting = true
	shrinking = true
	gravity_scale = 0
