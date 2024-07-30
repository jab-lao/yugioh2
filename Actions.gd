extends Node

@onready var parent = $".."
@onready var sprite = $"../Sprites"
@onready var unit_texture = $"../Sprites/Sprite/UnitTexture"
@onready var stats = $"../Stats"


func attack(_targeted = false):
	parent.state = parent.idle
	await get_tree().create_timer(0.01).timeout
	parent.deselect_tiles()
	
	# Execute pre attack effects
	for i in stats.pre_attack_effects:
		i.call(parent)
	
	await get_tree().create_timer(0.01).timeout
	for i in parent.targets:
		i.attacked_by = parent
		i.being_untargeted()
		i.being_unaimed()
		
	var angle = Vector2(parent.facing_direction)

	# Startup
	for i in range(5):
		sprite.position -= angle * 4
		await get_tree().create_timer(0.01).timeout
	await get_tree().create_timer(0.2).timeout
	
	# Lunge
	for i in range(3):
		sprite.position -= angle * -8
		await get_tree().create_timer(0.01).timeout
	sprite.position = Vector2.ZERO
	
	# Deal damage
	if stats.attack1_aoe:
		for i in parent.targets:
			if i.stats.hp > 1:
				await i.stats.take_damage(stats.attack1_power, stats.attack1_element, stats.lethality)
	else:
		for i in parent.final_target:
			if i.stats.hp > 1:
				await i.stats.take_damage(stats.attack1_power, stats.attack1_element, stats.lethality)
				
			for j in stats.post_attack_effects:
				await j.call(parent)
	
	
	await get_tree().create_timer(0.2).timeout
	
	
	
	parent.state = parent.active
#	parent.end_my_turn()

