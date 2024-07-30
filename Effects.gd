extends Node

# Types
# 0 = on spawn
# 1 = pre attack
# 2 = post attack
# 3 = pre damage taken
# 4 = post damage taken
# 5 = on turn start
# 6 = on turn end
# 7 = on death
# 8 = enemy moved into range
# 9 = on combat start
# 10 = pre heal effects
# 11 = on_hit



var buff_power_var = func buff_power(unit):
#	unit.stats.atk = 9999
	unit.stats.update_moves()
	unit.stats.attack1_element = ['water']
var buff_power_arr = [0, buff_power_var]


var celtic_guardian_var = func celtic_guardian_effect(unit):
	if unit.stats.atk < unit.final_target[0].stats.atk * 1.4:
		unit.stats.atk_temp_mod = 1.5
		unit.stats.prot_temp_mod = 1.5
		unit.stats.update_moves()
var celtic_guardian_arr = [9, celtic_guardian_var]

#############################################################################
#############################################################################

var claw_reacher_var = func claw_reacher_effect(unit):
	var unit_list = get_tree().get_nodes_in_group('units')
	var occupied_positions = []
	for cur_unit in unit_list: 
		occupied_positions.append(globals.tile_map.local_to_map(cur_unit.global_position))

	var prev_pos = unit.final_target[0].global_position
	var final_pos = unit.final_target[0].global_position + Vector2(124 * -unit.facing_direction.x, 124 * -unit.facing_direction.y)
	if globals.tile_map.get_cell_tile_data(0, globals.tile_map.local_to_map(final_pos)):
		if globals.tile_map.get_cell_tile_data(0, globals.tile_map.local_to_map(final_pos)).get_custom_data("walkable"):
			if globals.tile_map.local_to_map(final_pos) not in occupied_positions:
				await get_tree().create_timer(0.4).timeout
				var tween = get_tree().create_tween()
				tween.tween_property(unit.final_target[0], "global_position", final_pos, 0.2)
				unit.final_target[0].blink_player.play('hurt')
				await get_tree().create_timer(0.8).timeout
				globals.grid.astar_grid.set_point_solid(globals.tile_map.local_to_map(prev_pos), false)
				globals.grid.astar_grid.set_point_solid(globals.tile_map.local_to_map(unit.final_target[0].global_position))
var claw_reacher_arr = [2, claw_reacher_var]

#############################################################################
#############################################################################

var ryu_kishin1_var = func ryu_kishin1_effect(unit):
	unit.stats.shield_value = unit.stats.max_hp * 0.1
	unit.stats.update_shield()
var ryu_kishin1_arr = [0, ryu_kishin1_var]

var ryu_kishin2_var = func ryu_kishin2_effect(unit):
	unit.stats.shield_value -= unit.stats.max_hp * 0.1
	if unit.stats.shield_value < 0: unit.stats.shield_value = 0
	unit.stats.shield_value += unit.stats.max_hp * 0.1
	unit.stats.update_shield()
var ryu_kishin2_arr = [5, ryu_kishin2_var]

#############################################################################
#############################################################################

var time_wizard_var = func time_wizard_effect(unit):
	var rng = randi_range(0, 1)
	if rng == 0:
		unit.stats.atk_temp_mod += 1
		unit.stats.update_moves()
var time_wizard_arr = [1, time_wizard_var]

#############################################################################
#############################################################################

var kuriboh_var = func kuriboh_effect(unit):
	unit.stats.atk_perma_mod += 0.2
	unit.stats.update_moves()
var kuriboh_arr = [5, kuriboh_var]

#############################################################################
#############################################################################

var saggi_var = func saggi_effect(unit):
	if unit.final_target[0].stats.hp < unit.final_target[0].stats.max_hp / 2:
		unit.stats.atk_temp_mod += 0.5
		unit.stats.update_moves()
var saggi_arr = [1, saggi_var]

#############################################################################
#############################################################################

var skull_servant_var = func skull_servant_effect(unit):
	unit.final_target[0].stats.movement_temp_mod += -1
var skull_servant_arr = [2, skull_servant_var]

#############################################################################
#############################################################################

var harpie_lady_var = func harpie_lady_effect(unit):
	if unit.final_target[0].stats.agi < unit.stats.agi:
		unit.stats.atk_temp_mod += 0.5
		unit.stats.update_moves()
var harpie_lady_arr = [9, harpie_lady_var]

#############################################################################
#############################################################################

func injection_lily3_effect(unit):
	unit.stats.on_turn_end_effects.erase(injection_lily2_var)

var injection_lily2_var = func injection_lily2_effect(unit):
	if unit.stats.hp > 2:
		await get_tree().create_timer(0.2).timeout
		unit.stats.take_damage(unit.stats.max_hp * 0.25, ['true'], 0)
		injection_lily3_effect(unit)
		await get_tree().create_timer(0.8).timeout

var injection_lily_var = func injection_lily_effect(unit):
	unit.final_target[0].stats.on_turn_end_effects.append(injection_lily2_var)
var injection_lily_arr = [2, injection_lily_var]

#############################################################################
#############################################################################

var hercules_beetle_var = func hercules_beetle_effect(unit):
	var unit_list = get_tree().get_nodes_in_group('units')
	var occupied_positions = []
	for cur_unit in unit_list: 
		occupied_positions.append(globals.tile_map.local_to_map(cur_unit.global_position))

	var prev_pos = unit.final_target[0].global_position
	var final_pos = unit.final_target[0].global_position + Vector2(250 * -unit.facing_direction.x, 250 * -unit.facing_direction.y)

	if globals.tile_map.get_cell_tile_data(0, globals.tile_map.local_to_map(final_pos)):
		if globals.tile_map.get_cell_tile_data(0, globals.tile_map.local_to_map(final_pos)).get_custom_data("walkable"):
			if globals.tile_map.local_to_map(final_pos) not in occupied_positions:
				await get_tree().create_timer(0.4).timeout
				var tween = get_tree().create_tween()
				tween.tween_property(unit.final_target[0], "global_position", final_pos, 0.2)
				unit.final_target[0].blink_player.play('hurt')
				await get_tree().create_timer(0.8).timeout
				globals.grid.astar_grid.set_point_solid(globals.tile_map.local_to_map(prev_pos), false)
				globals.grid.astar_grid.set_point_solid(globals.tile_map.local_to_map(unit.final_target[0].global_position))
