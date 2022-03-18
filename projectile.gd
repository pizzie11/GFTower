extends StaticBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var target = Vector3(0,0,0)
var move_vector = Vector3(0,0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	move_vector = target - translation
	move_vector = move_vector.normalized()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	translation = translation.linear_interpolate(translation + move_vector, 0.1)
