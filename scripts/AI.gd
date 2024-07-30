extends Node

@export var move_speed = 5

@onready var parent = $".."
@onready var sprite = $"../Sprites"
@onready var unit_texture = $"../Sprites/Sprite/UnitTexture"
@onready var actions = $"../Actions"
@onready var stats = $"../Stats"

var full_id_path = []
var current_id_path = []
var target_position: Vector2
var facing_direction = Vector2.RIGHT
var acted = false
var can_attack = false
var ai_picked_target = Node

func _ready():
	current_id_path.append(globals.tile_map.local_to_map(parent.global_position))

func _physics_process(_delta):
	match parent.state:
		parent.active:
			move_to_point()
	

	if current_id_path.is_empty():
		globals.grid.astar_grid.set_point_solid(globals.tile_map.local_to_map(parent.global_position))
		return

	target_position = globals.tile_map.map_to_local(current_id_path.front())

	parent.global_position = parent.global_position.move_toward(target_position, move_speed)

	if parent.global_position == target_position:
		
		current_id_path.pop_front()
		
		if current_id_path.is_empty() == false:
			globals.grid.astar_grid.set_point_solid(globals.tile_map.local_to_map(parent.global_position), false)
			target_position = globals.tile_map.map_to_local(current_id_path.front())

func play_turn():
	pass
#	move_to_point()

func move_to_point():
	if acted:
		return
	acted = true
	var id_path
	
	var self_pos = globals.tile_map.local_to_map(parent.global_position)
	var target_pos = get_combined_target()
#	var target_pos = get_closest_target()

	id_path = globals.grid.astar_grid.get_id_path(self_pos, target_pos).slice(1)
	
	full_id_path = id_path
#	if full_id_path == []:
#		if self_pos - target_pos == Vector2i(1, 0): parent.facing_direction = Vector2i.LEFT
#		elif self_pos - target_pos == Vector2i(-1, 0): parent.facing_direction = Vector2i.RIGHT
#		elif self_pos - target_pos == Vector2i(0, 1): parent.facing_direction = Vector2i.UP
#		elif self_pos - target_pos == Vector2i(0, -1): parent.facing_direction = Vector2i.DOWN
	
	count_movement()
	if id_path.is_empty() == false: 
		globals.grid.astar_grid.set_point_solid(globals.tile_map.local_to_map(parent.global_position), false)
		current_id_path = id_path

func get_combined_target():
	var unit_list = get_tree().get_nodes_in_group('units')
	var occupied_positions = []
	var effective_movement = stats.movement + stats.movement_temp_mod + stats.movement_perma_mod
	if effective_movement < 1: effective_movement = 1

	for unit in unit_list: 
		if unit.team == parent.team:
			continue
		occupied_positions.append([unit, globals.tile_map.local_to_map(unit.global_position)])
	
	var cur_pos = globals.tile_map.local_to_map(parent.global_position)
	var attack_range = []

	var highest_range = 1
	for i in parent.stats.attack1_range:
		if i[0] > highest_range:
			highest_range = i[0]

	# Get walkable tiles
	var movement_value = stats.movement + stats.movement_perma_mod + stats.movement_temp_mod
	if movement_value < 1: movement_value = 1
	
	var walkable = parent.get_walkable_tiles()

	for i in walkable:
		var i_mod = abs(i.x) + abs(i.y)
		if i_mod <= effective_movement + highest_range:
			attack_range.append(cur_pos + i)
			attack_range.append(cur_pos - i)
			attack_range.append(cur_pos + Vector2i(-i.x, i.y))
			attack_range.append(cur_pos + Vector2i(i.x, -i.y))

	var closest_target = [Node, 99999999999, 0]
	var targets_in_range = []
	
	for i in occupied_positions:
		if globals.tile_map.local_to_map(i[0].global_position) in attack_range:
				targets_in_range.append([i[0], parent.global_position.distance_to(i[0].global_position), i[0].stats.evaluate_damage(parent.stats.attack1_power, parent.stats.attack1_element, parent.stats.lethality)])

	if targets_in_range != []:
		for i in targets_in_range:
			if i[2] > closest_target[2]:
				closest_target = i

	elif targets_in_range == [] or parent.stats.attack1_power == 0:
		for i in occupied_positions:
			if parent.global_position.distance_to(i[0].global_position) < closest_target[1]:
				closest_target = [i[0], parent.global_position.distance_to(i[0].global_position)]
		closest_target = closest_target

	var picked_target = closest_target
	ai_picked_target = picked_target[0]
	
	if closest_target == [Node, 99999999999, 0]:
		print('ERROR GETTING TARGET')
		closest_target[0] = unit_list[0]

	# test for each range
	var atk_distance = stats.attack1_range
	var shortest_path = [[], 999999999]
	var shortest_success_path = [[], 999999999]
	var target_pos = globals.tile_map.local_to_map(picked_target[0].global_position)

	for j in atk_distance:
		var possible_destinations = [
			target_pos + Vector2i(j[0], 0),
			target_pos + Vector2i(-j[0], 0),
			target_pos + Vector2i(0, j[0]),
			target_pos + Vector2i(0, -j[0])
		]
		# 0 = right; 1 = left; 2 = down; 3 = up

		for i in possible_destinations:
			var id_path = globals.grid.astar_grid.get_id_path(globals.tile_map.local_to_map(parent.global_position), i)
			if id_path != []:
				if len(id_path) < shortest_path[1]:
					get_facing_direction(possible_destinations, i)
					shortest_path = [id_path, len(id_path)]

					if shortest_path[1] <= (effective_movement + 1):
						shortest_success_path = shortest_path
		
	if shortest_success_path[1] != 999999999:
		shortest_path = shortest_success_path
	
	# apply range limit
	can_attack = true
	var range_dif = len(shortest_path[0]) - (effective_movement + 1)
	if range_dif > 0:
		can_attack = false
		for i in range(range_dif):
			shortest_path[0].pop_back()
	if len(shortest_path[0]) > 0:
		return shortest_path[0][-1]
	else:
		return globals.tile_map.local_to_map(parent.global_position)