var hercules_beetle_arr = [2, hercules_beetle_var]

#############################################################################
#############################################################################

var happy_lover_var = func happy_lover_effect(unit):
	var unit_list = get_tree().get_nodes_in_group('units')
	var cur_pos = globals.tile_map.local_to_map(unit.global_position)
	var ability_range = []

	for i in globals.tile_map.get_used_cells(0):
		var i_mod = abs(i.x) + abs(i.y)
		if i_mod <= 2:
			ability_range.append(cur_pos + i)
			ability_range.append(cur_pos - i)
			ability_range.append(cur_pos + Vector2i(-i.x, i.y))
			ability_range.append(cur_pos + Vector2i(i.x, -i.y))

	ability_range.erase(cur_pos)
	for i in unit_list:
		if globals.tile_map.local_to_map(i.global_position) in ability_range:
			if i != unit and i.team == unit.team:
				i.stats.heal(120)
	
	await get_tree().create_timer(0.8).timeout
var happy_lover_arr = [6, happy_lover_var]

#############################################################################
#############################################################################

var catapult_turtle_var = func catapult_turtle_effect(unit):
	var unit_list = get_tree().get_nodes_in_group('units')
	var occupied_positions = []
	for cur_unit in unit_list: 
		occupied_positions.append(globals.tile_map.local_to_map(cur_unit.global_position))

	var prev_pos = unit.final_target[0].global_position
	var final_pos = unit.final_target[0].global_position + Vector2(124 * unit.facing_direction.x, 124 * unit.facing_direction.y)
	if globals.tile_map.get_cell_tile_data(0, globals.tile_map.local_to_map(final_pos)):
		if globals.tile_map.get_cell_tile_data(0, globals.tile_map.local_to_map(final_pos)).get_custom_data("walkable"):
			if globals.tile_map.local_to_map(final_pos) not in occupied_positions:
				await get_tree().create_timer(0.4).timeout
				var tween = get_tree().create_tween()
				tween.tween_property(unit.final_target[0], "global_position", final_pos, 0.2)
				unit.final_target[0].blink_player.play('hurt')
				await get_tree().create_timer(0.8).timeout
				globals.grid.astar_grid.set_point_solid(globals.tile_map.local_to_map(prev_pos), false)
				globals.grid.astar_grid.set_point_solid(globals.tile_map.local_to_map(unit.final_target[0].global_position))
var catapult_turtle_arr = [2, catapult_turtle_var]

#############################################################################
#############################################################################

var headhuntress_var = func headhuntress_effect(unit):
	if unit.final_target[0].stats.hp < unit.final_target[0].stats.max_hp * 0.21 and unit.final_target[0].stats.hp > 1:
		if unit.final_target[0].stats.hp > 2:
			await get_tree().create_timer(0.3).timeout
			await unit.final_target[0].stats.take_damage(99999, ['true'], 0)
var headhuntress_arr = [2, headhuntress_var]

#############################################################################
#############################################################################

var berserk_gorilla_var = func berserk_gorilla_effect(unit):
	unit.auto_battle = true
var berserk_gorilla_arr = [0, berserk_gorilla_var]

var berserk_gorilla2_var = func berserk_gorilla2_effect(unit):
	unit.auto_battle = true
var berserk_gorilla2_arr = [5, berserk_gorilla2_var]

#############################################################################
#############################################################################

var cure_mermaid_var = func cure_mermaid_effect(unit):
	var unit_list = get_tree().get_nodes_in_group('units')
	var cur_pos = globals.tile_map.local_to_map(unit.global_position)
	var ability_range = []

	for i in globals.tile_map.get_used_cells(0):
		var i_mod = abs(i.x) + abs(i.y)
		if i_mod <= 2:
			ability_range.append(cur_pos + i)
			ability_range.append(cur_pos - i)
			ability_range.append(cur_pos + Vector2i(-i.x, i.y))
			ability_range.append(cur_pos + Vector2i(i.x, -i.y))

	ability_range.erase(cur_pos)
	for i in unit_list:
		if globals.tile_map.local_to_map(i.global_position) in ability_range:
			if i != unit and i.team == unit.team:
				i.stats.heal(i.stats.max_hp * 0.1)
var cure_mermaid_arr = [6, cure_mermaid_var]

#############################################################################
#############################################################################

var mammoth_graveyard_var = func mammoth_graveyard_effect(unit):
	var unit_list = get_tree().get_nodes_in_group('units')
	var occupied_positions = []
	for cur_unit in unit_list: 
		occupied_positions.append(globals.tile_map.local_to_map(cur_unit.global_position))

	var prev_pos = unit.global_position
	var final_pos = unit.global_position + Vector2(124 * unit.facing_direction.x, 124 * unit.facing_direction.y)
	
	var prev_mod = unit.stats.atk_temp_mod
	unit.stats.atk_temp_mod = 0
	unit.stats.update_moves()
	if globals.tile_map.get_cell_tile_data(0, globals.tile_map.local_to_map(final_pos)):
		if globals.tile_map.get_cell_tile_data(0, globals.tile_map.local_to_map(final_pos)).get_custom_data("walkable"):
			if globals.tile_map.local_to_map(final_pos) not in occupied_positions:
				unit.stats.atk_temp_mod = prev_mod
				unit.stats.update_moves()
				await get_tree().create_timer(0.3).timeout
				var tween = get_tree().create_tween()
				tween.tween_property(unit, "global_position", final_pos, 0.1)
#				unit.final_target[0].blink_player.play('hurt')
				await get_tree().create_timer(0.15).timeout
				globals.grid.astar_grid.set_point_solid(globals.tile_map.local_to_map(prev_pos), false)
				globals.grid.astar_grid.set_point_solid(globals.tile_map.local_to_map(unit.global_position))
