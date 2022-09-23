# &quot;move_right&quot;, &quot;move_left&quot; and &quot;move_up&quot; are defined in project setting/input map

# the node that we'll use is kinematic body 2d
extends KinematicBody2D

# the movement variables (mess around with them to make the movement the way you like)
export (int) var speed = 300
export (int) var jump_speed = -1000
export (int) var gravity = 1000
export (float, 0, 1.0) var friction = 0.25
export (float, 0, 1.0) var acceleration = 0.25

var velocity = Vector2.ZERO

# geting player input with our own function
func get_input():
	var dir = 0
	if Input.is_action_pressed("ui_right"):
		dir += 1
	if Input.is_action_pressed('ui_left'):
		dir -= 1
	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
	else:
		velocity.x = lerp(velocity.x, 0, friction)

# and finaly calculating the movement
func _physics_process(delta):
	get_input()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)
	if Input.is_action_pressed("ui_accept"):
		if is_on_floor():
			velocity.y = jump_speed
	if Input.is_action_just_released("ui_accept"): # this will check to see if are jump key is released and stop the player jumping
		if sign(velocity.y) != 1:
			velocity.y = 0
