extends Node2D

var ball_magnitude = 50
var p1_score = 0
var p2_score = 0
var esc_option:bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	p1_score = 0
	p2_score = 0
	$UI/P2_Score/Label.text = str(p2_score)
	$UI/P1_Score/Label.text = str(p1_score)
	$OpeningMenu.show()
	$SettingsMenu.hide()
	hide_game()

func hide_game():
	get_tree().call_group("game_objects", "hide")

func new_game():
	get_tree().call_group("game_objects", "show")
	$UI/P1_UI/p1_physics_bar/ProgressBar.value = ball_magnitude
	$UI/P2_UI/p2_physics_bar/ProgressBar.value = ball_magnitude
	$Paddle1.position = Vector2(110, 324)
	$Paddle2.position = Vector2(1042, 324)
	$Ball.reset = true
	$OpeningMenu.hide()
	$SettingsMenu.hide()
	$UI/P2_Score/Label.text = str(p2_score)
	$UI/P1_Score/Label.text = str(p1_score)
	
func setting_menu():
	hide_game()
	$SettingsMenu.show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$UI/P1_UI/p1_physics_bar/ProgressBar.value = ball_magnitude
	$UI/P2_UI/p2_physics_bar/ProgressBar.value = ball_magnitude
	ball_magnitude += 1
	ball_magnitude = clampi(ball_magnitude, 0, 100)
	

func _unhandled_input(event):
	
	if event.is_action_pressed("open_setting"):
		if esc_option:
			setting_menu()
			esc_option = false
		else:
			new_game()
			$SettingsMenu.hide()
			esc_option = true
		
		

func _on_paddle_1_border_body_entered(_body):
	p2_score += 1
	$UI/P2_Score/Label.text = str(p2_score)
	new_game()


func _on_paddle_2_border_body_entered(_body):
	p1_score += 1
	$UI/P1_Score/Label.text = str(p1_score)
	new_game()


func _on_start_game_pressed():
	new_game()

func _on_settings_pressed():
	hide_game()
	$OpeningMenu.hide()
	$SettingsMenu.show()

func save_game():
	var file = FileAccess.open("res://Save_Games/savegame.data", FileAccess.WRITE)
	file.store_var(p1_score)
	file.store_var(p2_score)
	file.close()

func load_game():
	var file = FileAccess.open("res://Save_Games/savegame.data", FileAccess.READ)
	p1_score = file.get_var()
	p2_score = file.get_var()


func _on_save_pressed():
	save_game()


func _on_load_pressed():
	load_game()
