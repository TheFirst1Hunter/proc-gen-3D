extends Node2D

var screen_size:Vector2
var start_point:Vector2

onready var line:Line2D = $Line2D
export var max_hight:int = 100
export var min_hight:int = 10

func _ready():
	randomize()
	screen_size = get_viewport_rect().size
	init_terrain()
	
	for i in range(5):
		generate_terrain()


func init_terrain():
	line.points = PoolVector2Array()
	
	start_point= Vector2(0,screen_size.y)
	var end_point = Vector2(screen_size.x,randi() % max_hight)
	
	line.add_point(start_point)
	line.add_point(end_point)
	
func generate_terrain():
	var points = line.points
	
	line.points = PoolVector2Array()
	
	for i in range(points.size()):
		if i == points.size() - 1:
			return
		
		line.add_point(points[i])
		
		var point = (points[i]+points[i+1])/2
		
		point.y = randi()  % max_hight 
		
		if points[i] != points[i+1]:
			line.add_point(point)
		
		line.add_point(points[i+1])
		$StaticBody2D/CollisionPolygon2D.polygon = line.points

func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		generate_terrain()
