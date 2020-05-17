extends KinematicBody
# Player Move with Push Action


const Speed = 2
const GRAVITY = -9.8
const Cube_Chara = 4				# Quantity for Cube Chracter Data
var TileSize
var Temp
var JoystickVector
var MZ_x
var MZ_y
var MZ_z
var Block_size
var PlayerFlag
var Player
var Player_Body
var YM_ray
var XP_ray
var XM_ray
var ZP_ray
var ZM_ray
var XPF_ray
var XMF_ray
var ZPF_ray
var ZMF_ray
var Camera_vector_y
var Temp_Camera_x = 0
var Temp_Camera_y = 0
var Temp_Camera_r = 90
var Zoom_Min = 1.5
var Zoom_Max = 30
var Zoom_Speed = 0.05
var Camera_Angle = 10
var Rotation_Speed = 0.01
var Temp_XC
var Temp_ZC
var Temp_XP
var Temp_YP
var Temp_ZP
var Temp_RD
var Temp_XN = 0
var Temp_ZN = 0
var Temp_XR = 0
var Temp_ZR = 0
var Temp_vector
var Temp_delta = 0
var Temp_Count = 0
var On_ground_0 = true
var On_ground_1 = true
var On_ground_2 = true
var On_ground_3 = true
var On_ground_4 = true
var MoveFlag = 0
var PushFlag = 0
var MoveDirection = Vector3()
var L_Vector = Vector2(0, 0)
var R_Vector = Vector2(0, 0)
var Flag_X = 0
var Flag_Z = 0
var Temp_0
var Temp_1
var Temp_2
var MoveData
var Status
var Current_Position = Vector3()
var Last_Position = Vector3()
var Temp_DX = 0
var Temp_DY = 0
var Temp_DZ = 0
var Cube_Textures = []
var Texture_No = 0


func _ready():
	Player = self
	YM_ray = $RayCast_YM
	XP_ray = $RayCast_XP
	XM_ray = $RayCast_XM
	ZP_ray = $RayCast_ZP
	ZM_ray = $RayCast_ZM
	XPF_ray = $RayCast_XPF
	XMF_ray = $RayCast_XMF
	ZPF_ray = $RayCast_ZPF
	ZMF_ray = $RayCast_ZMF
	get_node("KinematicBody/AnimationPlayer").get_animation("Walk").loop = true
	get_node("KinematicBody/AnimationPlayer").get_animation("Push").loop = true
	get_node("KinematicBody/AnimationPlayer").get_animation("Stop").loop = false
	Camera_vector_y = int(get_node("Camera").get_global_transform().basis.y[0] * 180)
	MoveData = "S"
	MoveDirection = Vector3(0, 0, 0)
	TileSize = get_node("..").Block_size


