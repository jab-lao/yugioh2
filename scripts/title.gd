extends Node2D

@onready var item_list = $ItemList
@onready var screen_tint = $ScreenTint
@onready var reveal_label = $RevealPopUp/Label
@onready var reveal_pop_up = $RevealPopUp
@onready var start_game_pop_up = $StartGamePopUp

@onready var se_player = $ItemList/SEPlayer
@onready var bgm_player = $BGMPlayer

@onready var menu_state = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	bgm_player.play()
	item_list.grab_focus()
	item_list.select(0)
	setup_options_menu()
#	item_list.set_item_selectable(2, false)

func _physics_process(delta):
	if menu_state == 1:
		if Input.is_action_just_pressed('ui_cancel'):
			hide_option_menu()

func start_game():
	globals.setup_game()
	
	item_list.deselect(0)
	toggle_buttons(false)
	
	var tween = get_tree().create_tween()
	tween.tween_property(screen_tint, "color", Color("#0000006e"), 0.4)
	await get_tree().create_timer(0.2).timeout
	
	start_game_pop_up.global_position = Vector2(0, 97)
	
	var tween2 = get_tree().create_tween()
	tween2.tween_property(start_game_pop_up, 'modulate', Color("#ffffff"), 0.4)
	await get_tree().create_timer(0.6).timeout
	
	while not Input.is_action_pressed('ui_accept'):
		await get_tree().create_timer(0.05).timeout
	
	se_player.stream = load("res://Files/Sounds/Sound Effects/MenuSelect.wav")
	se_player.stop()
	se_player.play()
	
	screen_tint.z_index = 999
	var tween3 = get_tree().create_tween()
	tween3.tween_property(screen_tint, "color", Color("#000000"), 0.6)
	await get_tree().create_timer(0.7).timeout
	
	get_tree().change_scene_to_packed(globals.loaded_scene)

func reveal():
	if globals.can_reveal:
		pass
	else:
		item_list.deselect(2)
		toggle_buttons(false)
		reveal_label.text = 'YOU HAVE FAILED TO REVEAL'
		reveal_pop_up.modulate = Color('#ffffff00')
		
		screen_tint.color = Color('#8f0606c8')
		await get_tree().create_timer(0.1).timeout
		
		var tween = get_tree().create_tween()
		tween.tween_property(screen_tint, "color", Color("#00000000"), 0.3)
		
		await get_tree().create_timer(0.6).timeout
		tween.stop()
		var tween3 = get_tree().create_tween()
		tween3.tween_property(screen_tint, "color", Color("#0000006e"), 0.8)
		await get_tree().create_timer(0.9).timeout
		
		reveal_pop_up.global_position = Vector2(-80, 156)
		
		var tween2 = get_tree().create_tween()
		tween2.tween_property(reveal_pop_up, 'modulate', Color("#ffffff"), 0.8)
		await get_tree().create_timer(2).timeout
		
		
		var tween4 = get_tree().create_tween()
		tween4.tween_property(reveal_pop_up, 'modulate', Color("#ffffff00"), 0.6)
		
		
		tween3.stop()

		var tween5 = get_tree().create_tween()
		tween5.tween_property(screen_tint, "color", Color("#00000000"), 0.5)
		await get_tree().create_timer(0.7).timeout

		reveal_pop_up.global_position = Vector2(1020, 156)
		
#		await get_tree().create_timer(0.7).timeout
		toggle_buttons(true)
		item_list.select(2)

func _on_item_list_item_activated(index):
	if index == 0:
		se_player.stream = load("res://Files/Sounds/Sound Effects/MenuSelect.wav")
		se_player.stop()
		se_player.play()
		start_game()
	
	if index == 1:
		se_player.stream = load("res://Files/Sounds/Sound Effects/MenuSelect.wav")
		se_player.stop()
		se_player.play()
		call_option_menu()
		
	if index == 2:
		se_player.stream = load("res://Files/Sounds/Sound Effects/MenuCancel.wav")
		se_player.stop()
		se_player.play()
		reveal()

func toggle_buttons(state):
	for i in range(3):
		item_list.set_item_selectable(i - 1, state)

func _on_item_list_item_selected(index):
	se_player.stream = load("res://Files/Sounds/Sound Effects/MenuMove.wav")
	se_player.stop()
	se_player.play()

func _on_options_list_item_activated(index):
	if index == 0:
		se_player.stream = load("res://Files/Sounds/Sound Effects/MenuSelect.wav")
		se_player.stop()
		se_player.play()
		if globals.selected_collections['ygo']:
			globals.selected_collections['ygo'] = false
			$OptionsPopUp/Sprite2D.position += Vector2(0, -1)
			$OptionsPopUp/Sprite2D.texture = load("res://Files/GUI/ElementIcons/empty.png")
		else:
			globals.selected_collections['ygo'] = true
			$OptionsPopUp/Sprite2D.position += Vector2(0, 1)
			$OptionsPopUp/Sprite2D.texture = load("res://Files/GUI/ElementIcons/true.png")
		
	if index == 1:
		se_player.stream = load("res://Files/Sounds/Sound Effects/MenuSelect.wav")
		se_player.stop()
		se_player.play()
		if globals.selected_collections['pokemon']:
			globals.selected_collections['pokemon'] = false
			$OptionsPopUp/Sprite2D2.position += Vector2(0, -1)
			$OptionsPopUp/Sprite2D2.texture = load("res://Files/GUI/ElementIcons/empty.png")
		else:
			globals.selected_collections['pokemon'] = true
			$OptionsPopUp/Sprite2D2.position += Vector2(0, 1)
			$OptionsPopUp/Sprite2D2.texture = load("res://Files/GUI/ElementIcons/true.png")

func setup_options_menu():
	if not globals.selected_collections['ygo']:
		$OptionsPopUp/Sprite2D.position += Vector2(0, -1)
		$OptionsPopUp/Sprite2D.texture = load("res://Files/GUI/ElementIcons/empty.png")
	else:
		$OptionsPopUp/Sprite2D.position += Vector2(0, 1)
		$OptionsPopUp/Sprite2D.texture = load("res://Files/GUI/ElementIcons/true.png")
	
	if not globals.selected_collections['pokemon']:
		$OptionsPopUp/Sprite2D2.position += Vector2(0, -1)
		$OptionsPopUp/Sprite2D2.texture = load("res://Files/GUI/ElementIcons/empty.png")
	else:
		$OptionsPopUp/Sprite2D2.position += Vector2(0, 1)
		$OptionsPopUp/Sprite2D2.texture = load("res://Files/GUI/ElementIcons/true.png")

func call_option_menu():
	$OptionsPopUp/OptionsList.select(0)
	var tween = get_tree().create_tween()
	tween.tween_property($OptionsPopUp, "modulate", Color('#ffffff'), 0.2)
	await get_tree().create_timer(0.2).timeout
	menu_state = 1
	$OptionsPopUp/OptionsList.grab_focus()
	$OptionsPopUp/OptionsList.select(0)

func hide_option_menu():
	var tween = get_tree().create_tween()
	tween.tween_property($OptionsPopUp, "modulate", Color('#ffffff00'), 0.2)
	await get_tree().create_timer(0.2).timeout
	menu_state = 0
	item_list.grab_focus()
	item_list.select(1)

func _on_options_list_item_selected(index):
	se_player.stream = load("res://Files/Sounds/Sound Effects/MenuMove.wav")
	se_player.stop()
	se_player.play()
