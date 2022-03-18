class_name Barrel
extends RayCast

var hit_indicator = preload("res://debug_hit.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const SPREAD = 40
const DAMAGE = 1
var default_cast

func setup(vec3):
	set_cast_to(vec3)
	default_cast = vec3
	set_enabled(true)
	set_collision_mask_bit(0, false)
	set_collision_mask_bit(1, true)

func fire():
	#random bullet spread
	var offset = Vector3((randf()*SPREAD)-(SPREAD/2), (randf()*SPREAD)-(SPREAD/2), 100)
	print(offset)
	set_cast_to(get_cast_to() + offset)
	force_raycast_update()
	var hit_instance = hit_indicator.instance()
	if get_collider() is Spatial:
		hit_instance.translation = get_collider().to_local(get_collision_point())
		get_collider().add_child(hit_instance)
	if get_collider() is Enemy:
		#Send damage and player node
		get_collider().hit(DAMAGE, get_parent().get_parent().get_parent())
	set_cast_to(default_cast)
