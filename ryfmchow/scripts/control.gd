extends Control

const BEAT_FILE = "res://beat_time/beat_times.json"
var beat_times = []
var score = 0
var current_beat_index = 0


const BEAT_SPEED = 5

func _ready():
	load_beat_times()
	$score_label.text = "Score: 0"
	start_beat_timer()
	$KingsOfSwing.play()

func load_beat_times():
	print("beattimes")
	var file = FileAccess.open(BEAT_FILE, FileAccess.READ)
	if file:
		var parsed = JSON.parse_string(file.get_as_text())
		if parsed is Array:
			beat_times = parsed  
		else:
			print("Error parsing JSON!")
		file.close()




func start_beat_timer():
	print("beattimer")
	if beat_times.size() > 0:
		var first_beat = beat_times[0]
		$Timer.start(first_beat) 
		

func spawn_beat_bar():
	print("spawn")
	var beat_bar = preload("res://scenes/beat_bar.tscn").instantiate()
	add_child(beat_bar)
	beat_bar.center_target = $square.global_position
	beat_bar.move_speed = BEAT_SPEED




func is_near_center(child: Control, threshold: float = 50.0) -> bool:
	var center_position = $square.global_position  
	var distance = child.global_position.distance_to(center_position)
	return distance < threshold


func _input(event):
	if event.is_action_pressed("ui_accept"): 
		for child in get_children():
			if child.is_in_group("beat_bar"):  
				if is_near_center(child):
					score += 10
					$score_label.text = "Score: " + str(score)
					child.queue_free()

func _on_timer_timeout() -> void:

	if current_beat_index < beat_times.size():
		spawn_beat_bar()

		current_beat_index += 1
		if current_beat_index < beat_times.size():
			var next_beat = beat_times[current_beat_index] - beat_times[current_beat_index - 1]
			$Timer.start(next_beat)
