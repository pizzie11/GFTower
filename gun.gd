extends Spatial



const GRID_OFFSET = 0.25

func _ready():
	#set up all of the raycasts
	for i in range(-1,2):
		for j in range (-1,2):
			var new_ray = Barrel.new()
			new_ray.setup(Vector3(i*10, j*10,100))
			add_child(new_ray)
			
func fire():
	for child in get_children():
		child.fire()