func Init():
	PlayerFlag = get_node("../..").PlayerFlag
	for i in range(Cube_Chara):
		Cube_Textures.append([])
		for j in range(10):
			Cube_Textures[i].append([])
			Cube_Textures[i][j] =  SpatialMaterial.new()
	for i in range(Cube_Chara):
		var Temp_Cube = "res://images/Cube_A_10" + String(i)
		var Temp_Body = Temp_Cube + "/Body.png"
		var Temp_Head = Temp_Cube + "/Head.png"
		var Temp_Arm_L_1 = Temp_Cube + "/Arm_L_1.png"
		var Temp_Arm_L_2 = Temp_Cube + "/Arm_L_2.png"
		var Temp_Arm_R_1 = Temp_Cube + "/Arm_R_1.png"
		var Temp_Arm_R_2 = Temp_Cube + "/Arm_R_2.png"
		var Temp_Leg_L_1 = Temp_Cube + "/Leg_L_1.png"
		var Temp_Leg_L_2 = Temp_Cube + "/Leg_L_2.png"
		var Temp_Leg_R_1 = Temp_Cube + "/Leg_R_1.png"
		var Temp_Leg_R_2 = Temp_Cube + "/Leg_R_2.png"
		Cube_Textures[i][0].albedo_texture = load(Temp_Body)
		Cube_Textures[i][1].albedo_texture = load(Temp_Head)
		Cube_Textures[i][2].albedo_texture = load(Temp_Arm_L_1)
		Cube_Textures[i][3].albedo_texture = load(Temp_Arm_L_2)
		Cube_Textures[i][4].albedo_texture = load(Temp_Arm_R_1)
		Cube_Textures[i][5].albedo_texture = load(Temp_Arm_R_2)
		Cube_Textures[i][6].albedo_texture = load(Temp_Leg_L_1)
		Cube_Textures[i][7].albedo_texture = load(Temp_Leg_L_2)
		Cube_Textures[i][8].albedo_texture = load(Temp_Leg_R_1)
		Cube_Textures[i][9].albedo_texture = load(Temp_Leg_R_2)

	if PlayerFlag == "Clown":
		Texture_No = 1
	elif PlayerFlag == "Chaplin":
		Texture_No = 2
	elif PlayerFlag == "Girl":
		Texture_No = 3
	else:
		Texture_No = 0
	get_node("KinematicBody/MeshInstance_Body").set_surface_material(0, Cube_Textures[Texture_No][0])
	get_node("KinematicBody/MeshInstance_Body/MeshInstance_Head").set_surface_material(0, Cube_Textures[Texture_No][1])
	get_node("KinematicBody/MeshInstance_Body/MeshInstance_Arm_L1").set_surface_material(0, Cube_Textures[Texture_No][2])
	get_node("KinematicBody/MeshInstance_Body/MeshInstance_Arm_L1/MeshInstance_Arm_L2").set_surface_material(0, Cube_Textures[Texture_No][3])
	get_node("KinematicBody/MeshInstance_Body/MeshInstance_Arm_R1").set_surface_material(0, Cube_Textures[Texture_No][4])
	get_node("KinematicBody/MeshInstance_Body/MeshInstance_Arm_R1/MeshInstance_Arm_R2").set_surface_material(0, Cube_Textures[Texture_No][5])
	get_node("KinematicBody/MeshInstance_Body/MeshInstance_Leg_L1").set_surface_material(0, Cube_Textures[Texture_No][6])
	get_node("KinematicBody/MeshInstance_Body/MeshInstance_Leg_L1/MeshInstance_Leg_L2").set_surface_material(0, Cube_Textures[Texture_No][7])
	get_node("KinematicBody/MeshInstance_Body/MeshInstance_Leg_R1").set_surface_material(0, Cube_Textures[Texture_No][8])
	get_node("KinematicBody/MeshInstance_Body/MeshInstance_Leg_R1/MeshInstance_Leg_R2").set_surface_material(0, Cube_Textures[Texture_No][9])
	get_node("KinematicBody/AnimationPlayer").play("Stop")
	get_node("Camera").look_at_from_position(get_node("Camera").global_transform.origin, get_node(".").global_transform.origin, Vector3(0, 1, 0))
	Temp = get_node("..")
	PushFlag = 0
	MZ_x = Temp.MZ_x
	MZ_y = Temp.MZ_y
	MZ_z = Temp.MZ_z
	Block_size = Temp.Block_size
	MoveData = "S"
	Status = get_node("../..").Status
	Current_Position = get_node("..").Player.transform.origin
	Last_Position = Current_Position
	Player_Body = get_node("KinematicBody")
	get_node("KinematicBody/AnimationPlayer").play("Stop")


func Player_Move(vector):
	if Status == "Replay":
		return
	L_Vector = vector
	Temp_0 = asin($Camera.get_global_transform().basis.x[0] * 1) / PI * 180