func get_best_target():
	var cur_pos = globals.tile_map.local_to_map(parent.global_position)
	can_attack = false
	
	# Get position of every unit
	var unit_list = get_tree().get_nodes_in_group('units')
	var occupied_positions = []
	var ordered_units = []
	for unit in unit_list: 
		if unit != parent:
			occupied_positions.append(globals.tile_map.local_to_map(unit.global_position))
			ordered_units.append(unit)
	
	# Get walkable tiles
	var movement_value = stats.movement + stats.movement_perma_mod + stats.movement_temp_mod
	if movement_value < 1: movement_value = 1
	
	var walkable = parent.get_walkable_tiles()
	
	# Check damage for each direction in each tile
	var highest_range = 1
	for i in parent.stats.attack1_range:
		if i[0] > highest_range:
			highest_range = i[0]
	
	var highest_damage_score = [Vector2(-1, -1), -999, Node]
	
	for i in walkable:
		# Checking UP
		for j in parent.stats.attack1_range:
			if i + Vector2i(0, -j[0]) in occupied_positions:
				var cur_target = ordered_units[occupied_positions.find(i + Vector2i(0, -j[0]))]
				if cur_target.team != parent.team:
					if cur_target.stats.evaluate_damage(parent.stats.attack1_power, parent.stats.attack1_element, parent.stats.lethality) > highest_damage_score[1]:
						if (globals.tile_map.local_to_map(cur_target.global_position) - Vector2i(0, -j[0])) not in occupied_positions:
							highest_damage_score[0] = (globals.tile_map.local_to_map(cur_target.global_position) - Vector2i(0, -j[0]))
							highest_damage_score[1] = cur_target.stats.evaluate_damage(parent.stats.attack1_power, parent.stats.attack1_element, parent.stats.lethality)
							highest_damage_score[2] = cur_target
							parent.facing_direction = Vector2i.UP

			# Checking DOWN
			if i + Vector2i(0, j[0]) in occupied_positions:
				var cur_target = ordered_units[occupied_positions.find(i + Vector2i(0, j[0]))]
				if cur_target.team != parent.team:
					if cur_target.stats.evaluate_damage(parent.stats.attack1_power, parent.stats.attack1_element, parent.stats.lethality) > highest_damage_score[1]:
						if (globals.tile_map.local_to_map(cur_target.global_position) - Vector2i(0, j[0])) not in occupied_positions:
							highest_damage_score[0] = (globals.tile_map.local_to_map(cur_target.global_position) - Vector2i(0, j[0]))
							highest_damage_score[1] = cur_target.stats.evaluate_damage(parent.stats.attack1_power, parent.stats.attack1_element, parent.stats.lethality)
							highest_damage_score[2] = cur_target
							parent.facing_direction = Vector2i.DOWN

			# Checking LEFT
			if i + Vector2i(-j[0], 0) in occupied_positions:
				var cur_target = ordered_units[occupied_positions.find(i + Vector2i(j[0], 0))]
				if cur_target.team != parent.team:
					if cur_target.stats.evaluate_damage(parent.stats.attack1_power, parent.stats.attack1_element, parent.stats.lethality) > highest_damage_score[1]:
						if (globals.tile_map.local_to_map(cur_target.global_position) - Vector2i(-j[0], 0)) not in occupied_positions:
							highest_damage_score[0] = (globals.tile_map.local_to_map(cur_target.global_position) - Vector2i(-j[0], 0))
							highest_damage_score[1] = cur_target.stats.evaluate_damage(parent.stats.attack1_power, parent.stats.attack1_element, parent.stats.lethality)
							highest_damage_score[2] = cur_target
							parent.facing_direction = Vector2i.LEFT

			# Checking RIGHT
			if i + Vector2i(j[0], 0) in occupied_positions:
				var cur_target = ordered_units[occupied_positions.find(i + Vector2i(-j[0], 0))]
				if cur_target.team != parent.team:
					if cur_target.stats.evaluate_damage(parent.stats.attack1_power, parent.stats.attack1_element, parent.stats.lethality) > highest_damage_score[1]:
						if (globals.tile_map.local_to_map(cur_target.global_position) - Vector2i(j[0], 0)) not in occupied_positions:
							highest_damage_score[0] = (globals.tile_map.local_to_map(cur_target.global_position) - Vector2i(j[0], 0))
							highest_damage_score[1] = cur_target.stats.evaluate_damage(parent.stats.attack1_power, parent.stats.attack1_element, parent.stats.lethality)
							highest_damage_score[2] = cur_target
							parent.facing_direction = Vector2i.RIGHT
						
