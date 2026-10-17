extends Control

# Pole odkazů na vaše framy (můžete je přetáhnout myší ze stromu scény přímo sem, 
# nebo použít níže uvedený automatický způsob přes get_children())
@onready var frames: Array[Node] = [
	$Frame1,
	$Frame2,
	$Frame3,
	$Frame4,
	$Frame5,
	$Frame6,
	$Frame7,
	$Frame8,
	$Frame9,
	$Frame10,
	$Frame11
	
]

var current_frame_index: int = 0

func _ready() -> void:
	# Při startu nastavíme viditelnost – první frame viditelný, ostatní skryté
	update_frames()

func _unhandled_input(event: InputEvent) -> void:
	# Reaguje na stisk mezerníku (ui_accept ve výchozím nastavení obsahuje Mezerník a Enter)
	if event.is_action_pressed("ui_accept"):
		next_frame()

func next_frame() -> void:
	current_frame_index += 1
	
	# Pokud jsme za posledním framem, přepneme scénu na testmap
	if current_frame_index >= frames.size():
		change_to_testmap()
	else:
		update_frames()

func update_frames() -> void:
	# Projde všechny framy a zapne/vypne jejich viditelnost podle aktuálního indexu
	for i in range(frames.size()):
		frames[i].visible = (i == current_frame_index)

func change_to_testmap() -> void:
	# Zde se provede přepnutí na vaši herní scénu
	var target_scene = "res://Scenes/SubwaySurfer.tscn" 
	
	var error = get_tree().change_scene_to_file(target_scene)
	if error != OK:
		print("Chyba při načítání scény: ", target_scene)
