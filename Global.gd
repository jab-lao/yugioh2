extends Node

var battle_director = Node
var grid = Node
var tile_map = Node
var selected_tiles = Node

var loaded_scene = preload("res://Files/Scenes/UnitSelect/unit_select.tscn")

#var loaded_battle = preload('res://Files/Scenes/Levels/level.tscn')

var can_reveal = false
var revealed = false

enum {
	player,
	enemy
}

var cur_turn = player

var player_card_viewer
var cur_unit
var player_cur_unit
var enemy_cur_unit

var max_souls = 3
var used_souls = 0
var duels_fought = 0
var duels_won = 0
var duels_lost = 0
var bosses_defeated = 0
var difficulty = 1

var auto_battle = false

var player_box = []
var player_party = []

var next_encounter = []
var next_opponent = 'rarehunter'

var due_pulls = 2
var pull_amount = 4

var prize_rar1 = []
var prize_rar2 = []
var prize_rar3 = []
var prize_rar4 = []
var prize_rar5 = []

var cost_rar1 = []
var cost_rar2 = []
var cost_rar3 = []
var cost_rar4 = []
var cost_rar5 = []

var selected_collections = {
	'ygo': true,
	'pokemon': false,
	'smt': false
}
var game_units = {}


var lv1_bosses = []
var lv2_bosses = []
var lv3_bosses = []
var lv4_bosses = []
var selected_bosses = []

func _ready():
	pass
#	for i in encounters.ygo_bosses[1]:
#		for j in i[0]:
#			if j != null:
#				if ygo['units'][j] == null:
#					print(j)


func setup_game():
	max_souls = 3
	used_souls = 0
	duels_fought = 0
	duels_won = 0
	duels_lost = 0
	bosses_defeated = 0
	difficulty = 1
	due_pulls = 2
	game_units = {}
	var number_of_collections = 0
	var collection_index = 0

	auto_battle = false

	player_box = []
	player_party = []
	selected_bosses = []

	next_encounter = []
	next_opponent = 'rarehunter'
	
	if not selected_collections['ygo'] and not selected_collections['pokemon']:
		selected_collections['ygo'] = true
	
	if selected_collections['ygo'] == true:
		number_of_collections += 1
		game_units.merge(ygo.units)
		for i in ygo.units:
#			if load(ygo.units[i]['art']) == null:
#				print(ygo.units[i]['name'])
			if ygo.units[i]['rarity'] == 1:
				prize_rar1.append(i)
			elif ygo.units[i]['rarity'] == 2:
				prize_rar2.append(i)
			elif ygo.units[i]['rarity'] == 3:
				prize_rar3.append(i)
			elif ygo.units[i]['rarity'] == 4:
				prize_rar4.append(i)
			elif ygo.units[i]['rarity'] == 5:
				prize_rar5.append(i)
			
			if ygo.units[i]['cost'] == 1:
				cost_rar1.append(i)
			elif ygo.units[i]['cost'] == 2:
				cost_rar2.append(i)
			elif ygo.units[i]['cost'] == 3:
				cost_rar3.append(i)
			elif ygo.units[i]['cost'] == 4:
				cost_rar4.append(i)
			elif ygo.units[i]['cost'] == 5:
				cost_rar5.append(i)
			
		lv1_bosses.append(encounters.ygo_bosses[0].duplicate(true))
		lv2_bosses.append(encounters.ygo_bosses[1].duplicate(true))
		lv3_bosses.append(encounters.ygo_bosses[2].duplicate(true))
		lv4_bosses.append(encounters.ygo_bosses[3].duplicate(true))

	if selected_collections['pokemon'] == true:
		number_of_collections += 1
		game_units.merge(ygo.pokemon)
		for i in ygo.pokemon:
#			if load(ygo.pokemon[i]['art']) == null:
#				print(ygo.pokemon[i]['name'])
			if ygo.pokemon[i]['rarity'] == 1:
				prize_rar1.append(i)
			elif ygo.pokemon[i]['rarity'] == 2:
				prize_rar2.append(i)
			elif ygo.pokemon[i]['rarity'] == 3:
				prize_rar3.append(i)
			elif ygo.pokemon[i]['rarity'] == 4:
				prize_rar4.append(i)
			elif ygo.pokemon[i]['rarity'] == 5:
				prize_rar5.append(i)
			
			if ygo.pokemon[i]['cost'] == 1:
				cost_rar1.append(i)
			elif ygo.pokemon[i]['cost'] == 2:
				cost_rar2.append(i)
			elif ygo.pokemon[i]['cost'] == 3:
				cost_rar3.append(i)
			elif ygo.pokemon[i]['cost'] == 4:
				cost_rar4.append(i)
			elif ygo.pokemon[i]['cost'] == 5:
				cost_rar5.append(i)

		lv1_bosses.append(encounters.pkmn_bosses[0].duplicate(true))
		lv2_bosses.append(encounters.pkmn_bosses[1].duplicate(true))
		lv3_bosses.append(encounters.pkmn_bosses[2].duplicate(true))
		lv4_bosses.append(encounters.pkmn_bosses[3].duplicate(true))
	
	if number_of_collections > 1:
		collection_index = randi_range(0, 1)
	lv1_bosses[collection_index].shuffle()
	selected_bosses.append(lv1_bosses[collection_index][0])

	if number_of_collections > 1:
		collection_index = randi_range(0, 1)
	lv2_bosses[collection_index].shuffle()
	selected_bosses.append(lv2_bosses[collection_index][0])

	if number_of_collections > 1:
		collection_index = randi_range(0, 1)
	lv3_bosses[collection_index].shuffle()
	selected_bosses.append(lv3_bosses[collection_index][0])

	if number_of_collections > 1:
		collection_index = randi_range(0, 1)
	lv4_bosses[collection_index].shuffle()
	selected_bosses.append(lv4_bosses[collection_index][0])
	
func switch_loaded_scene(scene):
	if scene == 1:
		loaded_scene = preload('res://Files/Scenes/Levels/level.tscn')
	elif scene == 2:
		loaded_scene = preload("res://Files/Scenes/UnitSelect/unit_select.tscn")