#	Temp_1 = asin($Camera.get_global_transform().basis.x[1] * 1) / PI * 180
	Temp_2 = asin($Camera.get_global_transform().basis.x[2] * 1) / PI * 180
	
	if Temp_0 < -45 and Temp_2 < -45:
		vector.x = vector.x * 0
		vector.y = vector.y * 0
	elif Temp_0 < -45 and Temp_2 >= -45 and Temp_2 < 45:
		vector.x = vector.x * -1
		vector.y = vector.y * -1
	elif Temp_0 < -45 and Temp_2 < 45:
		vector.x = vector.x * 0
		vector.y = vector.y * 0
	elif Temp_0 >= -45 and Temp_0 < 45 and Temp_2 < -45:
		Temp_vector = vector.x
		vector.x = vector.y
		vector.y = Temp_vector * -1
	elif Temp_0 >= -45 and Temp_0 < 45 and Temp_2 >= -45 and Temp_2 < 45:
		vector.x = vector.x * 1
		vector.y = vector.y * 1
	elif Temp_0 >= -45 and Temp_0 < 45 and Temp_2 >= 45:
		Temp_vector = vector.x
		vector.x = vector.y * -1
		vector.y = Temp_vector
	elif Temp_0 >= 45 and Temp_2 < -45:
		vector.x = vector.x * -1
		vector.y = vector.y * -1
	elif Temp_0 >= 45 and Temp_2 >= -45 and Temp_2 < 45:
		vector.x = vector.x * 1
		vector.y = vector.y * 1
	else:
		vector.x = vector.x * 1
		vector.y = vector.y * 1
	
	if abs(vector.x) > abs(vector.y):
		Flag_X = 1
		Flag_Z = 0
		if vector.x > 0:
			JoystickVector = "R"
			MoveDirection = Vector3(Speed, 0, 0)
		elif vector.x < 0:
			JoystickVector = "L"
			MoveDirection = Vector3(-Speed, 0, 0)
	elif abs(vector.x) < abs(vector.y):
		Flag_X = 0
		Flag_Z = 1
		if vector.y > 0:
			JoystickVector = "B"
			MoveDirection = Vector3(0, 0, Speed)
		elif vector.y < 0:
			JoystickVector = "F"
			MoveDirection = Vector3(0, 0, -Speed)
	else:
		Flag_X = 0
		Flag_Z = 0
		JoystickVector = "S"
	
	if L_Vector.length() > 0:
		PushFlag = 0
		if XP_ray.is_colliding():
			if (XP_ray.get_collider().name.substr(0, 18) == "@KinematicBody_Wal" or XP_ray.get_collider().name.substr(0, 13) == "KinematicBody") and JoystickVector == "R":
				MoveDirection = Vector3(0, 0, 0)
			elif (XP_ray.get_collider().name.substr(0, 18) == "@KinematicBody_Box" or XP_ray.get_collider().name.substr(0, 18) == "@KinematicBody_Obs") and JoystickVector == "R":
				PushFlag = 1
				if XP_ray.get_collider().Stack_No >= 2:
					MoveDirection = Vector3(0, 0, 0)
				if XPF_ray.is_colliding():
					if XP_ray.get_collider().name != XPF_ray.get_collider().name and JoystickVector == "R":
						MoveDirection = Vector3(0, 0, 0)
		if XM_ray.is_colliding():
			if (XM_ray.get_collider().name.substr(0, 18) == "@KinematicBody_Wal" or XM_ray.get_collider().name.substr(0, 13) == "KinematicBody") and JoystickVector == "L":
				MoveDirection = Vector3(0, 0, 0)
			elif (XM_ray.get_collider().name.substr(0, 18) == "@KinematicBody_Box" or XM_ray.get_collider().name.substr(0, 18) == "@KinematicBody_Obs") and JoystickVector == "L":
				PushFlag = 1
				if XM_ray.get_collider().Stack_No >= 2:
					MoveDirection = Vector3(0, 0, 0)
				if XMF_ray.is_colliding():
					if XM_ray.get_collider().name != XMF_ray.get_collider().name and JoystickVector == "L":
						MoveDirection = Vector3(0, 0, 0)
		if ZP_ray.is_colliding():
			if (ZP_ray.get_collider().name.substr(0, 18) == "@KinematicBody_Wal" or ZP_ray.get_collider().name.substr(0, 13) == "KinematicBody") and JoystickVector == "B":
				MoveDirection = Vector3(0, 0, 0)
			elif (ZP_ray.get_collider().name.substr(0, 18) == "@KinematicBody_Box" or ZP_ray.get_collider().name.substr(0, 18) == "@KinematicBody_Obs") and JoystickVector == "B":
				PushFlag = 1
				if ZP_ray.get_collider().Stack_No >= 2:
					MoveDirection = Vector3(0, 0, 0)
				if ZPF_ray.is_colliding():
					if ZP_ray.get_collider().name != ZPF_ray.get_collider().name and JoystickVector == "B":
						MoveDirection = Vector3(0, 0, 0)
		if ZM_ray.is_colliding():
			if (ZM_ray.get_collider().name.substr(0, 18) == "@KinematicBody_Wal" or ZM_ray.get_collider().name.substr(0, 13) == "KinematicBody") and JoystickVector == "F":
				MoveDirection = Vector3(0, 0, 0)
			elif (ZM_ray.get_collider().name.substr(0, 18) == "@KinematicBody_Box" or ZM_ray.get_collider().name.substr(0, 18) == "@KinematicBody_Obs") and JoystickVector == "F":
				PushFlag = 1
				if ZM_ray.get_collider().Stack_No >= 2:
					MoveDirection = Vector3(0, 0, 0)
				if ZMF_ray.is_colliding():
					if ZM_ray.get_collider().name != ZMF_ray.get_collider().name and JoystickVector == "F":
						MoveDirection = Vector3(0, 0, 0)
		if PushFlag == 1:
			get_node("KinematicBody/AnimationPlayer").play("Push", -1, 1.5)
		else:
			get_node("KinematicBody/AnimationPlayer").play("Walk", -1, 1.5)
	else:
		get_node("KinematicBody/AnimationPlayer").play("Stop")
		MoveDirection = Vector3(0, 0, 0)


