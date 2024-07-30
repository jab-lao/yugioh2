extends CharacterBody2D

@onready var area_2d = $Area2D
@onready var listed_unit = $"../ListedUnit"
@onready var party_list = $"../PartyList/VBoxContainer"
@onready var unit_select = $".."
@onready var pull_screen = $"../PullScreen"
@onready var auto_battle_value = $"../Buttons/AutoBattle/Value"
@onready var se_player = $SEPlayer


var moving = false
var cell_size = 132
var cursor_speed = 10
var state = 'disabled'

var selected_unit = null

var prize_pos = 1
var ui_pos = 0

@onready var ui_buttons = $"../Buttons".get_children()

func _ready():
	await get_tree().create_timer(0.1).timeout
	if area_2d.get_overlapping_areas():
		selected_unit = area_2d.get_overlapping_areas()[0].get_parent().get_meta('unit')
		
	for i in ui_buttons:
		i.get_child(1).modulate = Color('#ffffff78')

func _process(_delta):
	if state == 'box':
		input()
	if state == 'pull':
		pull_input()
	if state == 'ui':
		ui_input()
	if state == 'preview':
		preview_input()

	move_and_slide()

func input():
	if moving == false:
		if Input.is_action_pressed("ui_right"):
			play_selector_move_SE()
			if global_position.x < 842:
				moving = true
				var prev_pos = global_position
				while global_position <= prev_pos + Vector2(cell_size, 0):
					global_position = global_position + Vector2(cursor_speed, 0)
					await get_tree().create_timer(0.01).timeout
				global_position = prev_pos + Vector2(cell_size, 0)
				moving = false
				if area_2d.get_overlapping_areas():
					selected_unit = area_2d.get_overlapping_areas()[0].get_parent().get_meta('unit')
					globals.player_card_viewer.update_gui2(globals.game_units[selected_unit])
			else:
				visible = false
				ui_pos = 0
				state = 'ui'
				ui_buttons[ui_pos].get_child(1).modulate = Color('#ffffffff')

		if Input.is_action_pressed("ui_left") and global_position.x > 355:
			play_selector_move_SE()
			moving = true
			var prev_pos = global_position
			while global_position >= prev_pos + Vector2(-cell_size, 0):
				global_position = global_position + Vector2(-cursor_speed, 0)
				await get_tree().create_timer(0.01).timeout
			global_position = prev_pos + Vector2(-cell_size, 0)
			moving = false
			if area_2d.get_overlapping_areas():
				selected_unit = area_2d.get_overlapping_areas()[0].get_parent().get_meta('unit')
				globals.player_card_viewer.update_gui2(globals.game_units[selected_unit])

		if Input.is_action_pressed("ui_down"):
			play_selector_move_SE()
			if global_position.y < 260:
				moving = true
				var prev_pos = global_position
				while global_position <= prev_pos + Vector2(0, cell_size):
					global_position = global_position + Vector2(0, cursor_speed)
					await get_tree().create_timer(0.01).timeout
				global_position = prev_pos + Vector2(0, cell_size)
				moving = false
				if area_2d.get_overlapping_areas():
					selected_unit = area_2d.get_overlapping_areas()[0].get_parent().get_meta('unit')
					globals.player_card_viewer.update_gui2(globals.game_units[selected_unit])
			else:
				if globals.duels_won not in [3, 7, 11, 14]:
					moving = true
					change_selector_focus('preview')
				

		if Input.is_action_pressed("ui_up") and global_position.y > 86:
			play_selector_move_SE()
			moving = true
			var prev_pos = global_position
			while global_position >= prev_pos + Vector2(0, -cell_size):
				global_position = global_position + Vector2(0, -cursor_speed)
				await get_tree().create_timer(0.01).timeout
			global_position = prev_pos + Vector2(0, -cell_size)
			moving = false
			if area_2d.get_overlapping_areas():
				selected_unit = area_2d.get_overlapping_areas()[0].get_parent().get_meta('unit')
				globals.player_card_viewer.update_gui2(globals.game_units[selected_unit])

		if Input.is_action_just_pressed("ui_accept"):
			if area_2d.get_overlapping_areas():
				var cur_unit = area_2d.get_overlapping_areas()[0].get_parent()
				if cur_unit.get_meta('selected') == false:
					if len(globals.player_party) < 5:
						add_to_party(selected_unit, cur_unit)
				else:
					play_selector_move_SE()
					remove_from_party(selected_unit, cur_unit)
	
	if Input.is_action_just_pressed("ui_cancel"):
			reset_selector()
