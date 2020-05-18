extends Spatial
# Main Game Program with Box + Goal Combunation


var MZ_x
var MZ_y
var MZ_z
var ROOM_Max
var Block_size = 2
var Goal_Result
var Start_flag
var End_flag
var Goal_flag
var SoundFlag
var ROOM = []
var Box = []
var Box_Count
var Ground = []
var Ground_Count
var Floor = []
var Floor_Count
var Goal = []
var Goal_Count
var Lift = []
var Lift_Count
var Obstacle = []
var Obstacle_Count
var Wall = []
var Wall_Count
var Start_Point
var Current_ROOM
var Start_time
var Temp
var Temp_Result
var Temp_Count = 0
var Box_org = load("res://KinematicBody_Box.tscn")
var Ground_org = load("res://KinematicBody_Ground.tscn")
var Floor_org = load("res://KinematicBody_Floor.tscn")
var Goal_org = load("res://KinematicBody_Goal.tscn")
var Lift_org = load("res://Area_Lift.tscn")
var Obstacle_org = load("res://KinematicBody_Obstacle.tscn")
var Wall_org = load("res://KinematicBody_Wall.tscn")
var Player
var CameraMove = Vector2(0, 0)
var PlayerMove = Vector2(0, 0)


func _ready():
	ROOM_Max = get_node("Node_Stage").room_max
	Box_Count = 0
	Ground_Count = 0
	Floor_Count = 0
	Goal_Count = 0
	Lift_Count = 0
	Obstacle_Count = 0
	Wall_Count = 0
	Goal_Result = 0
	Start_flag = 0
	self.hide()


