extends CSGBox

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	var selected_material = pick_random_material()
	material = load(selected_material)

func pick_random_material():
	var material_list = get_files("res://Props/Billboards/BillboardMaterial/")
	var selected_material = material_list[randi() % material_list.size()]
	return selected_material

func get_files(folder_path):
	var gathered_files = {}
	var file_count = 0
	var dir = Directory.new()
	dir.open(folder_path)
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			gathered_files[file_count] = folder_path + file
			file_count += 1
	return gathered_files