func pull_input():
	if moving == false:
		if Input.is_action_pressed("ui_right") and prize_pos < globals.pull_amount:
			play_selector_move_SE()
			moving = true
			prize_pos += 1
			var prev_pos = global_position
			while global_position <= prev_pos + Vector2(cell_size, 0):
				global_position = global_position + Vector2(cursor_speed, 0)
				await get_tree().create_timer(0.01).timeout
			global_position = prev_pos + Vector2(cell_size, 0)
			moving = false
			selected_unit = unit_select.prize_pool[prize_pos - 1]
			globals.player_card_viewer.update_gui2(globals.game_units[selected_unit])

		if Input.is_action_pressed("ui_left") and prize_pos > 1:
			play_selector_move_SE()
			moving = true
			prize_pos -= 1
			var prev_pos = global_position
			while global_position >= prev_pos + Vector2(-cell_size, 0):
				global_position = global_position + Vector2(-cursor_speed, 0)
				await get_tree().create_timer(0.01).timeout
			global_position = prev_pos + Vector2(-cell_size, 0)
			moving = false
			selected_unit = unit_select.prize_pool[prize_pos - 1]
			globals.player_card_viewer.update_gui2(globals.game_units[selected_unit])
			
		if Input.is_action_just_pressed("ui_accept"):
			play_selector_accept_SE()
			unit_select.pulled(prize_pos - 1)

func ui_input():
	if moving == false:
		if Input.is_action_pressed("ui_right"):
			play_selector_move_SE()
			pass

		if Input.is_action_pressed("ui_left"):
			play_selector_move_SE()
			moving = true
			ui_buttons[ui_pos].get_child(1).modulate = Color('#ffffff78')
			visible = true
			ui_pos = 0
			state = 'box'
			global_position = Vector2(874, 301)
			await get_tree().create_timer(0.2).timeout
			moving = false

		if Input.is_action_just_pressed("ui_down") and ui_pos < 2:
			play_selector_move_SE()
			ui_buttons[ui_pos].get_child(1).modulate = Color('#ffffff78')
			ui_pos += 1
			ui_buttons[ui_pos].get_child(1).modulate = Color('#ffffffff')
			
		if Input.is_action_just_pressed("ui_up") and ui_pos > 0:
			play_selector_move_SE()
			ui_buttons[ui_pos].get_child(1).modulate = Color('#ffffff78')
			ui_pos -= 1
			ui_buttons[ui_pos].get_child(1).modulate = Color('#ffffffff')

		if Input.is_action_just_pressed("ui_accept"):
			play_selector_accept_SE()
			if ui_pos == 0 and len(globals.player_party) > 0:
				get_tree().change_scene_to_packed(globals.loaded_scene)

#			elif ui_pos == 1:
#				ui_buttons[ui_pos].get_child(1).modulate = Color('#ffffff78')
#				unit_select.get_preview_screen()
			elif ui_pos == 1:
				if globals.auto_battle:
					globals.auto_battle = false
					auto_battle_value.text = 'OFF'
				else:
					globals.auto_battle = true
					auto_battle_value.text = 'ON'
	
	

func preview_input():
	if moving == false:
		if Input.is_action_pressed("ui_right"):
			play_selector_move_SE()
			if global_position.x < 842:
				moving = true
				var prev_pos = global_position
				while global_position <= prev_pos + Vector2(cell_size, 0):
					global_position = global_position + Vector2(cursor_speed, 0)
					await get_tree().create_timer(0.01).timeout
				global_position = prev_pos + Vector2(cell_size, 0)
				moving = false
				if area_2d.get_overlapping_areas()[0].get_parent().get_meta('unit') != 'none':
					selected_unit = area_2d.get_overlapping_areas()[0].get_parent().get_meta('unit')
					globals.player_card_viewer.update_gui2(globals.game_units[selected_unit])
			
			else:
				visible = false
				ui_pos = 0
				state = 'ui'
				ui_buttons[ui_pos].get_child(1).modulate = Color('#ffffffff')

		if Input.is_action_pressed("ui_left") and global_position.x > 346:
			play_selector_move_SE()
			moving = true
			var prev_pos = global_position
			while global_position >= prev_pos + Vector2(-cell_size, 0):
				global_position = global_position + Vector2(-cursor_speed, 0)
				await get_tree().create_timer(0.01).timeout
			global_position = prev_pos + Vector2(-cell_size, 0)
			moving = false
			if area_2d.get_overlapping_areas()[0].get_parent().get_meta('unit') != 'none':
				selected_unit = area_2d.get_overlapping_areas()[0].get_parent().get_meta('unit')
				globals.player_card_viewer.update_gui2(globals.game_units[selected_unit])
			
		if Input.is_action_pressed("ui_up"):
			play_selector_move_SE()
			change_selector_focus('box')

		if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("ui_cancel"):
