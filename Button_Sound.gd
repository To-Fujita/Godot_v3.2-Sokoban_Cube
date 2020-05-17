extends Button
# Select Sound Effect ON/OFF


var SoundFlag


func _ready():
	pass


#func _process(delta):
#	pass


func Button_Sound():
	SoundFlag = get_node("../../../../..").SoundFlag
	get_node("../Label_Sound").text = SoundFlag


func _on_Button_Sound_pressed():
	if SoundFlag == "ON":
		SoundFlag = "OFF"
	else:
		SoundFlag = "ON"
	get_node("../Label_Sound").text = SoundFlag
	get_node("../../../../..").SoundFlag = SoundFlag

