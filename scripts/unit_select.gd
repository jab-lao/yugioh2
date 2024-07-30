extends Node2D

@onready var listed_unit = $ListedUnit
@onready var list_lines = $UnitList/Lines
@onready var selector = $Selector
@onready var screen_tint = $"ScreenTint"
@onready var pull_screen = $PullScreen
@onready var enemy_preview = $EnemyPreview
@onready var party_list = $PartyList/VBoxContainer

@onready var boss_preview = $EnemyPreview/BossPreview
@onready var boss_portrait = $EnemyPreview/BossPreview/BossPortrait
@onready var boss_eyes = $EnemyPreview/BossPreview/BossEyes
@onready var boss_anm_player = $EnemyPreview/BossPreview/AnimationPlayer

@onready var souls_label = $ScoreUI/SoulsLabel
@onready var souls_score = $ScoreUI/SoulsScore
@onready var duels_won_score = $ScoreUI/DuelsWonScore
@onready var duels_lost_score = $ScoreUI/DuelsLostScore

@onready var bgm_player = $BGMPlayer

@onready var value = $Buttons/AutoBattle/Value

#@onready var battle_scene = preload('res://Files/Scenes/Levels/level.tscn')

var number_of_units = 0

var prize_pool = []

func _ready():
	selector.visible = false
	globals.switch_loaded_scene(1)
#	get_next_opponent()

	bgm_player.play()
	generate_encounter()
	setup_score_ui()
	setup_unit_list()
	setup_next_opponent_ui()
	
	var tween = get_tree().create_tween()
	tween.tween_property(screen_tint, "color", Color("#ffffff"), 0.3)
	await get_tree().create_timer(0.6).timeout
	
	var tween2 = get_tree().create_tween()
	tween2.tween_property(screen_tint, "color", Color("#ffffff00"), 0.6)
	await get_tree().create_timer(0.5).timeout
	selector.visible = true
	screen_tint.z_index = 11
	selector.state = 'box'
	
	trigger_unit_pull_screen()

func setup_unit_list():
	number_of_units = 0
	var unit_box = globals.player_box.duplicate()

	for i in list_lines.get_children():
		for j in i.get_children():
			j.queue_free()

	for i in unit_box:
		var new_listed_unit = listed_unit.duplicate()
		new_listed_unit.set_meta('unit', i)
		new_listed_unit.get_child(3, true).get_child(0).texture = load(globals.game_units[i]['thumbnail'])
#		new_listed_unit.get_child(6, true).visible = true
		new_listed_unit.get_child(6, true).get_child(0).text = str(globals.game_units[i]['cost'])
		number_of_units += 1
		if number_of_units <= 5:
			list_lines.get_node("Line1").add_child(new_listed_unit)
		elif number_of_units <= 10:
			list_lines.get_node("Line2").add_child(new_listed_unit)
		elif number_of_units <= 15:
			list_lines.get_node("Line3").add_child(new_listed_unit)
#		elif number_of_units <= 16:
#			list_lines.get_node("Line4").add_child(new_listed_unit)
#		elif number_of_units <= 20:
#			list_lines.get_node("Line5").add_child(new_listed_unit)
			
	await get_tree().create_timer(0.1).timeout
	select_prev_party()
	await get_tree().create_timer(0.1).timeout
#	selector.selected_unit = selector.area_2d.get_overlapping_areas()[0].get_parent().get_meta('unit')
	if selector.selected_unit != null:
		globals.player_card_viewer.update_gui2(globals.game_units[selector.selected_unit])

func select_prev_party():
	for i in party_list.get_children():
		i.queue_free()
	
	var list_of_units = []

	for line in list_lines.get_children():
		for cur_unit in line.get_children():
			list_of_units.append(cur_unit)

	for i in globals.player_party:
		if i in globals.player_box:
			for j in list_of_units:
				if j.get_meta('unit') == i:
					j.set_meta('selected', true)
					j.get_child(3, true).get_child(0, true).get_child(0, true).color = Color('#737373be')
					
					var new_party_unit = listed_unit.duplicate()
					new_party_unit.set_meta('unit', i)
					new_party_unit.get_child(6, true).get_child(0).text = str(globals.game_units[i]['cost'])
					new_party_unit.get_child(3, true).get_child(0).texture = load(globals.game_units[i]['thumbnail'])
					
					party_list.add_child(new_party_unit)

