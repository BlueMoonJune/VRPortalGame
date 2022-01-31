extends RigidBody

onready var col : Area = $CollisionDetect
var shrinking : bool = false
var size : float = 1

# Called when the node enters the scene tree for the first time.
func _process(delta):
	if len(col.get_overlapping_bodies()) > 1:
		$CPUParticles.emitting = true
		shrinking = true
	if shrinking:
		size -= delta
		scale = Vector3(size,size,size)
		if size <= 0:
			queue_free()