var mammoth_graveyard_arr = [1, mammoth_graveyard_var]

#############################################################################
#############################################################################

var lady_wasteland_var = func lady_wasteland_effect(unit):
	var rng = randi_range(1, 100)
	if rng <= 15:
		unit.stats.prot_temp_mod = 9999999999
		unit.stats.update_moves()
var lady_wasteland_arr = [3, lady_wasteland_var]

#############################################################################
#############################################################################

var dd_lady_var = func dd_lady_effect(unit):
	pass
#	var rng = randi_range(1, 100)
#	if rng <= 30:
#		unit.stats.prot_temp_mod = 9999999999
#		unit.stats.update_moves()
var dd_lady_arr = [3, dd_lady_var]

#############################################################################
#############################################################################

var copycat_var = func copycat_effect(unit):
	unit.stats.atk = unit.final_target[0].stats.attack1_power
	unit.stats.update_moves()
var copycat_arr = [1, copycat_var]

var copycat2_var = func copycat2_effect(unit):
	unit.stats.atk = 3
	unit.stats.update_moves()
var copycat2_arr = [2, copycat2_var]

#############################################################################
#############################################################################

func rai_mei_a3_effect(unit):
	unit.stats.on_turn_start_effects.erase(rai_mei_a2_var)

var rai_mei_a2_var = func rai_mei_a2_effect(unit):
	if unit.stats.hp > 1.5:
		await get_tree().create_timer(0.2).timeout
		if unit.stats.hp > 2:
			await unit.stats.take_damage(unit.stats.atk * 0.3, ['lightning'], 0)
		rai_mei_a3_effect(unit)
		await get_tree().create_timer(0.6).timeout

var rai_mei_a1_var = func rai_mei_a1_effect(unit):
	for i in range(unit.stats.attack1_hits):
		unit.final_target[0].stats.on_turn_start_effects.append(rai_mei_a2_var)

var rai_mei_a_arr = [2, rai_mei_a1_var]


func rai_mei_b3_effect(unit):
	unit.stats.on_turn_end_effects.erase(rai_mei_b2_var)

var rai_mei_b2_var = func rai_mei_b2_effect(unit):
	await get_tree().create_timer(0.2).timeout
	if unit.stats.hp > 2:
		await unit.stats.take_damage(unit.stats.atk * 0.3, ['lightning'], 0)
	rai_mei_b3_effect(unit)
	await get_tree().create_timer(0.8).timeout

var rai_mei_b1_var = func rai_mei_b1_effect(unit):
	unit.attacked_by.stats.on_turn_end_effects.append(rai_mei_b2_var)

var rai_mei_b_arr = [3, rai_mei_b1_var]

#############################################################################
#############################################################################

func bio_mage3_effect(unit):
	unit.stats.on_turn_end_effects.erase(bio_mage2_var)

var bio_mage2_var = func bio_mage2_effect(unit):
	await get_tree().create_timer(0.2).timeout
	if unit.stats.hp > 2:
		unit.stats.take_damage(unit.stats.atk * 0.3, ['earth'], 999)
	bio_mage3_effect(unit)
	await get_tree().create_timer(0.8).timeout

var bio_mage_var = func bio_mage_effect(unit):
	unit.final_target[0].stats.on_turn_end_effects.append(bio_mage2_var)
var bio_mage_arr = [2, bio_mage_var]


#############################################################################
#############################################################################

var garoozis_var = func garoozis_effect(unit):
	if unit.stats.hp < unit.stats.max_hp:
		unit.stats.heal(unit.stats.max_hp * 0.1)
		await get_tree().create_timer(0.8).timeout
var garoozis_arr = [5, garoozis_var]

#############################################################################
#############################################################################

var beaver_warrior_var = func beaver_warrior_effect(unit):
	unit.stats.shield_value -= 160
	if unit.stats.shield_value < 1: unit.stats.shield_value = 0
	unit.stats.shield_value += 160
	unit.stats.on_turn_start_effects.append(beaver_warrior2_var)
	unit.stats.update_shield()
var beaver_warrior_arr = [4, beaver_warrior_var]

var beaver_warrior2_var = func beaver_warrior2_effect(unit):
	unit.stats.shield_value -= 160
	unit.stats.update_shield()
var beaver_warrior2_arr = [5, beaver_warrior2_var]

#############################################################################
#############################################################################

var mystical_elf_var = func mystical_elf_effect(unit):
	var unit_list = get_tree().get_nodes_in_group('units')
	var cur_pos = globals.tile_map.local_to_map(unit.global_position)
	var ability_range = []

	for i in globals.tile_map.get_used_cells(0):
		var i_mod = abs(i.x) + abs(i.y)
		if i_mod <= 2:
			ability_range.append(cur_pos + i)
			ability_range.append(cur_pos - i)
			ability_range.append(cur_pos + Vector2i(-i.x, i.y))
			ability_range.append(cur_pos + Vector2i(i.x, -i.y))

	ability_range.erase(cur_pos)
	for i in unit_list:
		if globals.tile_map.local_to_map(i.global_position) in ability_range:
			if i != unit and i.team == unit.team:
				i.stats.heal(i.stats.max_hp * 0.2)
var mystical_elf_arr = [6, mystical_elf_var]

#############################################################################
#############################################################################

var dark_elf_var = func dark_elf_effect(unit):
	unit.stats.take_damage(240, ['true'], 999)
	await get_tree().create_timer(0.8).timeout
var dark_elf_arr = [2, dark_elf_var]

#############################################################################
#############################################################################

var summoned_skull_var = func summoned_skull_effect(unit):
	var target_pos = globals.tile_map.local_to_map(unit.final_target[0].global_position)
	var unit_list = get_tree().get_nodes_in_group('units')
