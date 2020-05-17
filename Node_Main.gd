extends Node
# Main Routine for Process Control


var StartFlag
var SoundFlag
var PlayerFlag
var ROOM_Max = 12
var Current_Room
var ROOM_Result = []
var ROOM_Replay = []
var path = "user://Sokoban_Cube.txt"
var Temp_Move
var Status
var MoveDirection = Vector3()
var MoveFlag = 0
var MoveCount = 0
var TileSize = 2
var Speed = 2
var Flag_X = 0
var Flag_Y = 0
var Flag_Z = 0


func _ready():
	SoundFlag = "OFF"
	PlayerFlag = "Pierrot"
	StartFlag = 0
	MoveFlag = 0
	Status = "Ready"
	get_node("Spatial").hide()
	get_node("Spatial/Label_Clear").hide()
	get_node("Spatial/Label_StageNo").hide()
	get_node("Spatial/Label_Time").hide()
	get_node("Spatial/Label_GameOver").hide()
	get_node("Spatial/Label_Results").hide()
	get_node("MenuButton").hide()
	get_node("Node_Menu/Control/MarginContainer1").hide()
	get_node("Spatial/MarginContainer_G").hide()
	get_node("Label_Replay").hide()
	for i in range(ROOM_Max):
		ROOM_Result.append([])
		ROOM_Result[i] = "A"
		ROOM_Replay.append([])
		ROOM_Replay[i] = "N"
	DATA_Load()
	get_node("Node_Menu/Control/VBoxContainer/HBoxContainer2/Button_Player").Button_Player()
	get_node("Node_Menu/Control/VBoxContainer/HBoxContainer3/Button_Sound").Button_Sound()
	Temp_Move = "S"


func NewGame(ROOM_NO):
	Current_Room = ROOM_NO
	Status = "NewGame"
	get_node("Node_Menu/Control/VBoxContainer").hide()
	get_node("Node_Menu/Control/MarginContainer1").hide()
	get_node("Spatial").show()
	get_node("Spatial/Label_Clear").hide()
	get_node("Spatial/Label_GameOver").hide()
	get_node("Spatial/Label_StageNo").show()
	get_node("Spatial/Label_Time").show()
	get_node("Spatial/Label_Results").show()
	get_node("MenuButton").show()
	get_node("Spatial/MarginContainer_G").show()
	get_node("Label_Replay").hide()
	get_node("Spatial").GameStart(Current_Room)
	get_node("Spatial/KinematicBody_Player").Init()


func NextGame():
	Status = "NextGame"
	get_node("Spatial").hide()
	get_node("Label_Replay").hide()
	get_node("Spatial").AllReset()
	Current_Room = Current_Room + 1
	if Current_Room >= ROOM_Max:
		Current_Room = 0
	NewGame(Current_Room)


func SameGame():
	Status = "SameGame"
	get_node("Spatial").hide()
	get_node("Label_Replay").hide()
	get_node("Spatial").AllReset()
	StartFlag = 0
	NewGame(Current_Room)


func _on_Button_Quit_pressed():
	get_tree().quit()


func _on_Button_Select_pressed():
	for i in range(ROOM_Max):
		if ROOM_Result[i] == "B":
			get_node("Node_Menu/Control/MarginContainer1/GridContainer/Button" + String(i)).add_color_override("font_color", Color(1, 1, 0, 1))
		if ROOM_Result[i] == "C":
			get_node("Node_Menu/Control/MarginContainer1/GridContainer/Button" + String(i)).add_color_override("font_color", Color(1, 0, 0, 1))
	get_node("Node_Menu/Control/VBoxContainer/HBoxContainer2").hide()
	get_node("Node_Menu/Control/VBoxContainer/HBoxContainer3").hide()
	get_node("Node_Menu/Control/VBoxContainer/Button_Select").hide()
	get_node("Node_Menu/Control/VBoxContainer/Button_Reset").hide()
	get_node("Node_Menu/Control/VBoxContainer/Button_Quit").hide()
	get_node("Node_Menu/Control/VBoxContainer/Label_Name").hide()
	get_node("Node_Menu/Control/MarginContainer1").show()


func DATA_Save():
	if Status == "Replay" or Status == "End":
		return
	if get_node("Spatial").End_flag == 1 and get_node("Spatial").Start_flag == 1:
		if get_node("Spatial/KinematicBody_Player").MoveData.length() > 1:
			ROOM_Replay[Current_Room] = get_node("Spatial/KinematicBody_Player").MoveData
	var Temp_Result = ROOM_Result[0]
	var Temp_Replay = ROOM_Replay[0]
	for i in range(1, ROOM_Max):
		Temp_Result = Temp_Result + ROOM_Result[i]
		Temp_Replay = Temp_Replay + "," + ROOM_Replay[i]
	var SaveData = {"Player": PlayerFlag, "Sound": SoundFlag, "Result": Temp_Result, "Replay": Temp_Replay}
	var f = File.new()
	f.open(path, File.WRITE)
	f.store_var(SaveData)
	f.close()
	