func _process(delta):
	if MZ_x == null:
		return
	Status = get_node("../..").Status
	Current_Position = Player.transform.origin
	if !YM_ray.is_colliding() and !On_ground_0 and !On_ground_1 and !On_ground_2 and !On_ground_3 and !On_ground_4:
		translation.y += GRAVITY * delta
	if Temp_delta > delta * 2:
		On_ground_4 = On_ground_3
		On_ground_3 = On_ground_2
		On_ground_2 = On_ground_1
		On_ground_1 = On_ground_0
		Temp_delta = 0
	On_ground_0 = YM_ray.is_colliding()
	Temp_delta = Temp_delta + delta
	if get_node(".").transform.origin.y < -20:
		get_node(".").transform.origin.y = -20
	if Status == "Replay":
		return
	if MoveFlag <= TileSize and MoveDirection != Vector3(0, 0, 0):
		Player_Body.rotation.y = atan2(MoveDirection.x, MoveDirection.z)
		Player.transform.origin = Player.transform.origin + Vector3(MoveDirection.x * delta, 0, MoveDirection.z * delta)
		MoveFlag = MoveFlag + delta * Speed
	else:
		Temp_DX = floor(Current_Position.x / TileSize) - floor(Last_Position.x / TileSize)
		Temp_DY = floor(Current_Position.y / TileSize) - floor(Last_Position.y / TileSize)
		Temp_DZ = floor(Current_Position.z / TileSize) - floor(Last_Position.z / TileSize)
		if Temp_DX != 0 or Temp_DZ != 0:
			MoveData = MoveData + JoystickVector
		if Temp_DY != 0:
			if Temp_DY > 0:
				MoveData = MoveData + "U"
			if Temp_DY < 0:
				MoveData = MoveData + "D"
		if PushFlag == 1:
			get_node("KinematicBody/AnimationPlayer").play("Push")
		else:
			get_node("KinematicBody/AnimationPlayer").play("Stop")
		MoveFlag = 0
		if JoystickVector == "R":
			Player_Body.rotation.y = atan2(1, 0)
		if JoystickVector == "L":
			Player_Body.rotation.y = atan2(-1, 0)
		if JoystickVector == "F":
			Player_Body.rotation.y = atan2(0, -1)
		if JoystickVector == "B":
			Player_Body.rotation.y = atan2(0, 1)
		MoveDirection = Vector3(0, 0, 0)
		var Temp_X = Player.transform.origin.x
		var Temp_Z = Player.transform.origin.z
		Player.transform.origin.x = floor(Temp_X / TileSize) * TileSize + TileSize / 2.0
		Player.transform.origin.z = floor(Temp_Z / TileSize) * TileSize + TileSize / 2.0
		Last_Position = Current_Position
	Player.transform.origin.x = clamp(Player.transform.origin.x, (Block_size / 2 + (2 - MZ_x / 2) * Block_size), (Block_size / 2 + (MZ_x + 1 - MZ_x / 2) * Block_size))
	Player.transform.origin.z = clamp(Player.transform.origin.z, (Block_size / 2 + (2 - MZ_z / 2) * Block_size), (Block_size / 2 + (MZ_z + 1 - MZ_z / 2) * Block_size))


