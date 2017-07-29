extends Spatial


onready var mCamera = get_node("Camera")
var mTimer = 0
var mOrigTransform


func center(x, y, width, height):
	set_translation(Vector3(x, 0, y))


func glitch():
	set_process(true)


func fix():
	mCamera.set_transform(mOrigTransform)
	set_process(false)


func _ready():
	mOrigTransform = mCamera.get_transform()
	set_process(false)


func _process(delta):
	mTimer -= delta
	if mTimer <= 0:
		mTimer = rand_range(0.01, 3)
		mCamera.set_transform(mOrigTransform.translated(Vector3(rand_range(-3, 3), rand_range(-3, 3), rand_range(-3, 3))))