#	var cur_pos = globals.tile_map.local_to_map(unit.global_position)
	var ability_range = []
	
	ability_range.append(target_pos + Vector2i(1, 0))
	ability_range.append(target_pos + Vector2i(0, 1))
	ability_range.append(target_pos + Vector2i(-1, 0))
	ability_range.append(target_pos + Vector2i(0, -1))
	
	for i in unit_list:
		if globals.tile_map.local_to_map(i.global_position) in ability_range:
			if i != unit and i.team != unit.team:
				if i.stats.hp > 2:
					i.stats.take_damage(unit.stats.atk / 2, ['lightning', 'vice'], unit.stats.lethality)
var summoned_skull_arr = [2, summoned_skull_var]

#############################################################################
#############################################################################

var gazelle_var = func gazelle_effect(unit):
	var unit_list = get_tree().get_nodes_in_group('units')
	var occupied_positions = []
	for cur_unit in unit_list: 
		occupied_positions.append(globals.tile_map.local_to_map(cur_unit.global_position))

	var prev_pos = unit.global_position
	var final_pos = unit.global_position + Vector2(250 * unit.facing_direction.x, 250 * unit.facing_direction.y)
	
#	var prev_mod = unit.stats.atk_temp_mod
#	unit.stats.atk_temp_mod = 0
#	unit.stats.update_moves()
	if globals.tile_map.get_cell_tile_data(0, globals.tile_map.local_to_map(final_pos)):
		if globals.tile_map.get_cell_tile_data(0, globals.tile_map.local_to_map(final_pos)).get_custom_data("walkable"):
			if globals.tile_map.local_to_map(final_pos) not in occupied_positions:
#				unit.stats.atk_temp_mod = prev_mod
#				unit.stats.update_moves()
				await get_tree().create_timer(0.3).timeout
				var tween = get_tree().create_tween()
				tween.tween_property(unit, "global_position", final_pos, 0.1)
#				unit.final_target[0].blink_player.play('hurt')
				await get_tree().create_timer(0.15).timeout
				globals.grid.astar_grid.set_point_solid(globals.tile_map.local_to_map(prev_pos), false)
				globals.grid.astar_grid.set_point_solid(globals.tile_map.local_to_map(unit.global_position))
var gazelle_arr = [1, gazelle_var]

#############################################################################
#############################################################################

var dark_witch_var = func dark_witch_effect(unit):
	await get_tree().create_timer(0.4).timeout
	if unit.final_target[0].stats.hp > 2:
		unit.final_target[0].stats.take_damage(unit.final_target[0].stats.max_hp * 0.1, ['true'], 999)
		await get_tree().create_timer(0.8).timeout
var dark_witch_arr = [2, dark_witch_var]

#############################################################################
#############################################################################

var gate_guardian_var = func gate_guardian_effect(unit):
	if unit.final_target[0].stats.hp > 2:
		await get_tree().create_timer(0.4).timeout
		await unit.final_target[0].stats.take_damage(unit.stats.attack1_power, ['water'], unit.stats.lethality)
	if unit.final_target[0].stats.hp > 2:
		await get_tree().create_timer(0.2).timeout
		await unit.final_target[0].stats.take_damage(unit.stats.attack1_power, ['air'], unit.stats.lethality)
		await get_tree().create_timer(0.4).timeout
var gate_guardian_arr = [2, gate_guardian_var]

#############################################################################
#############################################################################

var wingweaver_var = func wingweaver_effect(unit):
	var unit_list = get_tree().get_nodes_in_group('units')
	
	for i in unit_list:
		if i.team == unit.team:
			i.stats.prot_perma_mod += 0.2
var wingweaver_arr = [0, wingweaver_var]

#############################################################################
#############################################################################

var fire_princess_var = func fire_princess_effect(unit):
	var unit_list = get_tree().get_nodes_in_group('units')
	var cur_pos = globals.tile_map.local_to_map(unit.global_position)
	var ability_range = []

	for i in globals.tile_map.get_used_cells(0):
		var i_mod = abs(i.x) + abs(i.y)
		if i_mod <= 2:
			ability_range.append(cur_pos + i)
			ability_range.append(cur_pos - i)
			ability_range.append(cur_pos + Vector2i(-i.x, i.y))
			ability_range.append(cur_pos + Vector2i(i.x, -i.y))

	ability_range.erase(cur_pos)
	for i in unit_list:
		if globals.tile_map.local_to_map(i.global_position) in ability_range:
			if i.team != unit.team:
				if i.stats.hp > 2:
					i.stats.take_damage(unit.stats.attack1_power * 0.5, ['fire'], unit.stats.lethality)
					await get_tree().create_timer(0.6).timeout
var fire_princess_arr = [6, fire_princess_var]

#############################################################################
#############################################################################

var drill_bug_var = func drill_bug_effect(unit):
	if unit.final_target[0].stats.hp > 2:
		await get_tree().create_timer(0.4).timeout
		unit.final_target[0].stats.take_damage(unit.final_target[0].stats.hp * 0.5, ['true'], 999)
		await get_tree().create_timer(0.8).timeout
var drill_bug_arr = [2, drill_bug_var]

#############################################################################
#############################################################################

var sf_dragon_var = func sf_dragon_effect(unit):
	var unit_list = get_tree().get_nodes_in_group('units')
	
	for i in unit_list:
		if i.team != unit.team:
			if i.stats.hp > 2:
				i.stats.take_damage(unit.stats.atk * 0.5, ['fire'], unit.stats.lethality)
	await get_tree().create_timer(0.8).timeout
var sf_dragon_arr = [6, sf_dragon_var]

#############################################################################
#############################################################################

