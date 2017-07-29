extends Spatial


onready var mCamera = get_node("Camera")
onready var mNoise = get_node("TextureFrame")
onready var mNoise2 = get_node("TextureFrame1")
var mTimer = 0
var mTimer2 = 0
var mG2 = false
var mOrigTransform


func center(x, y, width, height):
	set_translation(Vector3(x, 0, y))


func glitch():
	mNoise.show()
	mNoise2.show()
	set_process(true)


func fix():
	mNoise.hide()
	mNoise2.hide()
	mCamera.set_transform(mOrigTransform)
	mCamera.set_perspective(30, .1, 100)
	set_process(false)


func _ready():
	mOrigTransform = mCamera.get_transform()
	set_process(false)


func _process(delta):
	mNoise.set_pos(Vector2(floor(rand_range(-81, 0)), floor(rand_range(-93, 0))))
	mNoise2.set_pos(Vector2(floor(rand_range(-128, 0)), floor(rand_range(-128, 0))))
	
	mTimer -= delta
	mTimer2 -= delta
	if mTimer <= 0:
		mTimer = rand_range(0.01, 3)
		mCamera.set_transform(mOrigTransform.translated(Vector3(rand_range(-2, 2), rand_range(-2, 2), rand_range(-2, 2))))
		mCamera.set_perspective(rand_range(5, 60), .1, 100)
	if mTimer2 <= 0:
		mG2 = !mG2
		if mG2:
			mTimer2 = rand_range(0.01, 1)
		else:
			mTimer2 = rand_range(0.1, 10)
		if randf() > 0.5:
			mCamera.set_perspective(rand_range(5, 60), .1, 100)
		else:
			mCamera.set_perspective(30, .1, 100)