func setup_score_ui():
	souls_score.text = str(globals.max_souls - globals.used_souls)
	duels_won_score.text = str(15 - globals.duels_won)
	duels_lost_score.text = str( 3 - globals.duels_lost)
	
	if globals.auto_battle:
		value.text = 'ON'
	else:
		value.text = 'OFF'

func trigger_unit_pull_screen():
	if globals.due_pulls > 0:
		selector.prize_pos = 1
		globals.due_pulls -= 1
		get_prizes()
#		globals.prize_rar1.shuffle()
#		prize_pool = globals.prize_rar1.slice(0, 5)
		
		for i in range(globals.pull_amount):
			var new_prize_unit = listed_unit.duplicate()
			new_prize_unit.get_child(6, true).get_child(0).text = str(globals.game_units[prize_pool[i]]['cost'])
			new_prize_unit.get_child(3, true).get_child(0).texture = load(globals.game_units[prize_pool[i]]['thumbnail'])
			$PullScreen/HBoxContainer.add_child(new_prize_unit)
		
		selector.state = 'disabled'
		selector.modulate = Color('#ffffff00')
		var tween = get_tree().create_tween()
		tween.tween_property(screen_tint, "color", Color("#0000006e"), 0.5)
		await get_tree().create_timer(0.4).timeout

		var pull_screen_prev_pos = Vector2(82, 0)
		pull_screen.global_position.y = pull_screen.global_position.y - 360
		
		var tween2 = get_tree().create_tween()
		tween2.set_parallel(true)
		tween2.tween_property(pull_screen, 'global_position', pull_screen_prev_pos, 0.8)
		tween2.tween_property(pull_screen, 'modulate', Color('#ffffff'), 0.6)
		
		await get_tree().create_timer(0.87).timeout
		selector.global_position = Vector2(428,221)
		selector.modulate = Color('#ffffff')
		selector.z_index = 14
		selector.state = 'pull'
		globals.player_card_viewer.update_gui2(globals.game_units[prize_pool[0]])

func pulled(chosen_prize):
	selector.state = 'disabled'
	selector.modulate = Color('#ffffff00')
	
	# Remove pulled unit from pools
	globals.prize_rar1.erase(prize_pool[chosen_prize])
	globals.prize_rar2.erase(prize_pool[chosen_prize])
	globals.prize_rar3.erase(prize_pool[chosen_prize])
	globals.prize_rar4.erase(prize_pool[chosen_prize])
	globals.prize_rar5.erase(prize_pool[chosen_prize])
	
	globals.player_box.append(prize_pool[chosen_prize])
	setup_unit_list()
	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(screen_tint, "color", Color("#00000000"), 0.8)
	tween.tween_property(pull_screen, 'global_position', pull_screen.global_position - Vector2(0,360), 0.8)
	tween.tween_property(pull_screen, 'modulate', Color('#ffffff00'), 0.8)
	await get_tree().create_timer(1).timeout

	for i in $PullScreen/HBoxContainer.get_children():
		i.queue_free()

	if globals.due_pulls > 0:
#		await get_tree().create_timer(1).timeout
		trigger_unit_pull_screen()
		return

	selector.global_position = Vector2(346,37)
	selector.modulate = Color('#ffffff')
	selector.z_index = 7
	await get_tree().create_timer(0.1).timeout
	selector.selected_unit = selector.area_2d.get_overlapping_areas()[0].get_parent().get_meta('unit')
	globals.player_card_viewer.update_gui2(globals.game_units[selector.selected_unit])
	selector.state = 'box'

