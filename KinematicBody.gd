extends KinematicBody

var speed = 10
var h_acceleration = 6
var air_acceleration = 1
var normal_acceleration = 6
var gravity = 0
var jump = 10
var full_contact = false

var mouse_sensitivity = 0.03

var direction = Vector3()
var h_velocity = Vector3()
var movement = Vector3()
var gravity_vec = Vector3()

onready var head = $Head
onready var ground_check = $GroundCheck

func _ready():
	pass

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-89), deg2rad(89))
		
func _physics_process(delta):
	
	direction = Vector3()
	
	full_contact = ground_check.is_colliding()
	
	if not is_on_floor():
		gravity_vec += Vector3.DOWN * gravity * delta
		h_acceleration = air_acceleration
	elif is_on_floor() and full_contact:
		gravity_vec = -get_floor_normal() * gravity
		h_acceleration = normal_acceleration
	else:
		gravity_vec = -get_floor_normal()
		h_acceleration = normal_acceleration
		
#	if Input.is_action_just_pressed("jump") and (is_on_floor() or ground_check.is_colliding()):
#		gravity_vec = Vector3.UP * jump
	
	if Input.is_action_pressed("forward"):
		direction -= transform.basis.z
	elif Input.is_action_pressed("backward"):
		direction += transform.basis.z
	if Input.is_action_pressed("left"):
		direction -= transform.basis.x
	elif Input.is_action_pressed("right"):
		direction += transform.basis.x
	elif Input.is_action_pressed("e"):
		direction -= transform.basis.y
	elif Input.is_action_pressed("q"):
		direction += transform.basis.y
	
	
	move_and_slide(direction*speed, Vector3.UP)
	
	
	
	
	
	
	
	
	
	
	
	
	
	