func GameStart(ROOM_NO):
	var Temp_ROOM = []
	if ROOM_NO > ROOM_Max:
		ROOM_NO = ROOM_Max
	Player = get_node("KinematicBody_Player")
	Start_flag = 1
	self.show()
	End_flag = 0
	Goal_flag = 0
	Goal_Count = 0
	Goal_Result = 0
	Box_Count = 0
	Obstacle_Count = 0
	Current_ROOM = ROOM_NO
	if get_node("..").ROOM_Result[Current_ROOM] != "C":
		get_node("..").ROOM_Result[Current_ROOM] = "B"
		get_node("..").DATA_Save()
	Start_time = OS.get_ticks_msec()
	get_node("Label_StageNo").text = "Stage No.: " + String(Current_ROOM) 
	Temp = get_node("Node_Stage")
	ROOM = Temp.room[Current_ROOM]
	MZ_y = ROOM.size()
	MZ_x = ROOM[0].size()
	MZ_z = ROOM[0][0].length()

	for y in range(MZ_y + 4):
		Temp_ROOM.append([])
		Temp_ROOM[y] = []
		for x in range(MZ_x + 4):
			Temp_ROOM[y].append([])
			for z in range(MZ_z + 4):
				Temp_ROOM[y][x].append([])
				if (y == 2 and (x < 2 or z < 2)) or (y == 2 and (x >= MZ_x + 2 or z >= MZ_z + 2)):
					Temp_ROOM[y][x][z] = "S"
				elif y < 2:
					Temp_ROOM[y][x][z] = "S"
				elif y >= MZ_y + 2:
					Temp_ROOM[y][x][z] = "S"
				elif x < 2:
					Temp_ROOM[y][x][z] = "S"
				elif x >= MZ_x + 2:
					Temp_ROOM[y][x][z] = "S"
				elif z < 2:
					Temp_ROOM[y][x][z] = "S"
				elif z >= MZ_z + 2:
					Temp_ROOM[y][x][z] = "S"
				else:
					Temp_ROOM[y][x][z] = ROOM[y - 2][x - 2].substr((z - 2), 1)
	
	for i in range(MZ_y + 4):
		for j in range(MZ_x + 4):
			for k in range(MZ_z + 4):
				if i == 2 and Temp_ROOM[i][j][k] == "S":
					Ground.append([])
					Ground[Ground_Count] = Ground_org.instance()
					add_child(Ground[Ground_Count])
					Ground[Ground_Count].transform.origin.x = Block_size / 2 + (j - MZ_x / 2) * Block_size
					Ground[Ground_Count].transform.origin.y = Block_size / 2 + (i - MZ_y / 2 - 2) * Block_size - 0.1
					Ground[Ground_Count].transform.origin.z = Block_size / 2 + (k - MZ_z / 2) * Block_size
					Ground_Count = Ground_Count + 1
				if Temp_ROOM[i][j][k] == "F":
					Floor.append([])
					Floor[Floor_Count] = Floor_org.instance()
					add_child(Floor[Floor_Count])
					Floor[Floor_Count].transform.origin.x = Block_size / 2 + (j - MZ_x / 2) * Block_size
					Floor[Floor_Count].transform.origin.y = Block_size / 2 + (i - MZ_y / 2 - 2) * Block_size - 0.1
					Floor[Floor_Count].transform.origin.z = Block_size / 2 + (k - MZ_z / 2) * Block_size
					Floor_Count = Floor_Count + 1
				if Temp_ROOM[i][j][k] == "B":
					if i == 2:
						Floor.append([])
						Floor[Floor_Count] = Floor_org.instance()
						add_child(Floor[Floor_Count])
						Floor[Floor_Count].transform.origin.x = Block_size / 2 + (j - MZ_x / 2) * Block_size
						Floor[Floor_Count].transform.origin.y = Block_size / 2 + (i - MZ_y / 2 - 2) * Block_size - 0.1
						Floor[Floor_Count].transform.origin.z = Block_size / 2 + (k - MZ_z / 2) * Block_size
						Floor_Count = Floor_Count + 1
					Box.append([])
					Box[Box_Count] = Box_org.instance()
					add_child(Box[Box_Count])
					Box[Box_Count].set_scale(Vector3(0.95, 1.0, 0.95))
					Box[Box_Count].transform.origin.x = Block_size / 2 + (j - MZ_x / 2) * Block_size
					Box[Box_Count].transform.origin.y = Block_size / 2 + (i - MZ_y / 2 - 2) * Block_size + 1
					Box[Box_Count].transform.origin.z = Block_size / 2 + (k - MZ_z / 2) * Block_size
					Box_Count = Box_Count + 1
				if Temp_ROOM[i][j][k] == "G":
					Goal.append([])
					Goal[Goal_Count] = Goal_org.instance()
					add_child(Goal[Goal_Count])
					Goal[Goal_Count].transform.origin.x = Block_size / 2 + (j - MZ_x / 2) * Block_size
					Goal[Goal_Count].transform.origin.y = Block_size / 2 + (i - MZ_y / 2 - 2) * Block_size - 0.1
					Goal[Goal_Count].transform.origin.z = Block_size / 2 + (k - MZ_z / 2) * Block_size
					Goal_Count = Goal_Count + 1
				if Temp_ROOM[i][j][k] == "L":
					Lift.append([])
					Lift[Lift_Count] = Lift_org.instance()
					add_child(Lift[Lift_Count])
					Lift[Lift_Count].transform.origin.x = Block_size / 2 + (j - MZ_x / 2) * Block_size
					Lift[Lift_Count].transform.origin.y = Block_size / 2 + (i - MZ_y / 2 - 2) * Block_size - 0.9
					Lift[Lift_Count].transform.origin.z = Block_size / 2 + (k - MZ_z / 2) * Block_size
					Lift_Count = Lift_Count + 1
				if Temp_ROOM[i][j][k] == "W":
					Wall.append([])
					Wall[Wall_Count] = Wall_org.instance()
					add_child(Wall[Wall_Count])
					Wall[Wall_Count].transform.origin.x = Block_size / 2 + (j - MZ_x / 2) * Block_size
					Wall[Wall_Count].transform.origin.y = Block_size / 2 + (i - MZ_y / 2 - 2) * Block_size + 1
					Wall[Wall_Count].transform.origin.z = Block_size / 2 + (k - MZ_z / 2) * Block_size
					Wall_Count = Wall_Count + 1
				if Temp_ROOM[i][j][k] == "P":
					if i == 2:
						Floor.append([])
						Floor[Floor_Count] = Floor_org.instance()
						add_child(Floor[Floor_Count])
						Floor[Floor_Count].transform.origin.x = Block_size / 2 + (j - MZ_x / 2) * Block_size
						Floor[Floor_Count].transform.origin.y = Block_size / 2 + (i - MZ_y / 2 - 2) * Block_size - 0.1
						Floor[Floor_Count].transform.origin.z = Block_size / 2 + (k - MZ_z / 2) * Block_size
						Floor_Count = Floor_Count + 1
					Player.set_scale(Vector3(0.4, 0.4, 0.4))
					Player.transform.origin.x = Block_size / 2 + (j - MZ_x / 2) * Block_size
					Player.transform.origin.y = Block_size / 2 + (i - MZ_y / 2 - 2) * Block_size + 1.4
					Player.transform.origin.z = Block_size / 2 + (k - MZ_z / 2) * Block_size
				if Temp_ROOM[i][j][k] == "C":
					Box.append([])
					Box[Box_Count] = Box_org.instance()
					add_child(Box[Box_Count])
					Box[Box_Count].set_scale(Vector3(0.95, 1.0, 0.95))
					Box[Box_Count].transform.origin.x = Block_size / 2 + (j - MZ_x / 2) * Block_size
					Box[Box_Count].transform.origin.y = Block_size / 2 + (i - MZ_y / 2 - 2) * Block_size + 1
					Box[Box_Count].transform.origin.z = Block_size / 2 + (k - MZ_z / 2) * Block_size
					Box_Count = Box_Count + 1
					Goal.append([])
					Goal[Goal_Count] = Goal_org.instance()
					add_child(Goal[Goal_Count])
					Goal[Goal_Count].transform.origin.x = Block_size / 2 + (j - MZ_x / 2) * Block_size
					Goal[Goal_Count].transform.origin.y = Block_size / 2 + (i - MZ_y / 2 - 2) * Block_size - 0.1
					Goal[Goal_Count].transform.origin.z = Block_size / 2 + (k - MZ_z / 2) * Block_size
					Goal_Count = Goal_Count + 1
				if Temp_ROOM[i][j][k] == "D":
					Obstacle.append([])
					Obstacle[Obstacle_Count] = Obstacle_org.instance()
					add_child(Obstacle[Obstacle_Count])
					Obstacle[Obstacle_Count].set_scale(Vector3(0.95, 1.0, 0.95))
					Obstacle[Obstacle_Count].transform.origin.x = Block_size / 2 + (j - MZ_x / 2) * Block_size
					Obstacle[Obstacle_Count].transform.origin.y = Block_size / 2 + (i - MZ_y / 2 - 2) * Block_size + 1
					Obstacle[Obstacle_Count].transform.origin.z = Block_size / 2 + (k - MZ_z / 2) * Block_size
					Obstacle_Count = Obstacle_Count + 1
					Goal.append([])
					Goal[Goal_Count] = Goal_org.instance()
					add_child(Goal[Goal_Count])
					Goal[Goal_Count].transform.origin.x = Block_size / 2 + (j - MZ_x / 2) * Block_size
					Goal[Goal_Count].transform.origin.y = Block_size / 2 + (i - MZ_y / 2 - 2) * Block_size - 0.1
					Goal[Goal_Count].transform.origin.z = Block_size / 2 + (k - MZ_z / 2) * Block_size
					Goal_Count = Goal_Count + 1
				if Temp_ROOM[i][j][k] == "O":
					if i == 2:
						Floor.append([])
						Floor[Floor_Count] = Floor_org.instance()
						add_child(Floor[Floor_Count])
						Floor[Floor_Count].transform.origin.x = Block_size / 2 + (j - MZ_x / 2) * Block_size
						Floor[Floor_Count].transform.origin.y = Block_size / 2 + (i - MZ_y / 2 - 2) * Block_size - 0.1
						Floor[Floor_Count].transform.origin.z = Block_size / 2 + (k - MZ_z / 2) * Block_size
						Floor_Count = Floor_Count + 1
					Obstacle.append([])
					Obstacle[Obstacle_Count] = Obstacle_org.instance()
					add_child(Obstacle[Obstacle_Count])
					Obstacle[Obstacle_Count].set_scale(Vector3(0.95, 1.0, 0.95))
					Obstacle[Obstacle_Count].transform.origin.x = Block_size / 2 + (j - MZ_x / 2) * Block_size
					Obstacle[Obstacle_Count].transform.origin.y = Block_size / 2 + (i - MZ_y / 2 - 2) * Block_size + 1
					Obstacle[Obstacle_Count].transform.origin.z = Block_size / 2 + (k - MZ_z / 2) * Block_size
					Obstacle_Count = Obstacle_Count + 1