func get_prizes():
	prize_pool = []
	if globals.difficulty <= 2 and globals.difficulty < 3:
		for i in globals.pull_amount:
			var rng = randi_range(1, 100)
			if rng < 85:
				globals.prize_rar1.shuffle()
				prize_pool.append(globals.prize_rar1[0])
			else:
				globals.prize_rar2.shuffle()
				prize_pool.append(globals.prize_rar2[0])

	if globals.difficulty <= 3 and globals.difficulty < 4:
		for i in globals.pull_amount:
			var rng = randi_range(1, 100)
			if rng < 50:
				globals.prize_rar1.shuffle()
				prize_pool.append(globals.prize_rar1[0])
			elif rng < 95:
				globals.prize_rar2.shuffle()
				prize_pool.append(globals.prize_rar2[0])
			else:
				globals.prize_rar3.shuffle()
				prize_pool.append(globals.prize_rar3[0])

	if globals.difficulty <= 4 and globals.difficulty < 5:
		for i in globals.pull_amount:
			var rng = randi_range(1, 100)
			if rng < 10:
				globals.prize_rar1.shuffle()
				prize_pool.append(globals.prize_rar1[0])
			elif rng < 80:
				globals.prize_rar2.shuffle()
				prize_pool.append(globals.prize_rar2[0])
			elif rng < 95:
				globals.prize_rar3.shuffle()
				prize_pool.append(globals.prize_rar3[0])
			else: 
				globals.prize_rar4.shuffle()
				prize_pool.append(globals.prize_rar4[0])

	if globals.difficulty == 5:
		for i in globals.pull_amount:
			var rng = randi_range(1, 100)
			if rng < 50:
				globals.prize_rar2.shuffle()
				prize_pool.append(globals.prize_rar2[0])
			elif rng < 85:
				globals.prize_rar3.shuffle()
				prize_pool.append(globals.prize_rar3[0])
			else:
				globals.prize_rar4.shuffle()
				prize_pool.append(globals.prize_rar4[0])

	if globals.difficulty > 5:
		for i in globals.pull_amount:
			var rng = randi_range(1, 100)
			if rng < 20:
				globals.prize_rar2.shuffle()
				prize_pool.append(globals.prize_rar2[0])
			elif rng < 85:
				globals.prize_rar3.shuffle()
				prize_pool.append(globals.prize_rar3[0])
			else:
				globals.prize_rar4.shuffle()
				prize_pool.append(globals.prize_rar4[0])

func get_next_opponent():
	var encounter
	
	# Setup difficulty
	if globals.duels_won >= 1 and globals.duels_won < 3:
		globals.difficulty = 2
	
	elif globals.duels_won >= 3 and globals.duels_won < 6:
		globals.difficulty = 3
	
	elif globals.duels_won >= 6 and globals.duels_won < 9:
		globals.difficulty = 4
	
	elif globals.duels_won >= 9 and globals.duels_won < 13:
		globals.difficulty = 5
	
	elif globals.duels_won >= 13 and globals.duels_won < 15:
		globals.difficulty = 6
	
	elif globals.duels_won >= 15:
		globals.difficulty = 7
	
	# Get encounter
	if globals.difficulty == 1:
		encounter = globals.lv1_encounters

	elif globals.difficulty == 2:
		encounter = globals.lv2_encounters

	elif globals.difficulty == 3:
		encounter = globals.lv3_encounters

	elif globals.difficulty == 4:
		encounter = globals.lv4_encounters
	
	elif globals.difficulty == 5:
		encounter = globals.lv5_encounters
	
	elif globals.difficulty == 6:
		encounter = globals.lv6_encounters
	
	elif globals.difficulty == 7:
		encounter = globals.lv7_encounters

	encounter.shuffle()

	globals.next_encounter = encounter[0]
	encounter.pop_front()

func generate_encounter():
	# Setup difficulty
	if globals.duels_won >= 1 and globals.duels_won < 3:
		globals.difficulty = 2
	
	elif globals.duels_won >= 3 and globals.duels_won < 5:
		globals.difficulty = 3
	
	elif globals.duels_won >= 5 and globals.duels_won < 9:
		globals.difficulty = 4
	
	elif globals.duels_won >= 9 and globals.duels_won < 13:
		globals.difficulty = 5
	
	elif globals.duels_won >= 13 and globals.duels_won < 15:
		globals.difficulty = 6
	
	elif globals.duels_won >= 15:
		globals.difficulty = 7

	var encounter_party = []
	var encounter_boss = null

	# Get regular encounter
	if globals.duels_won not in [3, 7, 11, 14]:
		var rng = 0

		if globals.difficulty == 1:
			globals.cost_rar1.shuffle()
			encounter_party.append(globals.cost_rar1[0])

		elif globals.difficulty == 2:
			rng = randi_range(1, 3)
			if rng < 3:
				for i in range(3):
					globals.cost_rar1.shuffle()
					encounter_party.append(globals.cost_rar1[0])
			else:
				globals.cost_rar2.shuffle()
				encounter_party.append(globals.cost_rar2[0])
				
				globals.cost_rar1.shuffle()
				encounter_party.append(globals.cost_rar1[0])
		
		elif globals.difficulty == 3:
			rng = randi_range(1, 2)
			if rng == 1:
				for i in range(4):
					globals.cost_rar1.shuffle()
					encounter_party.append(globals.cost_rar1[0])
			elif rng == 2:
				globals.cost_rar2.shuffle()
				encounter_party.append(globals.cost_rar2[0])
				
				globals.cost_rar2.shuffle()
				encounter_party.append(globals.cost_rar2[0])

				globals.cost_rar1.shuffle()
				encounter_party.append(globals.cost_rar1[0])

		elif globals.difficulty == 4:
			rng = randi_range(1, 3)
			if rng < 3:
				for i in range(2):
					globals.cost_rar2.shuffle()
					encounter_party.append(globals.cost_rar2[0])
					
