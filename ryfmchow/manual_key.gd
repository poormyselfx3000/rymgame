extends Control

# Danh sách lưu các thời điểm nhấn phím
var beat_times: Array = []
# Đặt tên file JSON để lưu kết quả
const OUTPUT_JSON = "res://beat_time/beat_times.json"

func _ready():
	# Thông báo hướng dẫn
	$label.text = "Nhấn 'Space' để thêm nhịp, 'Lưu' để lưu vào JSON."

	# Kiểm tra AudioStreamPlayer2D có tồn tại không và phát nhạc
	if $AudioStreamPlayer2D != null:
		$AudioStreamPlayer2D.play()
	else:
		print("AudioStreamPlayer2D không tồn tại!")

# Ghi thời điểm khi nhấn phím
func _input(event):
	if event.is_action_pressed("space"):  # Khi nhấn phím Space
		if $AudioStreamPlayer2D != null and $AudioStreamPlayer2D.playing:
			var time = $AudioStreamPlayer2D.get_playback_position()  # Sử dụng phương thức trong Godot 4
			beat_times.append(time)
			print("Nhịp đã được thêm tại giây:", time)
		else:
			print("AudioStreamPlayer2D chưa được phát hoặc chưa khởi tạo.")
	if Input.is_action_just_pressed("save"):
		_on_SaveButton_pressed()
# Lưu các nhịp vào file JSON
func _on_SaveButton_pressed():
	if beat_times.size() > 0:
		var file = FileAccess.open(OUTPUT_JSON, FileAccess.WRITE)
		if file:
			file.store_string(JSON.stringify(beat_times))  # Sử dụng `JSON.stringify()` để chuyển đổi mảng thành chuỗi JSON
			file.close()
			print("Đã lưu các nhịp vào", OUTPUT_JSON)
			beat_times.clear()
	else:
		print("Chưa có nhịp nào được thêm.")
