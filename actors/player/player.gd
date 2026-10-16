extends CharacterBody3D


@export var normal_speed := 3.0
@export var sprint_speed := 5.0
@export var jump_velocity := 4.0
@export var gravity := 0.2
@export var mouse_sensitivity := 0.005

@onready var head: Node3D = $Head


func _ready() -> void:
	'''
	hide the cursor while in-game
	'''
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	# see intellisense for other mouse modes


func _physics_process(delta: float) -> void:
	move()


func move() -> void:
	'''
	MOVEMENT HANDLING
	handle sprinting: check whether player is on floor. if so, do sprint action when sprint key is held
	handle velocity and direction: calculate both from variables and vector3 function
	'''
	
	var is_sprinting : bool
	
	if is_on_floor():
		is_sprinting = Input.is_action_pressed("sprint")
		if Input.is_action_just_pressed("jump"): # this code keeps us from flying by holding space
			velocity.y = jump_velocity
	else:
		velocity.y -= gravity
		is_sprinting = false
	
	'''
	ALTERNATIVE, LONGER SPEED CODE
	var speed : float
	if is_sprinting:
		speed = sprint_speed
	else:
		speed = normal_speed
	'''
	var speed = normal_speed if not is_sprinting else sprint_speed # speed is normal if sprinting check returns false. otherwise (sprinting check is true), speed is sprint speed
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := transform.basis * Vector3(input_dir.x, 0, input_dir.y)
	
	velocity.z = direction.z * speed
	velocity.x = direction.x * speed
	
	move_and_slide()


func _input(event: InputEvent) -> void:
	'''
	check if input is a mouse movement. if true, move mouse using look_around()
	'''
	if event is InputEventMouseMotion:
		look_around(event.relative) # hold ctrl and click to learn about things


func look_around(relative : Vector2) -> void:
	'''
	calculate degree to which camera rotates on y and x
	'''
	rotate_y(-relative.x * mouse_sensitivity)
	head.rotate_x(-relative.y * mouse_sensitivity)
	head.rotation_degrees.x = clampf(head.rotation_degrees.x, -90, 90) # clamps look angle


func _unhandled_key_input(event: InputEvent) -> void:
	'''
	if esc pressed, make the mouse visible
	'''
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