var masaki_var = func masaki_effect(unit):
	var unit_list = get_tree().get_nodes_in_group('units')
	var occupied_positions = []
	for cur_unit in unit_list: 
		occupied_positions.append(globals.tile_map.local_to_map(cur_unit.global_position))

	var prev_pos = unit.global_position
	var final_pos = unit.global_position + Vector2(250 * unit.facing_direction.x, 250 * unit.facing_direction.y)
	
	var prev_mod = unit.stats.atk_temp_mod
	unit.stats.atk_temp_mod = 0
	unit.stats.update_moves()
	if globals.tile_map.get_cell_tile_data(0, globals.tile_map.local_to_map(final_pos)):
		if globals.tile_map.get_cell_tile_data(0, globals.tile_map.local_to_map(final_pos)).get_custom_data("walkable"):
			if globals.tile_map.local_to_map(final_pos) not in occupied_positions:
				unit.stats.atk_temp_mod = prev_mod
				unit.stats.update_moves()
				await get_tree().create_timer(0.3).timeout
				var tween = get_tree().create_tween()
				tween.tween_property(unit, "global_position", final_pos, 0.1)
#				unit.final_target[0].blink_player.play('hurt')
				await get_tree().create_timer(0.15).timeout
				globals.grid.astar_grid.set_point_solid(globals.tile_map.local_to_map(prev_pos), false)
				globals.grid.astar_grid.set_point_solid(globals.tile_map.local_to_map(unit.global_position))
var masaki_arr = [1, masaki_var]

#############################################################################
#############################################################################

var harpie_girl_var = func harpie_girl_effect(unit):
	var unit_list = get_tree().get_nodes_in_group('units')
	
	for i in unit_list:
		if i.team == unit.team:
			unit.stats.agi_perma_mod += 0.2
var harpie_girl_arr = [0, harpie_girl_var]

#############################################################################
#############################################################################

var man_eater_var = func man_eater_effect(unit):
	if unit.final_target[0].stats.hp < unit.final_target[0].stats.max_hp * 0.36 and unit.final_target[0].stats.hp > 1:
		await get_tree().create_timer(0.3).timeout
		if unit.final_target[0].stats.hp > 2:
			await unit.final_target[0].stats.take_damage(99999, ['true'], 0)
var man_eater_arr = [2, man_eater_var]

#############################################################################
#############################################################################

var dark_jeroid_var = func dark_jeroid_effect(unit):
	unit.final_target[0].stats.atk_temp_mod += -0.35
var dark_jeroid_arr = [2, dark_jeroid_var]

#############################################################################
#############################################################################

var pendulum_machine_var = func pendulum_machine_effect(unit):
	var unit_list = get_tree().get_nodes_in_group('units')
	var cur_pos = globals.tile_map.local_to_map(unit.global_position)
	var ability_range = []

	for i in globals.tile_map.get_used_cells(0):
		var i_mod = abs(i.x) + abs(i.y)
		if i_mod <= 1:
			ability_range.append(cur_pos + i)
			ability_range.append(cur_pos - i)
			ability_range.append(cur_pos + Vector2i(-i.x, i.y))
			ability_range.append(cur_pos + Vector2i(i.x, -i.y))

	ability_range.erase(cur_pos)
	for i in unit_list:
		if globals.tile_map.local_to_map(i.global_position) in ability_range:
			if i.team != unit.team:
				if i.stats.hp > 2:
					i.stats.take_damage(unit.stats.attack1_power * 0.7, ['slash'], unit.stats.lethality)
var pendulum_machine_arr = [6, pendulum_machine_var]

#############################################################################
#############################################################################

var gravekeeper_priestess_var = func gravekeeper_priestess_effect(unit):
	var unit_list = get_tree().get_nodes_in_group('units')
	
	for i in unit_list:
		if i.team == unit.team and 'occult' in i.stats.attack1_element:
			i.stats.atk_temp_mod += 0.3
var gravekeeper_priestess_arr = [5, gravekeeper_priestess_var]

#############################################################################
#############################################################################

var duke_demise_var = func duke_demise_effect(unit):
	if unit.stats.hp > 2:
		unit.stats.take_damage(unit.stats.max_hp * 0.2, ['true'], 999)
		await get_tree().create_timer(0.8).timeout
var duke_demise_arr = [6, duke_demise_var]

#############################################################################
#############################################################################

var apophis_var = func apophis_effect(unit):
	var unit_list = get_tree().get_nodes_in_group('units')
	var cur_pos = globals.tile_map.local_to_map(unit.global_position)
	var ability_range = []

	for i in globals.tile_map.get_used_cells(0):
		var i_mod = abs(i.x) + abs(i.y)
		if i_mod <= 1:
			ability_range.append(cur_pos + i)
			ability_range.append(cur_pos - i)
			ability_range.append(cur_pos + Vector2i(-i.x, i.y))
			ability_range.append(cur_pos + Vector2i(i.x, -i.y))

	ability_range.erase(cur_pos)
	for i in unit_list:
		if globals.tile_map.local_to_map(i.global_position) in ability_range:
			if i.team == unit.team:
				i.stats.prot_temp_mod += 0.2
var apophis_arr = [6, apophis_var]

#############################################################################
#############################################################################

var strike_ninja_var = func strike_ninja_effect(unit):
	var unit_list = get_tree().get_nodes_in_group('units')
	var occupied_positions = []
	for cur_unit in unit_list: 
		occupied_positions.append(globals.tile_map.local_to_map(cur_unit.global_position))

	var prev_pos = unit.global_position
	var final_pos = unit.global_position + Vector2(-124 * unit.facing_direction.x, -124 * unit.facing_direction.y)
	
#	var prev_mod = unit.stats.atk_temp_mod
#	unit.stats.atk_temp_mod = 0
#	unit.stats.update_moves()
	if globals.tile_map.get_cell_tile_data(0, globals.tile_map.local_to_map(final_pos)):
		if globals.tile_map.get_cell_tile_data(0, globals.tile_map.local_to_map(final_pos)).get_custom_data("walkable"):
			if globals.tile_map.local_to_map(final_pos) not in occupied_positions:
#				unit.stats.atk_temp_mod = prev_mod
#				unit.stats.update_moves()
				await get_tree().create_timer(0.3).timeout
				var tween = get_tree().create_tween()
				tween.tween_property(unit, "global_position", final_pos, 0.1)
#				unit.final_target[0].blink_player.play('hurt')
				await get_tree().create_timer(0.15).timeout
				globals.grid.astar_grid.set_point_solid(globals.tile_map.local_to_map(prev_pos), false)
				globals.grid.astar_grid.set_point_solid(globals.tile_map.local_to_map(unit.global_position))
