extends Button
# Player Select


var PlayerFlag


func _ready():
	pass


#func _process(delta):
#	pass


func Button_Player():
	PlayerFlag = get_node("../../../../..").PlayerFlag
	get_node("../Label_Player").text = PlayerFlag


func _on_Button_Player_pressed():
	if PlayerFlag == "Clown":
		PlayerFlag = "Pierrot"
	elif PlayerFlag == "Pierrot":
		PlayerFlag = "Chaplin"
	elif PlayerFlag == "Chaplin":
		PlayerFlag = "Girl"
	else:
		PlayerFlag = "Clown"
	get_node("../Label_Player").text = PlayerFlag
	get_node("../../../../..").PlayerFlag = PlayerFlag

