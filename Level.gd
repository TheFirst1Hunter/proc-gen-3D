extends Node2D

onready var map:TileMap = $TileMap


var grid = []
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	grid.resize(20)
	for n in 20:
		grid[n] = []
		grid[n].resize(20)
		for m in 20:
			grid[n][m] = randi() % 10
			
	for n in range(0,19):
		for m in range (0,19):
			if grid[n][m] == 0:
				map.set_cell(m,n,(m+n)%2)