var strike_ninja_arr = [1, strike_ninja_var]

#############################################################################
#############################################################################

var kelbek_var = func kelbek_effect(unit):
	var unit_list = get_tree().get_nodes_in_group('units')
	var occupied_positions = []
	for cur_unit in unit_list: 
		occupied_positions.append(globals.tile_map.local_to_map(cur_unit.global_position))

	var prev_pos = unit.attacked_by.global_position
	var final_pos = unit.attacked_by.global_position + Vector2(-124 * unit.attacked_by.facing_direction.x, -124 * unit.attacked_by.facing_direction.y)
	if globals.tile_map.get_cell_tile_data(0, globals.tile_map.local_to_map(final_pos)):
		if globals.tile_map.get_cell_tile_data(0, globals.tile_map.local_to_map(final_pos)).get_custom_data("walkable"):
			if globals.tile_map.local_to_map(final_pos) not in occupied_positions:
				if globals.battle_director.turn_queue[0].unit_name == unit.attacked_by.unit_name:
					if unit.attacked_by != null:
						await get_tree().create_timer(0.4).timeout
						var tween = get_tree().create_tween()
						tween.tween_property(unit.attacked_by, "global_position", final_pos, 0.2)
						unit.attacked_by.blink_player.play('hurt')
						await get_tree().create_timer(0.8).timeout
						globals.grid.astar_grid.set_point_solid(globals.tile_map.local_to_map(prev_pos), false)
						globals.grid.astar_grid.set_point_solid(globals.tile_map.local_to_map(unit.attacked_by.global_position))
var kelbek_arr = [4, kelbek_var]

#############################################################################
#############################################################################

var zolga_var = func zolga_effect(unit):
	var unit_list = get_tree().get_nodes_in_group('units')
	var cur_pos = globals.tile_map.local_to_map(unit.global_position)
	var ability_range = []

	for i in globals.tile_map.get_used_cells(0):
		var i_mod = abs(i.x) + abs(i.y)
		if i_mod <= 1:
			ability_range.append(cur_pos + i)
			ability_range.append(cur_pos - i)
			ability_range.append(cur_pos + Vector2i(-i.x, i.y))
			ability_range.append(cur_pos + Vector2i(i.x, -i.y))

#	ability_range.erase(cur_pos)
	for i in unit_list:
		if globals.tile_map.local_to_map(i.global_position) in ability_range:
			if i != unit and i.team == unit.team:
				i.stats.heal(unit.stats.max_hp * 0.2)
				await get_tree().create_timer(0.5).timeout
var zolga_arr = [2, zolga_var]

#############################################################################
#############################################################################

var millenium_shield_var = func millenium_shield_effect(unit):
	var unit_list = get_tree().get_nodes_in_group('units')
	var cur_pos = globals.tile_map.local_to_map(unit.global_position)
	var ability_range = []

	for i in globals.tile_map.get_used_cells(0):
		var i_mod = abs(i.x) + abs(i.y)
		if i_mod <= 1:
			ability_range.append(cur_pos + i)
			ability_range.append(cur_pos - i)
			ability_range.append(cur_pos + Vector2i(-i.x, i.y))
			ability_range.append(cur_pos + Vector2i(i.x, -i.y))

	ability_range.erase(cur_pos)
	for i in unit_list:
		if globals.tile_map.local_to_map(i.global_position) in ability_range:
			if i.team == unit.team:
				i.stats.prot_temp_mod += i.stats.protection
var millenium_shield_arr = [6, millenium_shield_var]

#############################################################################
#############################################################################

var slot_machine_var = func slot_machine_effect(unit):
	var rng = randi_range(0, 2)
	if rng == 2:
		unit.stats.atk_temp_mod *= 3
		unit.stats.update_moves()
	else:
		unit.stats.atk_temp_mod = 0
		unit.stats.update_moves()
var slot_machine_arr = [1, slot_machine_var]

#############################################################################
#############################################################################

var launcher_spider_var = func launcher_spider_effect(unit):
	var unit_list = get_tree().get_nodes_in_group('units')
	var cur_pos = globals.tile_map.local_to_map(unit.global_position)
	var ability_range = []
	var enemy_list = []

	for i in globals.tile_map.get_used_cells(0):
		var i_mod = abs(i.x) + abs(i.y)
		if i_mod <= 2:
			ability_range.append(cur_pos + i)
			ability_range.append(cur_pos - i)
			ability_range.append(cur_pos + Vector2i(-i.x, i.y))
			ability_range.append(cur_pos + Vector2i(i.x, -i.y))

#	ability_range.erase(cur_pos)
	for i in unit_list:
		if globals.tile_map.local_to_map(i.global_position) in ability_range:
			if i.team != unit.team:
				enemy_list.append(i)
	await get_tree().create_timer(0.8).timeout
	for i in range(3):
		enemy_list.shuffle()
		if enemy_list[0].stats.hp > 2:
			enemy_list[0].stats.take_damage(unit.stats.atk * 0.35, ['pierce', 'fire'], unit.stats.lethality)
			await get_tree().create_timer(0.8).timeout
var launcher_spider_arr = [2, launcher_spider_var]

#############################################################################
#############################################################################

var thunder_nyan_var = func thunder_nyan_effect(unit):
	var unit_list = get_tree().get_nodes_in_group('units')
	var cur_pos = globals.tile_map.local_to_map(unit.global_position)
	var ability_range = []
	var enemy_list = []

	for i in globals.tile_map.get_used_cells(0):
		var i_mod = abs(i.x) + abs(i.y)
		if i_mod <= 2:
			ability_range.append(cur_pos + i)
			ability_range.append(cur_pos - i)
			ability_range.append(cur_pos + Vector2i(-i.x, i.y))
			ability_range.append(cur_pos + Vector2i(i.x, -i.y))

