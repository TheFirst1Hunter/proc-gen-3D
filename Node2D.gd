extends Node2D

const N = 1
const E = 2
const S = 4
const W = 8

var cell_walls = {Vector2(0, -1): N, Vector2(1, 0): E,
				  Vector2(0, 1): S, Vector2(-1, 0): W}

var erase_fraction = 0.2
var tile_size = 64  # tile size (in pixels)
var width = 20  # width of map (in tiles)
var height = 12  # height of map (in tiles)

var p
# get a reference to the map for convenience
onready var Map = $TileMap

func _ready():
	randomize()
	tile_size = Map.cell_size
	make_maze()
	
	init()
	
#	erase_walls()
	
func check_neighbors(cell, unvisited):
	# returns an array of cell's unvisited neighbors
	var list = []
	for n in cell_walls.keys():
		if cell + n in unvisited:
			list.append(cell + n)
	return list
	
func make_maze():
	var unvisited = []  # array of unvisited tiles
	var stack = []
	# fill the map with solid tiles
	Map.clear()
	for x in range(width):
		for y in range(height):
			unvisited.append(Vector2(x, y))
#			yield(get_tree(), 'idle_frame')
			Map.set_cellv(Vector2(x, y), N|E|S|W)
	var current = Vector2(0, 0)
	unvisited.erase(current)
	# execute recursive backtracker algorithm
	while unvisited:
		var neighbors = check_neighbors(current, unvisited)
		if neighbors.size() > 0:
			var next = neighbors[randi() % neighbors.size()]
			stack.append(current)
			# remove walls from *both* cells
			var dir = next - current
			var current_walls = Map.get_cellv(current) - cell_walls[dir]
			var next_walls = Map.get_cellv(next) - cell_walls[-dir]
			Map.set_cellv(current, current_walls)
			Map.set_cellv(next, next_walls)
			current = next
			unvisited.erase(current)
		elif stack:
			current = stack.pop_back()
#		yield(get_tree(), 'idle_frame')


func erase_walls():
	# randomly remove a number of the map's walls
	for i in range(int(width * height * erase_fraction)):
		var x = int(rand_range(2, width/2 - 2)) * 2
		var y = int(rand_range(2, height/2 - 2)) * 2
		var cell = Vector2(x, y)
		# pick random neighbor
		var neighbor = cell_walls.keys()[randi() % cell_walls.size()]
		# if there's a wall between them, remove it
		if Map.get_cellv(cell) & cell_walls[neighbor]:
			var walls = Map.get_cellv(cell) - cell_walls[neighbor]
			var n_walls = Map.get_cellv(cell+neighbor) - cell_walls[-neighbor]
			Map.set_cellv(cell, walls)
			Map.set_cellv(cell+neighbor, n_walls)
			# insert intermediate cell
			if neighbor.x != 0:
				Map.set_cellv(cell+neighbor/2, 5)
			else:
				Map.set_cellv(cell+neighbor/2, 10)
#		yield(get_tree(), 'idle_frame')


func _on_Tween_tween_all_completed():
	$Camera2D.current = false
	p.get_node("Camera2D").current = true
	p.set_physics_process(true)
	

func init():
	var player = load("res://Player.tscn")
	p = player.instance()
	get_tree().root.get_children()[0].add_child(p)
	p.global_position = Vector2(131, 225.434555)
	
	p.set_physics_process(false)
	
	$Tween.interpolate_property($Camera2D,'global_position',$Camera2D.global_position,
	Vector2(131, 225.434555),2,Tween.TRANS_QUAD)
	
	$Tween.interpolate_property($Camera2D,'zoom',$Camera2D.zoom,
	Vector2(1, 1),2,Tween.TRANS_QUAD)
	
	$Tween.start()