#				globals.cost_rar1.shuffle()
#				encounter_party.append(globals.cost_rar1[0])
				
				globals.cost_rar1.shuffle()
				encounter_party.append(globals.cost_rar1[0])
			else:
				for i in range(2):
					globals.cost_rar1.shuffle()
					encounter_party.append(globals.cost_rar1[0])
				
				globals.cost_rar2.shuffle()
				encounter_party.append(globals.cost_rar2[0])
		
		elif globals.difficulty == 5:
			rng = randi_range(1, 4)
			if rng <= 2:
				for i in range(3):
					globals.cost_rar2.shuffle()
					encounter_party.append(globals.cost_rar2[0])
				globals.cost_rar1.shuffle()
				encounter_party.append(globals.cost_rar1[0])

			elif rng == 3:
				for i in range(4):
					globals.cost_rar1.shuffle()
					encounter_party.append(globals.cost_rar1[0])
				
				globals.cost_rar2.shuffle()
				encounter_party.append(globals.cost_rar2[0])
			
			elif rng == 4:
				globals.cost_rar3.shuffle()
				encounter_party.append(globals.cost_rar3[0])
				
				globals.cost_rar2.shuffle()
				encounter_party.append(globals.cost_rar2[0])
				
				globals.cost_rar1.shuffle()
				encounter_party.append(globals.cost_rar1[0])
		
		elif globals.difficulty == 6:
			rng = randi_range(1, 4)
			if rng <= 2:
				for i in range(2):
					globals.cost_rar3.shuffle()
					encounter_party.append(globals.cost_rar3[0])
					
				globals.cost_rar2.shuffle()
				encounter_party.append(globals.cost_rar2[0])
				
				globals.cost_rar1.shuffle()
				encounter_party.append(globals.cost_rar1[0])

			elif rng == 3:
				for i in range(4):
					globals.cost_rar2.shuffle()
					encounter_party.append(globals.cost_rar2[0])
				globals.cost_rar1.shuffle()
				encounter_party.append(globals.cost_rar1[0])
			
			elif rng == 4:
				globals.cost_rar3.shuffle()
				encounter_party.append(globals.cost_rar3[0])
				
				globals.cost_rar2.shuffle()
				encounter_party.append(globals.cost_rar2[0])
				
				for i in range(2):
					globals.cost_rar1.shuffle()
					encounter_party.append(globals.cost_rar1[0])
		
		elif globals.difficulty == 7:
			rng = randi_range(1, 4)
			if rng <= 2:
				globals.cost_rar4.shuffle()
				encounter_party.append(globals.cost_rar4[0])
				
				globals.cost_rar3.shuffle()
				encounter_party.append(globals.cost_rar3[0])
				
				for i in range(2):
					globals.cost_rar2.shuffle()
					encounter_party.append(globals.cost_rar2[0])
					

			elif rng == 3:
				globals.cost_rar4.shuffle()
				encounter_party.append(globals.cost_rar4[0])
				
				for i in range(3):
					globals.cost_rar2.shuffle()
					encounter_party.append(globals.cost_rar2[0])
					
				globals.cost_rar1.shuffle()
				encounter_party.append(globals.cost_rar1[0])
			
			elif rng == 4:
				globals.cost_rar4.shuffle()
				encounter_party.append(globals.cost_rar4[0])
				
				for i in range(2):
					globals.cost_rar3.shuffle()
					encounter_party.append(globals.cost_rar3[0])
		
		while len(encounter_party) < 5:
			encounter_party.append(null)
		
		encounter_party.shuffle()
		globals.next_encounter = encounter_party
		globals.next_opponent = 'rarehunter'
		
	# Get Boss enconter
	else:
		if globals.duels_won <= 3:
			encounter_party = globals.selected_bosses[0][0]
			encounter_boss = globals.selected_bosses[0][1]