#	ability_range.erase(cur_pos)
	for i in unit_list:
		if globals.tile_map.local_to_map(i.global_position) in ability_range:
			if i.team != unit.team:
				enemy_list.append(i)

	if len(enemy_list) > 0:
		for i in range(2):
			enemy_list.shuffle()
			if enemy_list[0].stats.hp > 2:
				enemy_list[0].stats.take_damage(unit.stats.atk * 0.3, ['lightning'], unit.stats.lethality)
				await get_tree().create_timer(0.8).timeout
var thunder_nyan_arr = [6, thunder_nyan_var]

#############################################################################
#############################################################################

var last_warrior_var = func last_warrior_effect(unit):
	var unit_list = get_tree().get_nodes_in_group('units')
	var number_of_allies = -1
	
	for i in unit_list:
		if i.team == unit.team:
			number_of_allies += 1
	
	unit.stats.atk_temp_mod += -((number_of_allies) * 2 / 10)
	unit.stats.prot_temp_mod += -((number_of_allies) * 2 / 10)
	await get_tree().create_timer(0.5).timeout
var last_warrior_arr = [5, last_warrior_var]

#############################################################################
#############################################################################

var suijin_var = func suijin_effect(unit):
	var unit_list = get_tree().get_nodes_in_group('units')
	var cur_pos = globals.tile_map.local_to_map(unit.global_position)
	var ability_range = []

	for i in globals.tile_map.get_used_cells(0):
		var i_mod = abs(i.x) + abs(i.y)
		if i_mod <= 2:
			ability_range.append(cur_pos + i)
			ability_range.append(cur_pos - i)
			ability_range.append(cur_pos + Vector2i(-i.x, i.y))
			ability_range.append(cur_pos + Vector2i(i.x, -i.y))

	ability_range.erase(cur_pos)
	for i in unit_list:
		if globals.tile_map.local_to_map(i.global_position) in ability_range:
			if i.team != unit.team:
				i.stats.atk_temp_mod += -0.2
var suijin_arr = [6, suijin_var]

#############################################################################
#############################################################################

var kazejin_var = func kazejin_effect(unit):
	var unit_list = get_tree().get_nodes_in_group('units')
	var cur_pos = globals.tile_map.local_to_map(unit.global_position)
	var ability_range = []

	for i in globals.tile_map.get_used_cells(0):
		var i_mod = abs(i.x) + abs(i.y)
		if i_mod <= 2:
			ability_range.append(cur_pos + i)
			ability_range.append(cur_pos - i)
			ability_range.append(cur_pos + Vector2i(-i.x, i.y))
			ability_range.append(cur_pos + Vector2i(i.x, -i.y))

	ability_range.erase(cur_pos)
	for i in unit_list:
		if globals.tile_map.local_to_map(i.global_position) in ability_range:
			if i.team != unit.team:
				i.stats.prot_temp_mod += -0.2
var kazejin_arr = [6, kazejin_var]

#############################################################################
#############################################################################

var amazoness_queen_var = func amazoness_queen_effect(unit):
	var unit_list = get_tree().get_nodes_in_group('units')
	var cur_pos = globals.tile_map.local_to_map(unit.global_position)
	var ability_range = []

	for i in globals.tile_map.get_used_cells(0):
		var i_mod = abs(i.x) + abs(i.y)
		if i_mod <= 2:
			ability_range.append(cur_pos + i)
			ability_range.append(cur_pos - i)
			ability_range.append(cur_pos + Vector2i(-i.x, i.y))
			ability_range.append(cur_pos + Vector2i(i.x, -i.y))

	ability_range.erase(cur_pos)
	for i in unit_list:
		if globals.tile_map.local_to_map(i.global_position) in ability_range:
			if i.team == unit.team:
				i.stats.atk_temp_mod += 0.2
var amazoness_queen_arr = [6, amazoness_queen_var]

#############################################################################
#############################################################################

var harpy_queen_var = func harpy_queen_effect(unit):
	var unit_list = get_tree().get_nodes_in_group('units')
	var cur_pos = globals.tile_map.local_to_map(unit.global_position)
	var ability_range = []

	for i in globals.tile_map.get_used_cells(0):
		var i_mod = abs(i.x) + abs(i.y)
		if i_mod <= 2:
			ability_range.append(cur_pos + i)
			ability_range.append(cur_pos - i)
			ability_range.append(cur_pos + Vector2i(-i.x, i.y))
			ability_range.append(cur_pos + Vector2i(i.x, -i.y))

	ability_range.erase(cur_pos)
	for i in unit_list:
		if globals.tile_map.local_to_map(i.global_position) in ability_range:
			if i.team == unit.team:
				i.stats.leth_temp_mod += 0.2
var harpy_queen_arr = [6, harpy_queen_var]

#############################################################################
#############################################################################

var serket_var = func serket_effect(unit):
	if unit.final_target[0] != null:
		if unit.final_target[0] > 2:
			unit.stats.atk_perma_mod += 0.3
			unit.stats.update_moves()
var serket_arr = [2, serket_var]

#############################################################################
#############################################################################

var xyz_var = func xyz_effect(unit):
	if unit.final_target[0].hp > 2:
		await get_tree().create_timer(0.4).timeout
		await unit.final_target[0].stats.take_damage(unit.stats.attack1_power, ['fire'], unit.stats.lethality)
	await get_tree().create_timer(0.2).timeout
	if unit.final_target[0].hp > 2:
		await unit.final_target[0].stats.take_damage(unit.stats.attack1_power, ['nuclear'], unit.stats.lethality)
		await get_tree().create_timer(0.4).timeout
var xyz_arr = [2, xyz_var]

#############################################################################
#############################################################################

var lava_golem_var = func lava_golem_effect(unit):
	var unit_list = get_tree().get_nodes_in_group('units')
	
	for i in unit_list:
		if i.team != unit.team:
			if i.stats.hp > 2:
				i.stats.take_damage(unit.stats.atk * 0.6, ['fire'], unit.stats.lethality)
				await get_tree().create_timer(0.6).timeout