func Camera_Move(vector):
	R_Vector = vector
	var Temp_Camera = get_node("Camera").get_camera_transform()
	if abs(vector.x) < abs(vector.y):										# Zoom In and Out
		Temp_Camera_x = vector.y * Camera_Angle * Zoom_Speed
		Temp_Camera_y = vector.y * Zoom_Speed
		if Temp_Camera.origin.y < Zoom_Min and vector.y < 0:
			Temp_Camera_x = 0
			Temp_Camera_y = 0
		if Temp_Camera.origin.y > Zoom_Max and vector.y > 0:
			Temp_Camera_x = 0
			Temp_Camera_y = 0
		get_node("Camera").translate(Vector3(0, Temp_Camera_y, Temp_Camera_x))
		get_node("Camera").look_at_from_position(get_node("Camera").global_transform.origin, get_node(".").global_transform.origin, Vector3(0, 1, 0))
	else:																	# Camera Rotation
		Temp_XP = get_node(".").global_transform.origin.x
		Temp_YP = get_node(".").global_transform.origin.y
		Temp_ZP = get_node(".").global_transform.origin.z
		Temp_XC = get_node("Camera").global_transform.origin.x
		Temp_ZC = get_node("Camera").global_transform.origin.z
		Temp_RD = sqrt(pow((Temp_XP - Temp_XC), 2) + pow((Temp_ZP - Temp_ZC), 2))
		var Temp_DIR_X = asin((Temp_XC - Temp_XP) / Temp_RD)
		var Temp_DIR_Z = asin((Temp_ZC - Temp_ZP) / Temp_RD)
		Temp_XN = Temp_RD * sin(Temp_DIR_X + vector.x * Rotation_Speed)
		Temp_ZN = Temp_RD * cos(Temp_DIR_X + vector.x * Rotation_Speed)
		if Temp_ZP > Temp_ZC:
			Temp_ZN = Temp_RD * sin(Temp_DIR_Z - vector.x * Rotation_Speed)
			Temp_XN = Temp_RD * cos(Temp_DIR_Z - vector.x * Rotation_Speed)
		if Temp_ZP > Temp_ZC and Temp_XP > Temp_XC:
			Temp_XN = Temp_RD * sin(Temp_DIR_X - vector.x * Rotation_Speed)
			Temp_ZN = Temp_RD * sin(Temp_DIR_Z + vector.x * Rotation_Speed)
		get_node("Camera").look_at_from_position(get_node("Camera").global_transform.origin, get_node(".").global_transform.origin, Vector3(0, 1, 0))
		get_node("Camera").global_transform.origin.x = Temp_XP + Temp_XN
		get_node("Camera").global_transform.origin.z = Temp_ZP + Temp_ZN