#			globals.lv1_bosses.shuffle()
#			encounter_party = globals.lv1_bosses[0][0]
#			encounter_boss = globals.lv1_bosses[0][1]

		elif globals.duels_won < 8 and globals.duels_won >= 4:
			encounter_party = globals.selected_bosses[1][0]
			encounter_boss = globals.selected_bosses[1][1]
#			globals.lv2_bosses.shuffle()
#			encounter_party = globals.lv2_bosses[0][0]
#			encounter_boss = globals.lv2_bosses[0][1]
		
		elif globals.duels_won < 12 and globals.duels_won >= 8:
			encounter_party = globals.selected_bosses[2][0]
			encounter_boss = globals.selected_bosses[2][1]
#			globals.lv3_bosses.shuffle()
#			encounter_party = globals.lv3_bosses[0][0]
#			encounter_boss = globals.lv3_bosses[0][1]
		
		elif globals.duels_won >= 13:
			encounter_party = globals.selected_bosses[3][0]
			encounter_boss = globals.selected_bosses[3][1]
#			globals.lv4_bosses.shuffle()
#			encounter_party = globals.lv4_bosses[0][0]
#			encounter_boss = globals.lv4_bosses[0][1]

		globals.next_encounter = encounter_party
		globals.next_opponent = encounter_boss
		
		# Setup Boss Preview
		boss_preview.visible = true
		$EnemyPreview/HBoxContainer.visible = false
		boss_portrait.texture = load('res://Files/UnitArt/yugioh/duelist/previews/%s.png' % encounter_boss)
		boss_eyes.texture = load('res://Files/UnitArt/yugioh/duelist/previews/%s2.png' % encounter_boss)
		boss_anm_player.play("play")

func setup_next_opponent_ui():
	for i in $EnemyPreview/HBoxContainer.get_children():
		i.queue_free()

	for i in globals.next_encounter:
		if i != null:
			var new_unit = listed_unit.duplicate()
			new_unit.set_meta('unit', i)
			new_unit.get_child(6, true).get_child(0).text = str(globals.game_units[i]['cost'])
			new_unit.get_child(3, true).get_child(0).texture = load(globals.game_units[i]['thumbnail'])
			$EnemyPreview/HBoxContainer.add_child(new_unit)
		else:
			var new_unit = listed_unit.duplicate()
			new_unit.modulate = Color('#ffffff00')
			$EnemyPreview/HBoxContainer.add_child(new_unit)

func get_preview_screen():
	selector.state = 'disabled'
	selector.visible = false
	selector.modulate = Color('#ffffff00')
	var tween = get_tree().create_tween()
	tween.tween_property(screen_tint, "color", Color("#0000006e"), 0.3)
	await get_tree().create_timer(0.1).timeout

#	var preview_screen_prev_pos = Vector2(1026, 0)

	var tween2 = get_tree().create_tween()
	tween2.set_parallel(true)
	tween2.tween_property(enemy_preview, 'global_position', Vector2(82, 0), 0.2)
	tween2.tween_property(enemy_preview, 'modulate', Color('#ffffff'), 0.2)

	await get_tree().create_timer(0.2).timeout
	selector.visible = true
	selector.global_position = Vector2(390,221)
	selector.modulate = Color('#ffffff')
	selector.z_index = 14
	selector.state = 'preview'

func hide_preview_screen():
	selector.state = 'disabled'
	selector.visible = false
	selector.modulate = Color('#ffffff00')

	var tween = get_tree().create_tween()
	tween.set_parallel(true)
	tween.tween_property(screen_tint, "color", Color("#00000000"), 0.3)
	tween.tween_property(enemy_preview, 'global_position', Vector2(1026, 0), 0.2)
	tween.tween_property(enemy_preview, 'modulate', Color('#ffffff00'), 0.2)
	await get_tree().create_timer(0.1).timeout

	selector.visible = true
	selector.global_position = Vector2(346,37)
	selector.modulate = Color('#ffffff')
	selector.z_index = 7
	await get_tree().create_timer(0.2).timeout
	selector.selected_unit = selector.area_2d.get_overlapping_areas()[0].get_parent().get_meta('unit')
	globals.player_card_viewer.update_gui2(globals.game_units[selector.selected_unit])
	selector.state = 'box'

func gay_filter():
	$PullScreen/ColorRect.modulate = Color()





