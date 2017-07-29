extends Node

var mWidth
var mHeight
var mData
var mPlayerStarts


func getPlayerStarts():
	return mPlayerStarts


func isWalkable(cell):
	if cell.x < 0 || cell.y < 0 || cell.x >= mWidth || cell.y >= mHeight:
		return false
	return (mData[cell.x + mWidth * cell.y] == 0)


func _ready():
	var q = Quad.new()
	q.set_size(Vector2(.95, .95))
	q.set_axis(1)
	q.set_offset(Vector2(0.5, 0.5))
	q.set_name("asd")
	
	mWidth = 10
	mHeight = 10
	
	mData = IntArray()
	mData.resize(mWidth * mHeight)
	for i in range(mWidth * mHeight):
		mData[i] = 0
	for i in range(mWidth):
		mData[i] = 1
		mData[i + mWidth * (mHeight - 1)] = 1
	for i in range(mHeight):
		mData[mWidth * i] = 1
		mData[mWidth - 1 + mWidth * i] = 1
	mData[5 + mWidth * 5] = 1
	mData[2 + mWidth * 2] = 9000
	mData[8 + mWidth * 8] = 9001
	mData[2 + mWidth * 8] = 9001
	
	mPlayerStarts = []
	for y in range(mHeight):
		for x in range(mWidth):
			var d = mData[x + mWidth * y]
			if d == 1:
				continue
			elif d >= 9000:
				mData[x + mWidth * y] = 0
				mPlayerStarts.push_back(Vector2(x, y))
			var d = q.duplicate()
			d.set_translation(Vector3(x, 0, y))
			add_child(d)
	
	