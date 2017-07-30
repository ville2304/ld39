extends Panel

var mTimer1 = 1
var mFlag1 = false

func _ready():
	set_process(true)


func _process(delta):
	if mTimer1 > 0:
		mTimer1 -= delta
		if mTimer1 <= 0:
			mFlag1 = !mFlag1
			if mFlag1:
				get_node("Header").set_text("Low power mode.")
				mTimer1 = 1
			else:
				get_node("Header").set_text("Low power mode")
				mTimer1 = .5
	



func _on_Button_pressed():
	get_node("../GM").resetLevel(0)
	set_process(false)
	hide()
