extends Node

enum State{
	PRE,
	MOVE,
	POST
}

enum Command{
	NONE,
	NORTH,
	SOUTH,
	WEST,
	EAST
}



onready var mPlayers = get_children()
var mIterator
var mSubstep
var mSubstepCount
var mState
var mWait = 0
var mCommand = Command.NONE


func addWait(seconds):
	# Move state is fixed length
	if mState != State.MOVE:
		mWait = max(mWait, seconds)



func _ready():
	__setStatePre()
	set_process(true)


func _process(delta):
	if Input.is_key_pressed(KEY_UP):
		mCommand = Command.NORTH
	elif Input.is_key_pressed(KEY_DOWN):
		mCommand = Command.SOUTH
	elif Input.is_key_pressed(KEY_LEFT):
		mCommand = Command.WEST
	elif Input.is_key_pressed(KEY_RIGHT):
		mCommand = Command.EAST
	else:
		mCommand = Command.NONE
	
	
	
	if mWait > 0:
		mWait -= delta
	else:
		for p in mPlayers:
			if p.waitForInput(mCommand):
				return
		mCommand = Command.NONE
		
		if mState == State.PRE:
			prints("Pre", mSubstep)
			while true:
				# FIXME: If player has more than one substep, we need to get input
				if mSubstep >= mSubstepCount:
					__setStateMove()
					break
				mIterator += 1
				if mIterator >= mPlayers.size():
					mIterator = 0
					mSubstep += 1
				else:
					if mPlayers[mIterator].turnPre(mSubstep):
						# This player is going to do something. It should have sent its do-time.
						break
		
		if mState == State.MOVE:
			for substep in range(mSubstepCount):
				prints("Move", mSubstep)
				var deferrers = []
				for p in mPlayers:
					if p.turnMove(substep):
						deferrers.push_back(p)
				# FIXME: We should probably iterate this backwards
				for p in deferrers:
					p.turnMoveDeferred(substep)
			mWait = 1
			__setStatePost()
		
		if mState == State.POST:
			prints("Post", mSubstep)
			while true:
				if mSubstep >= mSubstepCount:
					__setStatePre()
					break
				mIterator += 1
				if mIterator >= mPlayers.size():
					mIterator = 0
					mSubstep += 1
				else:
					if mPlayers[mIterator].turnPost(mSubstep):
						# This player is going to do something. It should have sent its do-time.
						break


func __setStatePre():
	mIterator = -1
	mSubstep = 0
	mSubstepCount = 1
	mState = State.PRE


func __setStateMove():
	mIterator = -1
	mSubstep = 0
	mSubstepCount = 1
	mState = State.MOVE


func __setStatePost():
	mIterator = -1
	mSubstep = 0
	mSubstepCount = 1
	mState = State.POST