#			unit_select.hide_preview_screen()
#			await get_tree().create_timer(0.3).timeout
#			prize_pos = 1
			pass

func change_selector_focus(focus):
	if focus == 'preview':
		if globals.duels_won not in [3, 7, 11, 14]:
			global_position.y = 588
			await get_tree().create_timer(0.1).timeout
			state = 'preview'
			if area_2d.get_overlapping_areas()[0].get_parent().get_meta('unit') != 'none':
				selected_unit = area_2d.get_overlapping_areas()[0].get_parent().get_meta('unit')
				globals.player_card_viewer.update_gui2(globals.game_units[selected_unit])
			moving = false

	if focus == 'box':
		global_position.y = 301
		await get_tree().create_timer(0.1).timeout
		state = 'box'
		if area_2d.get_overlapping_areas():
			selected_unit = area_2d.get_overlapping_areas()[0].get_parent().get_meta('unit')
			globals.player_card_viewer.update_gui2(globals.game_units[selected_unit])

func add_to_party(unit_name, unit_node):
	if globals.used_souls + globals.game_units[unit_name]['cost'] <= globals.max_souls:
		play_selector_accept_SE()
		globals.used_souls += globals.game_units[unit_name]['cost']
		unit_select.souls_score.text = str(globals.max_souls - globals.used_souls)
		unit_node.set_meta('selected', true)
		unit_node.get_child(3, true).get_child(0, true).get_child(0, true).color = Color('#737373be')

		globals.player_party.append(unit_name)
	#	var unit = globals.game_units[unit_name] 

		var new_party_unit = listed_unit.duplicate()
		new_party_unit.set_meta('unit', unit_name)
#		new_party_unit.get_child(6, true).visible = false
		new_party_unit.get_child(6, true).get_child(0).text = str(globals.game_units[unit_name]['cost'])
		new_party_unit.get_child(3, true).get_child(0).texture = load(globals.game_units[unit_name]['thumbnail'])
		
		party_list.add_child(new_party_unit)
	else:
		se_player.stream = load("res://Files/Sounds/Sound Effects/MenuCancel.wav")
		se_player.stop()
		se_player.play()
		unit_node.get_child(5).play("RESET")
		await unit_node.get_child(5).animation_finished
		unit_node.get_child(5).play("can't pick")

func remove_from_party(unit_name, unit_node):
	globals.used_souls -= globals.game_units[unit_name]['cost']
	unit_select.souls_score.text = str(globals.max_souls - globals.used_souls)
	unit_node.set_meta('selected', false)
	unit_node.get_child(3, true).get_child(0, true).get_child(0, true).color = Color('#ffffff00')
	
	globals.player_party.erase(unit_name)
	
	for i in party_list.get_children():
		if i.get_meta('unit') == unit_name:
			i.queue_free()

func play_selector_move_SE():
	se_player.stream = load("res://Files/Sounds/Sound Effects/MenuMove.wav")
	se_player.stop()
	se_player.play()

func play_selector_accept_SE():
	se_player.stream = load("res://Files/Sounds/Sound Effects/MenuSelect.wav")
	se_player.stop()
	se_player.play()

func reset_selector():
	
	
	
	global_position = Vector2(346, 37)
	await get_tree().create_timer(0.1).timeout
	state = 'box'
	await get_tree().create_timer(0.01).timeout
	if area_2d.get_overlapping_areas()[0].get_parent().get_meta('unit') != 'none':
		selected_unit = area_2d.get_overlapping_areas()[0].get_parent().get_meta('unit')
		globals.player_card_viewer.update_gui2(globals.game_units[selected_unit])

