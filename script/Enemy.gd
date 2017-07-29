extends Spatial



func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func turn(command):
	command = round(rand_range(1, 4))
	
	if command == 1:
		translate(Vector3(0, 0, -1))
		get_parent().addWait(0.3)
	elif command == 2:
		translate(Vector3(0, 0, 1))
		get_parent().addWait(0.3)
	elif command == 3:
		translate(Vector3(-1, 0, 0))
		get_parent().addWait(0.3)
	elif command == 4:
		translate(Vector3(1, 0, 0))
		get_parent().addWait(0.3)
	
	return true