#	print(highest_damage_score)
	# No target in range
	if highest_damage_score == [Vector2(-1, -1), -999, Node]:
		var closest_enemy = [Node, 99999999999]
		for i in ordered_units:
			if i.team != parent.team:
				var cur_enemy_pos = globals.tile_map.local_to_map(i.global_position)
				var cur_enemy_neighboors = globals.tile_map.get_surrounding_cells(cur_enemy_pos)
				for j in cur_enemy_neighboors:
					if (j[0] > -1 and j[0] < 5) and (j[1] > -1 and j[1] < 5):
						var path_to_cur_enemy = globals.grid.astar_grid.get_id_path(cur_pos, j)
						if path_to_cur_enemy != []:
							if len(path_to_cur_enemy) < closest_enemy[1]:
								closest_enemy = [i, len(path_to_cur_enemy), path_to_cur_enemy]

		var enemy_coords = globals.tile_map.local_to_map(closest_enemy[0].global_position)
		var enemy_neighboors = globals.tile_map.get_surrounding_cells(enemy_coords)

		var closest_tile = [Vector2i(99, 99), 9999, Vector2i(99, 99)]
		for i in enemy_neighboors:
			if (i[0] > -1 and i[0] < 5) and (i[1] > -1 and i[1] < 5):
				var cur_route = globals.grid.astar_grid.get_id_path(cur_pos, i)
		
				if len(cur_route) < closest_tile[1]:
					closest_tile = [i, len(cur_route), cur_route]

		if closest_enemy[1] <= movement_value:
			print('no target, full movement')
			return closest_enemy[2][-1]
		else:
			print('no target, out of movement')
			return closest_enemy[2][movement_value]

	# Target in range
	else:
		print('has target')
		can_attack = true
		ai_picked_target = highest_damage_score[2]
		return highest_damage_score[0]

