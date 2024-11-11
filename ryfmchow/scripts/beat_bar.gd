extends Control

var center_target = Vector2()
var move_speed = 5

func _process(delta):
	position.x += move_speed

# Kiểm tra nếu thanh trắng đã đến gần ô trung tâm
func is_near_center() -> bool:
	return position.distance_to(center_target) < 2
