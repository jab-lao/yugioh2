extends Node2D

@onready var screen_tint = $"../ScreenTint"
@onready var bgm_player = $"../BGMPlayer"

@onready var tile_map = $"../TileMap"
var astar_grid: AStarGrid2D

func _ready():
	play_bgm()
	globals.grid = self
	globals.tile_map = tile_map
	globals.selected_tiles = $"../SelectedTiles"
	
	astar_grid = AStarGrid2D.new()
	astar_grid.region = tile_map.get_used_rect()

	astar_grid.cell_size = Vector2 (16, 16)
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astar_grid.update()
	
	for x in tile_map.get_used_rect().size.x:
		for y in tile_map.get_used_rect().size.y:
			var tile_position = Vector2i(
				x + tile_map.get_used_rect().position.x,
				y + tile_map.get_used_rect().position.y
			)
			var tile_data = tile_map.get_cell_tile_data(0, tile_position)
			if tile_data == null or tile_data.get_custom_data("walkable") == false:
				astar_grid.set_point_solid(tile_position)


	var tween = get_tree().create_tween()
	tween.tween_property(screen_tint, "color", Color("#ffffff00"), 0.3)
	
func play_bgm():
	if globals.duels_won in [3, 7, 11, 14]:
		bgm_player.stream = load("res://Files/Sounds/Music/Yu-Gi-Oh! The Falsebound Kingdom OST DarkNite.mp3")
	else:
		bgm_player.stream = load("res://Files/Sounds/Music/Yu-Gi-Oh! The Falsebound Kingdom OST Yugi's Battle Theme.mp3")
	bgm_player.play()
	
	
	
	
	
	