func get_closest_target():
	var unit_list = get_tree().get_nodes_in_group('units')
	var occupied_positions = []
	var effective_movement = stats.movement + stats.movement_temp_mod + stats.movement_perma_mod
	if effective_movement < 1: effective_movement = 1

	for unit in unit_list: 
		if unit.team == parent.team:
			continue
		occupied_positions.append([unit, globals.tile_map.local_to_map(unit.global_position)])
	
	var cur_pos = globals.tile_map.local_to_map(parent.global_position)
	var attack_range = []

	var highest_range = 1
	for i in parent.stats.attack1_range:
		if i[0] > highest_range:
			highest_range = i[0]

	for i in globals.tile_map.get_used_cells(0):
		var i_mod = abs(i.x) + abs(i.y)
		if i_mod <= effective_movement + highest_range:
			attack_range.append(cur_pos + i)
			attack_range.append(cur_pos - i)
			attack_range.append(cur_pos + Vector2i(-i.x, i.y))
			attack_range.append(cur_pos + Vector2i(i.x, -i.y))

	var closest_target = [Node, 99999999999, 0]
	var targets_in_range = []
	
	for i in occupied_positions:
		if globals.tile_map.local_to_map(i[0].global_position) in attack_range:
				targets_in_range.append([i[0], parent.global_position.distance_to(i[0].global_position), i[0].stats.evaluate_damage(parent.stats.attack1_power, parent.stats.attack1_element, parent.stats.lethality)])

	if targets_in_range != []:
		for i in targets_in_range:
			if i[2] > closest_target[2]:
				closest_target = i

	elif targets_in_range == [] or parent.stats.attack1_power == 0:
		for i in occupied_positions:
			if parent.global_position.distance_to(i[0].global_position) < closest_target[1]:
				closest_target = [i[0], parent.global_position.distance_to(i[0].global_position)]
		closest_target = closest_target

	var picked_target = closest_target
	ai_picked_target = picked_target[0]
	
	if closest_target == [Node, 99999999999, 0]:
		print('ERROR GETTING TARGET')
		closest_target[0] = unit_list[0]

	# test for each range
	var atk_distance = stats.attack1_range
	var shortest_path = [[], 999999999]
	var shortest_success_path = [[], 999999999]
	var target_pos = globals.tile_map.local_to_map(picked_target[0].global_position)

	for j in atk_distance:
		var possible_destinations = [
			target_pos + Vector2i(j[0], 0),
			target_pos + Vector2i(-j[0], 0),
			target_pos + Vector2i(0, j[0]),
			target_pos + Vector2i(0, -j[0])
		]
		# 0 = right; 1 = left; 2 = down; 3 = up

		for i in possible_destinations:
			var id_path = globals.grid.astar_grid.get_id_path(globals.tile_map.local_to_map(parent.global_position), i)
			if id_path != []:
				if len(id_path) < shortest_path[1]:
					get_facing_direction(possible_destinations, i)
					shortest_path = [id_path, len(id_path)]

					if shortest_path[1] <= (effective_movement + 1):
						shortest_success_path = shortest_path
		
	if shortest_success_path[1] != 999999999:
		shortest_path = shortest_success_path
	
	# apply range limit
	can_attack = true
	var range_dif = len(shortest_path[0]) - (effective_movement + 1)
	if range_dif > 0:
		can_attack = false
		for i in range(range_dif):
			shortest_path[0].pop_back()
	if len(shortest_path[0]) > 0:
		return shortest_path[0][-1]
	else:
		return globals.tile_map.local_to_map(parent.global_position)

func get_facing_direction(possible_destinations, chosen_path):
	var face_dir = possible_destinations.find(chosen_path)
	if face_dir == 0: parent.facing_direction = Vector2i.LEFT
	elif face_dir == 1: parent.facing_direction = Vector2i.RIGHT
	elif face_dir == 2: parent.facing_direction = Vector2i.UP
	elif face_dir == 3: parent.facing_direction = Vector2i.DOWN

func count_movement():
#	parent.deselect_tiles()
	var cur_pos = globals.tile_map.local_to_map(parent.global_position)
	var total_steps = len(full_id_path)
	var cur_steps = 0
	
	if total_steps > 0:
		while cur_steps < total_steps:
			if globals.tile_map.local_to_map(parent.global_position) != cur_pos:
				cur_steps += 1
			await get_tree().create_timer(0.3).timeout
	else:
		await get_tree().create_timer(0.1).timeout

	if can_attack:
		parent.deselect_tiles()
		await get_tree().create_timer(0.01).timeout
		parent.check_targets()

		parent.final_target = [ai_picked_target]

		parent.get_targeted_tiles()

		if parent.final_target[0] in parent.targets:
			for i in stats.on_combat_start_effects:
				i.call(parent)
			
			for i in parent.final_target[0].stats.on_combat_start_effects:
				i.call(parent)
			
			await get_tree().create_timer(0.3).timeout
			for i in range(stats.attack1_hits):
				await actions.attack(true)
	parent.end_my_turn()