func _process(delta):
	if Start_flag <= 0:
		Start_time = 0
		return
	Goal_Result = 0
	for i in range(Box_Count):
		Goal_Result = Goal_Result +Box[i].GoalFlag
	if End_flag == 0:
		var temp_time = OS.get_ticks_msec()
		var elapsed_time  = (temp_time - Start_time) / 1000
		get_node("Label_Time").text = "Time(Sec): " + String(elapsed_time)
		get_node("Label_Results").text = "Results: " + String(Goal_Result) + " / " + String(Goal_Count)
	elif Start_flag == 1:
		SoundFlag = get_node("..").SoundFlag
		get_node("Label_Clear").show()
		get_node("Label_Clear/AnimationPlayer").play("StageClear")
		get_node("KinematicBody_Player/KinematicBody/AnimationPlayer").play("Stop")
		get_node("KinematicBody_Player").PushFlag = 0
		if get_node("..").Status != "Replay":
			get_node("..").ROOM_Result[Current_ROOM] = "C"
			get_node("..").DATA_Save()
		if SoundFlag == "ON" and Goal_flag == 0:
			var Goal_sound = AudioStreamPlayer.new()
			self.add_child(Goal_sound)
			Goal_sound.stream = load("res://sound/stageclear_01.ogg")
			Goal_sound.stream.loop = bool(0)
			Goal_sound.play()
			Goal_flag = 1
		Start_flag = 2
	if Goal_Result >= 1 and Goal_Result >= Goal_Count:
		if Temp_Count >= 1:
			End_flag = 1
		else:
			Temp_Count = Temp_Count + delta
	else:
		End_flag = 0
	if CameraMove != Vector2(0, 0):
		Player.Camera_Move(CameraMove)
	if PlayerMove != Vector2(0, 0):
		Player.Player_Move(PlayerMove)
		PlayerMove = Vector2(0, 0)


