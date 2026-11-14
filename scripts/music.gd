extends AudioStreamPlayer

## Every song in this folder plays, shuffled, one after another.
const MUSIC_DIR := "res://assets/music/"

var tracks: Array[String] = []
var next_index: int = 0


func _ready() -> void:
	# Keep playing while the game is paused, such as on the death screen.
	process_mode = Node.PROCESS_MODE_ALWAYS
	for file in ResourceLoader.list_directory(MUSIC_DIR):
		if file.get_extension() in ["mp3", "ogg", "wav"]:
			tracks.append(MUSIC_DIR + file)
	finished.connect(_play_next)
	_play_next()


func _play_next() -> void:
	if tracks.is_empty():
		return
	if next_index == 0:
		var last := tracks[-1]
		tracks.shuffle()
		# Don't play the same song twice in a row when the playlist starts over.
		if tracks.size() > 1 and tracks[0] == last:
			tracks.reverse()
	stream = load(tracks[next_index])
	next_index = (next_index + 1) % tracks.size()
	play()