var lava_golem_arr = [6, lava_golem_var]

#############################################################################
#############################################################################
func larvae_moth_remove(unit):
	unit.stats.on_turn_end_effects.erase(larvae_moth_var)

var larvae_moth_var = func larvae_moth_effect(unit):
	larvae_moth_remove(unit)
	unit.state = unit.idle
	var blink = unit.get_child(0).get_child(6).get_child(0).get_child(0)
	var tween = get_tree().create_tween()
	tween.tween_property(blink, "color", Color("#ffffff"), 0.4)
	await get_tree().create_timer(0.8).timeout
	
	unit.unit_name = 'cocoon of evolution'
	unit.stats.get_unit_data()
	
	await get_tree().create_timer(0.2).timeout
	var tween2 = get_tree().create_tween()
	tween2.tween_property(blink, "color", Color("#ffffff00"), 0.8)
	await get_tree().create_timer(1).timeout
	
var larvae_moth_arr = [6, larvae_moth_var]

#############################################################################
#############################################################################
func cocoon_of_evolution_remove(unit):
	unit.stats.on_turn_end_effects.erase(cocoon_of_evolution_var)

var cocoon_of_evolution_var = func cocoon_of_evolution_effect(unit):
	cocoon_of_evolution_remove(unit)
	unit.state = unit.idle
	var blink = unit.get_child(0).get_child(6).get_child(0).get_child(0)
	var tween = get_tree().create_tween()
	tween.tween_property(blink, "color", Color("#ffffff"), 0.4)
	await get_tree().create_timer(0.8).timeout
	
	unit.unit_name = 'great moth'
	unit.stats.get_unit_data()
	
	await get_tree().create_timer(0.2).timeout
	var tween2 = get_tree().create_tween()
	tween2.tween_property(blink, "color", Color("#ffffff00"), 0.8)
	await get_tree().create_timer(1).timeout
var cocoon_of_evolution_arr = [6, cocoon_of_evolution_var]

#############################################################################
#############################################################################

var relinquished_var = func relinquished_effect(unit):
	var unit_list = get_tree().get_nodes_in_group('units')
	
	var combined_atk = 0
	
	for i in unit_list:
		if i.unit_name != unit.unit_name:
			combined_atk += i.stats.atk
	
	unit.stats.atk = combined_atk
	unit.stats.update_moves()
var relinquished_arr = [5, relinquished_var]

var relinquished2_var = func relinquished2_effect(unit):
	var unit_list = get_tree().get_nodes_in_group('units')
	
	var combined_atk = 0
	
	for i in unit_list:
		if i.unit_name != unit.unit_name:
			combined_atk += i.stats.atk
	
	unit.stats.atk = combined_atk
var relinquished2_arr = [0, relinquished2_var]

#############################################################################
#############################################################################
func baby_dragon_remove(unit):
	unit.stats.on_turn_start_effects.erase(baby_dragon_var)

var baby_dragon_var = func baby_dragon_effect(unit):
	if not unit.effect_memory.has('baby_dragon'):
		unit.effect_memory['baby_dragon'] = 1
	else:
		unit.effect_memory['baby_dragon'] += 1
	
	if unit.effect_memory['baby_dragon'] > 3:
		baby_dragon_remove(unit)
		unit.state = unit.idle
		var blink = unit.get_child(0).get_child(6).get_child(0).get_child(0)
		var tween = get_tree().create_tween()
		tween.tween_property(blink, "color", Color("#ffffff"), 0.4)
		await get_tree().create_timer(0.8).timeout

		unit.unit_name = 'thousand dragon'
		unit.stats.get_unit_data()

		await get_tree().create_timer(0.2).timeout
		var tween2 = get_tree().create_tween()
		tween2.tween_property(blink, "color", Color("#ffffff00"), 0.8)
		await get_tree().create_timer(1).timeout
var baby_dragon_arr = [5, baby_dragon_var]

#############################################################################
#############################################################################
func red_baby_remove(unit):
	unit.stats.on_turn_start_effects.erase(red_baby_var)

var red_baby_var = func red_baby_effect(unit):
	if not unit.effect_memory.has('red_baby'):
		unit.effect_memory['red_baby'] = 1
	else:
		unit.effect_memory['red_baby'] += 1
	
	if unit.effect_memory['red_baby'] > 3:
		red_baby_remove(unit)
		unit.state = unit.idle
		var blink = unit.get_child(0).get_child(6).get_child(0).get_child(0)
		var tween = get_tree().create_tween()
		tween.tween_property(blink, "color", Color("#ffffff"), 0.4)
		await get_tree().create_timer(0.8).timeout

		unit.unit_name = 'red-eyes black dragon'
		unit.stats.get_unit_data()

		await get_tree().create_timer(0.2).timeout
		var tween2 = get_tree().create_tween()
		tween2.tween_property(blink, "color", Color("#ffffff00"), 0.8)
		await get_tree().create_timer(1).timeout
var red_baby_arr = [5, red_baby_var]

#############################################################################
#############################################################################
func cocoon_remove(unit):
	unit.stats.on_turn_start_effects.erase(cocoon_var)

var cocoon_var = func cocoon_effect(unit):
	if not unit.effect_memory.has('cocoon'):
		unit.effect_memory['cocoon'] = 1
	else:
		unit.effect_memory['cocoon'] += 1
	
	if unit.effect_memory['cocoon'] > 2:
		cocoon_remove(unit)
		unit.state = unit.idle
		var blink = unit.get_child(0).get_child(6).get_child(0).get_child(0)
		var tween = get_tree().create_tween()
		tween.tween_property(blink, "color", Color("#ffffff"), 0.4)
		await get_tree().create_timer(0.8).timeout

		unit.unit_name = 'great moth'
		unit.stats.get_unit_data()

		await get_tree().create_timer(0.2).timeout
		var tween2 = get_tree().create_tween()
		tween2.tween_property(blink, "color", Color("#ffffff00"), 0.8)
		await get_tree().create_timer(1).timeout
var cocoon_arr = [5, cocoon_var]










