class_name Player
extends KinematicBody
var cameraAngle = 0
var mouseSensitivity = 0.3
var keyboardsensitivity = 0.3
var flySpeed = 10
var flyAccel = 40
var velocity = Vector3()
var detectedObject
var ID : String = "Player"
var aim : Basis

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
#	print(translation.round())
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
		print(OS.window_size)
	

	if Input.is_action_just_pressed("KEY_ESC"):
		get_tree().quit()
		
	if Input.is_key_pressed(KEY_O):
		Engine.time_scale = clamp(Engine.time_scale+0.02,0,2)
		print("Engine.time_scale: ", Engine.time_scale)
	elif Input.is_key_pressed(KEY_P):
		Engine.time_scale = clamp(Engine.time_scale-0.02,0,1)
		print("Engine.time_scale: ", Engine.time_scale)
	if Input.is_key_pressed(KEY_J):
		var vport = get_viewport()
		if vport == null:
			print_debug("couldn't capture")
		else:
			var image = vport.get_texture().get_data()  #get the image
			image.flip_y() # flips the image
			var err = image.save_png("res://saves/capturedImage.png") #save the image
			if err:
				print_debug(err)

func _physics_process(delta):
	aim = $Yaxis/Camera.get_camera_transform().basis
	
	var direction = Vector3()
	if Input.is_key_pressed(KEY_W):
		direction -= aim.z
	if Input.is_key_pressed(KEY_S):
		direction += aim.z
	if Input.is_key_pressed(KEY_A):
		direction -= aim.x
	if Input.is_key_pressed(KEY_D):
		direction += aim.x
	if Input.is_key_pressed(KEY_SPACE):
		direction += aim.y
	if Input.is_key_pressed(KEY_CONTROL):
		direction -= aim.y
	if Input.is_key_pressed(KEY_SHIFT):
		flySpeed = 40
	else:
		flySpeed = 10 
	direction = direction.normalized()
	var target = direction * flySpeed
	velocity = velocity.linear_interpolate(target, flyAccel * delta)
	move_and_slide(velocity)
	
func _input(event):
	if event is InputEventMouseMotion:  # cam movement
		$Yaxis.rotate_y(deg2rad(-event.relative.x * mouseSensitivity))
		
		var change = -event.relative.y * mouseSensitivity
		if change + cameraAngle < 90 and change + cameraAngle > -90:
			$Yaxis/Camera.rotate_x(deg2rad(change))
			cameraAngle += change
