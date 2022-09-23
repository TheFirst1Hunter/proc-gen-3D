extends Spatial

onready var gridMap:GridMap = $GridMap


const UP = 1
const RIGHT = 2
const DOWN = 4
const LEFT = 8
const BEHIND = 16
const FACE = 32

var cell_walls = {Vector3(0, -1, 0): DOWN, Vector3(1, 0, 0): RIGHT,
				  Vector3(0, 1, 0): UP, Vector3(-1, 0, 0): LEFT,
				Vector3(0, 0, 1):BEHIND, Vector3(0, 0, -1):FACE}

var erase_fraction = 0.2
var tile_size = 64  # tile size (in pixels)
var width = 20  # width of map (in tiles)
var height = 12  # height of map (in tiles)
var depth = 10

var p
# get a reference to the map for convenience

func _ready():
	randomize()
#	tile_size = Map.cell_size
	make_maze()
	
	$NewFPSCont.global_translation = gridMap.map_to_world(0,0,0)
#	init()
	
#	erase_walls(
	
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
	gridMap.clear()
	for x in range(width):
		for y in range(height):
			for z in range(depth):
				
				unvisited.append(Vector3(x, y, z))
				gridMap.set_cell_item(x, y, z , UP|RIGHT|DOWN|LEFT|BEHIND|FACE)				
#			yield(get_tree(), 'idle_frame')
#				Map.set_cellv(Vector3(x, y), N|E|S|W|DOWN|UP)
	print(UP|RIGHT|DOWN|LEFT|BEHIND|FACE)
	var current = Vector3(0, 0, 0)
	unvisited.erase(current)
	# execute recursive backtracker algorithm
	while unvisited:
		var neighbors = check_neighbors(current, unvisited)
		if neighbors.size() > 0:
			var next = neighbors[randi() % neighbors.size()]
			stack.append(current)
			# remove walls from *both* cells
			var dir = next - current
#			print(current_wall)
			var current_walls = gridMap.get_cell_item(current.x,current.y,current.z) - cell_walls[dir]
			var next_walls =gridMap.get_cell_item(next.x,next.y,next.z) - cell_walls[-dir]
			gridMap.set_cell_item(current.x,current.y,current.z, current_walls)
			gridMap.set_cell_item(next.x,next.y,next.z, next_walls)
			current = next
			unvisited.erase(current)
		elif stack:
			current = stack.pop_back()
#		yield(get_tree(), 'idle_frame')
