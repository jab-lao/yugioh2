extends Node

@onready var parent = $".."
@onready var sprite = $"../Sprites"
@onready var blink_player = $"../BlinkPlayer"
@onready var unit_texture = $"../Sprites/Sprite/UnitTexture"
@onready var sprite_border = $"../Sprites/SpriteBorder"
@onready var back_sprite_2 = $"../Sprites/BackSprite2"
@onready var cost_label = $"../Sprites/CostBG/CostLabel"


@onready var ai = $"../AI"
@onready var hp_bar = $"../Sprites/HPBar"
@onready var hp_bar_shadow = $"../Sprites/HPBarShadow"

@onready var affinity_pop_up = $"../AffinityPopUp"
@onready var weak_list = $"../AffinityPopUp/VBoxContainer/WeakList"
@onready var resist_list = $"../AffinityPopUp/VBoxContainer/ResistList"


var cost = 1
var max_hp = 1000
var atk = 300
var agi = 300
var movement = 3
var skill = 300
var protection = 1
var crit_chance = 1
var lethality = 0

var hp = max_hp

var shield_value = 0

var affinities

var atk_temp_mod = 1
var atk_perma_mod = 1

var agi_temp_mod = 1
var agi_perma_mod = 1

var prot_temp_mod = 1
var prot_perma_mod = 1

var leth_temp_mod = 0
var leth_perma_mod = 0

var movement_temp_mod = 0
var movement_perma_mod = 0

var attack1_power = 1
var attack1_hits = 1
var attack1_element = ['strike']
var attack1_effect_text = 'attack1 effect'
var attack1_effect_func = null
var attack1_range = [Vector2i(1, 0), Vector2i(2, 0)]
var attack1_aoe = false

var attack2_has_attack = false
var attack2_power = 1
var attack2_hits = 1
var attack2_element = ['strike']
var attack2_effect_text = 'attack2 effect'
var attack2_effect_func = null
var attack2_range = [Vector2i(1, 0), Vector2i(2, 0)]
var attack2_aoe = false

var unit_name

var texture

var last_damage_dealt = 0
var last_damage_taken = 0

var on_spawn_effects = []

var pre_attack_effects = []
var post_attack_effects = []

var pre_damage_taken_effects = []
var post_damage_taken_effects = []

var on_turn_start_effects = []
var on_turn_end_effects = []

var on_death_effects = []

var on_enemy_moved_into_range_effects = []

var on_combat_start_effects = []

var pre_heal_effects = []

var on_hit_effects = []

func _ready():
	await get_tree().create_timer(0.1).timeout
	await get_unit_data()
	for i in on_spawn_effects:
		on_spawn_effects[0].call(parent)

	# Add affinities to UI
	for key in affinities:
		if affinities[key] > 1:
			add_weakness_icon(key)
		if affinities[key] < 1:
			add_resistance_icon(key)

func get_unit_data():
	var unit = globals.game_units[parent.unit_name]
	unit_name = ['name']
	cost = unit['cost']
	cost_label.text = str(cost)

	max_hp = unit['max_hp'] * gen_data.base_hp[cost - 1]
	hp = max_hp
	atk = unit['atk'] * gen_data.base_atk[cost - 1]
	agi = unit['agi'] * gen_data.base_agi[cost - 1]
	movement = unit['movement']
	parent.unit_texture.texture = load(unit['thumbnail'])
	
	texture = unit['art']
	
	protection = unit['protection'] * gen_data.base_protection[cost - 1]
	lethality = unit['lethality'] * gen_data.base_lethality[cost - 1]
	
	affinities = globals.game_units[parent.unit_name]['affinities']
	
	hp_bar.max_value = max_hp
	hp_bar.value = hp
	hp_bar_shadow.max_value = max_hp
	hp_bar_shadow.value = hp
	
	update_moves()
	update_shield()

	if attack1_effect_func != null:
		for i in attack1_effect_func:
			if i[0] == 0:
				on_spawn_effects.append(i[1])
			
			elif i[0] == 1:
				pre_attack_effects.append(i[1])

			elif i[0] == 2:
				post_attack_effects.append(i[1])
			
			elif i[0] == 3:
				pre_damage_taken_effects.append(i[1])
				
			elif i[0] == 4:
				post_damage_taken_effects.append(i[1])
			
			elif i[0] == 5:
				on_turn_start_effects.append(i[1])
				
			elif i[0] == 6:
				on_turn_end_effects.append(i[1])
			
			elif i[0] == 9:
				on_combat_start_effects.append(i[1])
				
			elif i[0] ==1:
				on_hit_effects.append(i[1])

func evaluate_damage(damage_received, damage_element, damage_lethality):
	var damage_mod = evaluate_affinity(damage_element)
	var protection_mod = protection * prot_temp_mod * prot_perma_mod

	if damage_lethality > 0:
		protection_mod = clamp((protection_mod - (damage_lethality * 0.01)), 1, 999999)

	return (damage_received * damage_mod) / protection_mod

func take_damage(damage_received, damage_element, damage_lethality):
	for i in pre_damage_taken_effects:
		i.call(parent)
	
	var damage_mod = evaluate_affinity(damage_element)
	var protection_mod = protection * prot_temp_mod * prot_perma_mod
	if damage_element == ['true']:
		protection_mod = 1

	if damage_lethality > 0:
		protection_mod = clamp((protection_mod - (damage_lethality * 0.01)), 1, 999999)

	var damage_taken = (damage_received * damage_mod) / protection_mod
	
	var prev_shield = shield_value
	shield_value -= damage_taken
	if shield_value < 1: shield_value = 0
	damage_taken -= prev_shield
	
	update_shield()
	if damage_taken < 1: damage_taken = 0
	
	if round(damage_taken) > 1:
		damage_taken = round(damage_taken)
		hp = clamp(hp - damage_taken, 0, max_hp)

		damage_pop(damage_taken, damage_element, damage_mod)

