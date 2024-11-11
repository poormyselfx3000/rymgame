import librosa
import json
import tkinter as tk
from tkinter import filedialog, messagebox

# Hàm phát hiện các nhịp chính
def detect_main_beats(audio_file, output_file):
    y, sr = librosa.load(audio_file, sr=None)
    tempo, beat_frames = librosa.beat.beat_track(y=y, sr=sr, units='frames')
    main_beats = librosa.frames_to_time(beat_frames, sr=sr)
    
    with open(output_file, 'w') as f:
        json.dump(main_beats.tolist(), f)
    
    messagebox.showinfo("Thông báo", f"Các nhịp chính đã được lưu vào: {output_file}")

# Hàm chọn file âm thanh đầu vào
def select_audio_file():
    file_path = filedialog.askopenfilename(
        title="Chọn file âm thanh",
        filetypes=[("Audio Files", "*.mp3 *.wav *.ogg")]
    )
    audio_file_entry.delete(0, tk.END)
    audio_file_entry.insert(0, file_path)

# Hàm chọn file JSON đầu ra
def select_output_file():
    file_path = filedialog.asksaveasfilename(
        title="Chọn file JSON để lưu kết quả",
        defaultextension=".json",
        filetypes=[("JSON Files", "*.json")]
    )
    output_file_entry.delete(0, tk.END)
    output_file_entry.insert(0, file_path)

# Hàm chạy phân tích nhịp
def run_detection():
    audio_file = audio_file_entry.get()
    output_file = output_file_entry.get()
    
    if not audio_file or not output_file:
        messagebox.showwarning("Lỗi", "Vui lòng chọn cả file đầu vào và file đầu ra.")
        return

    detect_main_beats(audio_file, output_file)

# Tạo cửa sổ chính
root = tk.Tk()
root.title("Phát hiện nhịp chính")

# Giao diện chọn file âm thanh đầu vào
tk.Label(root, text="File âm thanh đầu vào:").grid(row=0, column=0, padx=10, pady=10)
audio_file_entry = tk.Entry(root, width=50)
audio_file_entry.grid(row=0, column=1, padx=10, pady=10)
tk.Button(root, text="Chọn...", command=select_audio_file).grid(row=0, column=2, padx=10, pady=10)

# Giao diện chọn file JSON đầu ra
tk.Label(root, text="File JSON đầu ra:").grid(row=1, column=0, padx=10, pady=10)
output_file_entry = tk.Entry(root, width=50)
output_file_entry.grid(row=1, column=1, padx=10, pady=10)
tk.Button(root, text="Chọn...", command=select_output_file).grid(row=1, column=2, padx=10, pady=10)

# Nút chạy phân tích nhịp
tk.Button(root, text="Chạy phát hiện nhịp", command=run_detection, bg="lightgreen").grid(row=2, column=0, columnspan=3, pady=20)

root.mainloop()