func DATA_Load():
#	DATA_Save()								# for Create New Project
	var Temp_Result
	var Temp_Replay
	var LoadData = {}
	var f = File.new()
	if f.file_exists(path):
		f.open(path, File.READ)
		LoadData = f.get_var()
		f.close()
		PlayerFlag = LoadData["Player"]
		SoundFlag = LoadData["Sound"]
		Temp_Result = LoadData["Result"]
		Temp_Replay = LoadData["Replay"]
	for i in range(ROOM_Max):
		ROOM_Result[i] = Temp_Result.substr(i, 1)
	ROOM_Replay = Temp_Replay.split(",", true)
	if not f.file_exists(path):
		DATA_Save()


func _on_Button_Reset_pressed():
	get_node("WindowDialog_Reset").show()


func _on_Button_ResetOK_pressed():
	get_node("WindowDialog_Reset").hide()
	SoundFlag = "OFF"
	PlayerFlag = "Pierrot"
	for i in range(ROOM_Max):
		ROOM_Result[i] = "A"
		ROOM_Replay[i] = "NA" + String(i)
	DATA_Save()
	get_node("Node_Menu/Control/VBoxContainer/HBoxContainer2/Button_Player").Button_Player()
	get_node("Node_Menu/Control/VBoxContainer/HBoxContainer3/Button_Sound").Button_Sound()


func Replay():
	Status = "Replay"
	MoveFlag = 0
	get_node("Label_Replay").show()


func _process(delta):
	if Status != "Replay":
		return
	if Status == "Replay":
		if MoveCount >= TileSize - delta:
			MoveCount = 0
			MoveFlag = MoveFlag + 1
			Temp_Move = "S"
			var X = get_node("Spatial/KinematicBody_Player").transform.origin.x
			get_node("Spatial/KinematicBody_Player/KinematicBody/AnimationPlayer").play("Push")
			get_node("Spatial/KinematicBody_Player").transform.origin.x = floor(X / TileSize) * TileSize + TileSize / 2.0
		else:
			MoveCount = MoveCount + delta * Speed
			Temp_Move = ROOM_Replay[Current_Room].substr(MoveFlag, 1)
			if Temp_Move == "F":
				MoveDirection = Vector3(0, 0, -Speed)
				get_node("Spatial/KinematicBody_Player").L_Vector = Vector2(-1, 0)
				get_node("Spatial/KinematicBody_Player").JoystickVector = "F"
				Flag_X = 0
				Flag_Y = 0
				Flag_Z = 1
			elif Temp_Move == "B":
				MoveDirection = Vector3(0, 0, Speed)
				get_node("Spatial/KinematicBody_Player").L_Vector = Vector2(1, 0)
				get_node("Spatial/KinematicBody_Player").JoystickVector = "B"
				Flag_X = 0
				Flag_Y = 0
				Flag_Z = 1
			elif Temp_Move == "R":
				MoveDirection = Vector3(Speed, 0, 0)
				get_node("Spatial/KinematicBody_Player").L_Vector = Vector2(0, 1)
				get_node("Spatial/KinematicBody_Player").JoystickVector = "R"
				Flag_X = 1
				Flag_Y = 0
				Flag_Z = 0
			elif Temp_Move == "L":
				MoveDirection = Vector3(-Speed, 0, 0)
				get_node("Spatial/KinematicBody_Player").L_Vector = Vector2(0, -1)
				get_node("Spatial/KinematicBody_Player").JoystickVector = "L"
				Flag_X = 1
				Flag_Y = 0
				Flag_Z = 0
			elif Temp_Move == "U":
				MoveDirection = Vector3(0, 0, 0)
				get_node("Spatial/KinematicBody_Player").JoystickVector = "U"
				Flag_X = 0
				Flag_Y = 1
				Flag_Z = 0
			elif Temp_Move == "D":
				MoveDirection = Vector3(0, -9.8, 0)
				get_node("Spatial/KinematicBody_Player").JoystickVector = "D"
				Flag_X = 0
				Flag_Y = -1
				Flag_Z = 0
			else:
				MoveDirection = Vector3(0, 0, 0)
				get_node("Spatial/KinematicBody_Player").JoystickVector = "S"
			get_node("Spatial/KinematicBody_Player").transform.origin = get_node("Spatial/KinematicBody_Player").transform.origin + Vector3(MoveDirection.x * delta, 0, MoveDirection.z * delta)
#			get_node("Spatial/KinematicBody_Player/KinematicBody").rotation.y = atan2(MoveDirection.x, MoveDirection.z)
			if get_node("Spatial/KinematicBody_Player").JoystickVector == "R":
				get_node("Spatial/KinematicBody_Player/KinematicBody").rotation.y = atan2(1, 0)
			if get_node("Spatial/KinematicBody_Player").JoystickVector == "L":
				get_node("Spatial/KinematicBody_Player/KinematicBody").rotation.y = atan2(-1, 0)
			if get_node("Spatial/KinematicBody_Player").JoystickVector == "F":
				get_node("Spatial/KinematicBody_Player/KinematicBody").rotation.y = atan2(0, -1)
			if get_node("Spatial/KinematicBody_Player").JoystickVector == "B":
				get_node("Spatial/KinematicBody_Player/KinematicBody").rotation.y = atan2(0, 1)
		if MoveFlag > ROOM_Replay[Current_Room].length():
			get_node("Spatial/KinematicBody_Player/KinematicBody/AnimationPlayer").play("Stop")
			Status = "End"