#		for i in damage_element:
#			play_hit_particle(i)
		
		blink_player.play('hurt')
		
		hp_bar.value = hp
		await get_tree().create_timer(0.3).timeout
		while hp_bar_shadow.value > hp_bar.value:
			hp_bar_shadow.value -= 50
			await get_tree().create_timer(0.002).timeout
		hp_bar_shadow.value = hp_bar.value - 1
		if hp <= 1:
			await parent.die()
	else:
		damage_pop('No Damage!', ['other'], 0)
	
	for i in post_damage_taken_effects:
		i.call(parent)

func heal(heal_amount):
	for i in pre_heal_effects:
		i.call(parent)
	
	var healing = round(heal_amount)
	hp = clamp(hp + healing, 0, max_hp)
	
	damage_pop(healing, ['heal'], 0)
	
	blink_player.play('heal')
#	await get_tree().create_timer(0.3).timeout
	while hp > hp_bar.value:
		hp_bar.value += 5
		await get_tree().create_timer(0.005).timeout

	await blink_player.animation_finished
	
	hp_bar_shadow.value = hp

func evaluate_affinity(damage_element):
	var damage_mod = 1
	
	for i in len(damage_element):
		damage_mod *= affinities[damage_element[i]]
	
	return damage_mod

func damage_pop(damage_received, damage_element, affinity_value):
	var healing = false
	var other = false
	if damage_element[0] == 'heal':
		healing = true
	if damage_element[0] == 'other':
		other = true
	
	
	var pop = load("res://Files/GUI/damage_pop_up.tscn").instantiate()
	pop.dmg_element = damage_element
	pop.init(str(damage_received), affinity_value, healing, other)
	pop.global_position = parent.global_position
	pop.global_position.y -= 35
	parent.add_child(pop)

func update_moves():
	var unit = globals.game_units[parent.unit_name]
	
	var effective_atk = atk * atk_perma_mod * atk_temp_mod
	
	lethality = lethality + leth_perma_mod + leth_temp_mod
	
	var attack1 = unit['attack1']
	attack1_power = round(effective_atk * attack1['power'][0] + attack1['power'][1])
	attack1_hits = attack1['hits']
	attack1_element = attack1['element']
	attack1_effect_text = attack1['effect text']
	attack1_effect_func = attack1['effect function']
	attack1_range = attack1['range']
	attack1_aoe = attack1['aoe']
	
	var attack2 = unit['attack2']
	attack2_has_attack = attack2['has attack']
	if attack2['has attack']:
		attack2_power = round(effective_atk * attack2['power'][0] + attack2['power'][1])
		attack2_hits = attack2['hits']
		attack2_element = attack2['element']
		attack2_effect_text = attack2['effect text']
		attack2_effect_func = attack2['effect function']
		attack2_aoe = attack2['aoe']

func add_weakness_icon(weakness):
	var new_icon = Control.new()
	new_icon.custom_minimum_size = Vector2(32,32)
	var new_sprite = Sprite2D.new()
	new_sprite.offset = Vector2(16,16)
	new_sprite.texture = load("res://Files/GUI/ElementIcons/{0}.png".format([weakness]))
	new_icon.add_child(new_sprite)
	weak_list.add_child(new_icon)

func add_resistance_icon(resistance):
	var new_icon = Control.new()
	new_icon.custom_minimum_size = Vector2(32,32)
	var new_sprite = Sprite2D.new()
	new_sprite.offset = Vector2(16,16)
	new_sprite.texture = load("res://Files/GUI/ElementIcons/{0}.png".format([resistance]))
	new_icon.add_child(new_sprite)
	resist_list.add_child(new_icon)

func toggle_aff_box(switch):
	if switch == true:
		var tween = get_tree().create_tween()
		tween.tween_property(affinity_pop_up, "modulate", Color("#ffffff"), 0.2)
	else:
		var tween = get_tree().create_tween()
		tween.tween_property(affinity_pop_up, "modulate", Color("#ffffff00"), 0.2)

func play_hit_particle(element):
	if element == 'strike':
		$"../Particles/Strike".emitting = true
	elif element == 'slash':
		var rng = randi_range(1, 3)
		if rng == 1:
			$"../Particles/Slash".emitting = true
		elif rng == 2:
			$"../Particles/Slash2".emitting = true
		elif rng == 3:
			$"../Particles/Slash3".emitting = true
	elif element == 'pierce':
		$"../Particles/Pierce".emitting = true
	elif element == 'fire':
		$"../Particles/Fire".emitting = true
	elif element == 'water':
		$"../Particles/Water".emitting = true
	elif element == 'air':
		$"../Particles/Air".emitting = true
	elif element == 'earth':
		$"../Particles/Earth".emitting = true
	elif element == 'virtue':
		$"../Particles/Virtue".emitting = true
	elif element == 'vice':
		$"../Particles/Vice".emitting = true
	elif element == 'true':
		$"../Particles/True".emitting = true
	elif element == 'lightning':
		$"../Particles/Lightning".emitting = true
	elif element == 'arcane':
		$"../Particles/Arcane".emitting = true
	elif element == 'occult':
		$"../Particles/Occult".emitting = true
	elif element == 'nuclear':
		$"../Particles/Nuclear".emitting = true

func update_shield():
	if shield_value < 1: 
		shield_value = 0
		$"../Sprites/ShieldDisplay".visible = false
	else:
		$"../Sprites/ShieldDisplay/ShieldLabel".text = str(round(shield_value))
		$"../Sprites/ShieldDisplay".visible = true
