extends Node

const TILE_FLOOR = preload("res://tiles/floor.scn")
const TILE_WALL = preload("res://tiles/wall.scn")


var mWidth
var mHeight
var mData
var mPlayerStarts
var mGoal
var mPower


func getPlayerStarts():
	return mPlayerStarts

func getGoal():
	return mGoal

func getPower():
	return mPower


func isWalkable(cell):
	if cell.x < 0 || cell.y < 0 || cell.x >= mWidth || cell.y >= mHeight:
		return false
	return (mData[cell.x + mWidth * cell.y] == 0)


func reset():
	for i in get_children():
		remove_child(i)
	mData = null
	mPlayerStarts = null
	mWidth = 0
	mHeight = 0


func getCenter():
	return [mWidth / 2.0, mHeight / 2.0, mWidth, mHeight]


func loadLevel(l):
	reset()
	
	if l >= LEVEL.size():
		l = l % LEVEL.size()
	
	mPower = LEVEL[l]["power"]
	var ls = LEVEL[l]["data"].strip_edges().split("\n")
	mWidth = ls[0].length()
	mHeight = ls.size()
	mData = IntArray()
	mData.resize(mWidth * mHeight)
	
	mPlayerStarts = []
	for y in range(mHeight):
		for x in range(mWidth):
			var d = ls[y][x]
			if d == "1":
				mData[x + mWidth * y] = 1
				var d = TILE_WALL.instance()
				d.set_translation(Vector3(x, 0, y))
				add_child(d)
				continue
			elif d == "p":
				d = 0
				mPlayerStarts.push_front(Vector2(x, y))
			elif d == "e":
				d = 0
				mPlayerStarts.push_back(Vector2(x, y))
			elif d == "g":
				d = 0
				mGoal = Vector2(x, y)
			else:
				d = 0
			mData[x + mWidth * y] = d
			var d = TILE_FLOOR.instance()
			d.set_translation(Vector3(x, 0, y))
			add_child(d)


const LEVEL = [
{"power":32,
"data":
"""
1g1
001
101
101
00p
"""
},
{"power":50,
"data":
"""
1e01
0110
1110
1101
1011
g00p
"""
},
{"power":500,
"data":
"""
1111111111
1e001g00p1
1000100001
1000100001
1000100001
1000000001
1000000001
1111011111
1e000000e1
1111111111
"""
},
{"power":100,
"data":
"""
1111111111
10001000p1
1000100001
1000100001
1000100001
1000g00001
1000000001
1111011111
1e100000e1
1111111111
"""
}
]



