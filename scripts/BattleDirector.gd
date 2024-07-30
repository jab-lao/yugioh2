extends Node

@onready var unit = preload("res://Files/Scenes/Units/Unit.tscn")
@onready var screen_tint = $"../ScreenTint"
@onready var result_player = $"../DuelResultSprite/AnimationPlayer"
@onready var selector = $"../Units/Selector"
@onready var opponent_sprite = $"../Opponent/Sprite2D"
@onready var opponent_animation = $"../Opponent/AnimationPlayer"
@onready var input_hint = $"../InputHint/Label3"


@onready var soul_pop_up = $"../SoulPopUp"
@onready var booster_pop_up = $"../BoosterPopUp"


#@onready var unit_select_scene = load("res://Files/Scenes/UnitSelect/unit_select.tscn")

@onready var units_node = $"../Units"


var units = []
var team1_size = 0
var team2_size = 0

var turn_queue = []
var death_queue = []
var death_row = []


func _ready():
	setup_opponent_sprite()
	globals.switch_loaded_scene(2)
	globals.battle_director = self
	await get_tree().create_timer(0.1).timeout
	spawn_units()
	await get_tree().create_timer(0.2).timeout
	initialize_battle()

func initialize_battle():
	await get_tree().create_timer(0.5).timeout
	for i in units:
		turn_queue.append(i)
	turn_queue = sort_turn_queue()
	start_turn()

func next_turn():
	# check for Death

	for i in death_queue:
		if i.team == 1:
			team1_size -= 1
		else:
			team2_size -= 1
		units.erase(i)
		turn_queue.erase(i)
		death_row.append(i)

	for i in death_row:
		globals.grid.astar_grid.set_point_solid(globals.tile_map.local_to_map(i.global_position), false)
		i.queue_free()
	
	death_row = []
	death_queue = []
	
	for i in units:
		i.being_untargeted()

	if team1_size == 0 or team2_size == 0:
		opponent_sprite.z_index = 100
		screen_tint.color = Color('#00000000')
		var tween3 = get_tree().create_tween()
		tween3.tween_property(screen_tint, "color", Color("#0000006e"), 0.6)
		await get_tree().create_timer(0.4).timeout
		
		globals.duels_fought += 1
#		opponent_animation.play("RESET")
		opponent_animation.stop()
		if team1_size == 0:
			opponent_animation.play('victory')
			result_player.play('lost')
			await result_player.animation_finished
			globals.duels_lost += 1
			
			# Game Over
			if globals.duels_lost > 2:
				var title_scene = preload("res://Files/Scenes/TitleScreen/title.tscn")
				
				var tween4 = get_tree().create_tween()
				tween4.tween_property(screen_tint, "color", Color("#000000"), 1.2)
				tween4.tween_property(opponent_sprite, "modulate", Color("#ffffff00"), 3)
				await get_tree().create_timer(0.6).timeout
				result_player.play('gameover_popup')
				await result_player.animation_finished
				await get_tree().create_timer(0.6).timeout
				get_tree().change_scene_to_packed(title_scene)
				return
			
		else: 
			globals.duels_won += 1
			# Game Won
			if globals.duels_won > 14:
				var title_scene = preload("res://Files/Scenes/TitleScreen/title.tscn")
				opponent_animation.play('defeat')
				var tween4 = get_tree().create_tween()
				tween4.tween_property(screen_tint, "color", Color("#0000006e"), 1.2)
				await get_tree().create_timer(0.6).timeout
				result_player.play('gamewon_popup')
				await result_player.animation_finished
				await get_tree().create_timer(0.6).timeout
				var tween5 = get_tree().create_tween()
				tween5.tween_property(screen_tint, "color", Color("#ffffff"), 0.7)
				await get_tree().create_timer(1).timeout
				get_tree().change_scene_to_packed(title_scene)
				return
				
			result_player.play('won')
			opponent_animation.play('defeat')
			await result_player.animation_finished
			
			if globals.duels_won % 2 == 0:
				result_player.play("soul_popup")
				await result_player.animation_finished
				globals.max_souls += 1
			
			else:
				if len(globals.player_box) < 15:
					result_player.play("booster_popup")
					await result_player.animation_finished
					if len(globals.player_box) != 14:
						globals.due_pulls += 2
					else:
						globals.due_pulls += 1
			
		# End combat scene
		var tween = get_tree().create_tween()
		tween.tween_property(screen_tint, "color", Color("#000000"), 1.2)
		tween.tween_property(opponent_sprite, "modulate", Color("#ffffff00"), 1.2)
		await get_tree().create_timer(1.3).timeout
		
		get_tree().change_scene_to_packed(globals.loaded_scene)

	var last_unit = turn_queue.front()
	turn_queue.erase(last_unit)
	turn_queue.append(last_unit)
	start_turn()

func start_turn():
	await get_tree().create_timer(0.2).timeout
	if len(turn_queue) > 0:
		turn_queue[0].my_turn()

func sort_turn_queue():
	var unsorted_queue = turn_queue.duplicate(true)
	var sorted_queue = []
	var speed_queue = []

	for i in unsorted_queue:
		speed_queue.append(i.stats.agi)
	speed_queue.sort()
	speed_queue.reverse()

	for speed in speed_queue:
		for sorted_unit in unsorted_queue:
			if speed == sorted_unit.stats.agi:
				sorted_queue.append(sorted_unit)
				unsorted_queue.erase(sorted_unit)
	return sorted_queue

func spawn_units():
	var party_size = 0
	var space = 128
	for i in globals.player_party:
		var new_unit = unit.instantiate()
		new_unit.team = 1
		new_unit.unit_name = i
		new_unit.global_position = Vector2(62 + (party_size * space), 555)
		units_node.add_child(new_unit)
		party_size += 1
	
	var enemy_counter = 0
	
	for i in globals.next_encounter:
		if i != null:
			var new_enemy = unit.instantiate()
			new_enemy.team = 2
			new_enemy.unit_name = i
			new_enemy.global_position = Vector2(62 + (enemy_counter * space), 61)
			units_node.add_child(new_enemy)
		enemy_counter += 1

func setup_opponent_sprite():
	opponent_sprite.texture = load("res://Files/UnitArt/yugioh/duelist/%s.png" % globals.next_opponent)
	opponent_animation.play('spawn')
	await opponent_animation.animation_finished
	opponent_animation.play('idle')