func AllReset():
	if Box_Count > 0:
		for i in range(Box_Count):
			remove_child(Box[i])
	if Ground_Count > 0:
		for i in range(Ground_Count):
			remove_child(Ground[i])
	if Floor_Count > 0:
		for i in range(Floor_Count):
			remove_child(Floor[i])
	if Wall_Count > 0:
		for i in range(Wall_Count):
			remove_child(Wall[i])
	if Goal_Count > 0:
		for i in range(Goal_Count):
			remove_child(Goal[i])
	if Lift_Count > 0:
		for i in range(Lift_Count):
			remove_child(Lift[i])
	if Obstacle_Count > 0:
		for i in range(Obstacle_Count):
			remove_child(Obstacle[i])
	Box_Count = 0
	Ground_Count = 0
	Floor_Count = 0
	Wall_Count = 0
	Goal_Count = 0
	Lift_Count = 0
	Obstacle_Count = 0


func _on_UP_pressed():
	if get_node("KinematicBody_Player").MoveFlag == 0:
		PlayerMove = Vector2(0, -1)


func _on_DOWN_pressed():
	if get_node("KinematicBody_Player").MoveFlag == 0:
		PlayerMove = Vector2(0, 1)


func _on_LEFT_pressed():
	if get_node("KinematicBody_Player").MoveFlag == 0:
		PlayerMove = Vector2(-1, 0)


func _on_RIGHT_pressed():
	if get_node("KinematicBody_Player").MoveFlag == 0:
		PlayerMove = Vector2(1, 0)


func _on_PLUS_button_down():
	CameraMove = Vector2(0, -1)


func _on_PLUS_button_up():
	CameraMove = Vector2(0, 0)


func _on_MINUS_button_down():
	if CameraMove.y == 0:
		CameraMove = Vector2(0, 1)


func _on_MINUS_button_up():
	CameraMove = Vector2(0, 0)


func _on_ROLL_L_button_down():
	CameraMove = Vector2(-1, 0)


func _on_ROLL_L_button_up():
	CameraMove = Vector2(0, 0)


func _on_ROLL_R_button_down():
	if CameraMove.x == 0:
		CameraMove = Vector2(1, 0)


func _on_ROLL_R_button_up():
	CameraMove = Vector2(0, 0)

