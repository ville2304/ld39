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
	
	var ls = LEVEL[0].strip_edges().split("\n")
	mWidth = ls[0].length()
	mHeight = ls.size()
	mData = IntArray()
	mData.resize(mWidth * mHeight)
	print(mData.size())
	
	mPlayerStarts = []
	for y in range(mHeight):
		for x in range(mWidth):
			var d = ls[y][x]
			if d == "1":
				mData[x + mWidth * y] = 1
				continue
			elif d == "p":
				d = 0
				mPlayerStarts.push_front(Vector2(x, y))
			elif d == "e":
				d = 0
				mPlayerStarts.push_back(Vector2(x, y))
			else:
				d = 0
			mData[x + mWidth * y] = d
			var d = q.duplicate()
			d.set_translation(Vector3(x, 0, y))
			add_child(d)
	


const LEVEL = [
"""
1111111111
1e001000p1
1000100001
1000100001
1000100001
1000000001
1000000001
1111011111
1e000000e1
1111111111
"""
]



