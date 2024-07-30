extends CharacterBody2D

@onready var area_2d = $Area2D

var moving = false
var cell_size = 124
var cursor_speed = 10
var selected_unit = null

var state = 'disabled'

func _process(_delta):
	if state == 'active':
		input()
		move_and_slide()

func input():
	if moving == false:
		if Input.is_action_pressed("ui_right"):
			if global_position.x < 496:
				moving = true
				var prev_pos = global_position
				while global_position <= prev_pos + Vector2(cell_size, 0):
					global_position = global_position + Vector2(cursor_speed, 0)
					await get_tree().create_timer(0.01).timeout
				global_position = prev_pos + Vector2(cell_size, 0)
				moving = false
				if area_2d.get_overlapping_bodies():
					selected_unit = area_2d.get_overlapping_bodies()[0]
					globals.player_card_viewer.update_gui(selected_unit)

		if Input.is_action_pressed("ui_left") and global_position.x > 70:
			moving = true
			var prev_pos = global_position
			while global_position >= prev_pos + Vector2(-cell_size, 0):
				global_position = global_position + Vector2(-cursor_speed, 0)
				await get_tree().create_timer(0.01).timeout
			global_position = prev_pos + Vector2(-cell_size, 0)
			moving = false
			if area_2d.get_overlapping_bodies():
				selected_unit = area_2d.get_overlapping_bodies()[0]
				globals.player_card_viewer.update_gui(selected_unit)

		if Input.is_action_pressed("ui_down") and global_position.y < 496:
			moving = true
			var prev_pos = global_position
			while global_position <= prev_pos + Vector2(0, cell_size):
				global_position = global_position + Vector2(0, cursor_speed)
				await get_tree().create_timer(0.01).timeout
			global_position = prev_pos + Vector2(0, cell_size)
			moving = false
			if area_2d.get_overlapping_bodies():
				selected_unit = area_2d.get_overlapping_bodies()[0]
				globals.player_card_viewer.update_gui(selected_unit)

		if Input.is_action_pressed("ui_up") and global_position.y > 86:
			moving = true
			var prev_pos = global_position
			while global_position >= prev_pos + Vector2(0, -cell_size):
				global_position = global_position + Vector2(0, -cursor_speed)
				await get_tree().create_timer(0.01).timeout
			global_position = prev_pos + Vector2(0, -cell_size)
			moving = false
			if area_2d.get_overlapping_bodies():
				selected_unit = area_2d.get_overlapping_bodies()[0]
				globals.player_card_viewer.update_gui(selected_unit)




