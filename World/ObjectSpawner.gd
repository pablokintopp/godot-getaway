extends Node

var tiles = []
var map_size = Vector2()

var number_of_parked_cars = 100
var number_of_billboards = 75
var number_of_traffic_cones = 40
var number_of_hydrants = 50
var number_of_streetlights = 50
var number_of_dumpster = 25
var number_of_scaffolding = 25
var number_of_beacon = 20

func generate_props(tile_list, size):
	tiles = tile_list
	map_size = size
	place_objects(number_of_beacon, preload("res://Beacon/Beacon.tscn"))
	place_objects(number_of_parked_cars, preload("res://Props/ParkedCars.tscn"))
	place_objects(number_of_billboards, preload("res://Props/Billboards/Billboard.tscn"))
	place_objects(number_of_traffic_cones, preload("res://Props/TrafficCones/TrafficCones.tscn"))
	place_objects(number_of_hydrants, preload("res://Props/Hydrant/Hydrant.tscn"))
	place_objects(number_of_streetlights, preload("res://Props/StreetLight/StreetLight.tscn"))
	place_objects(number_of_dumpster, preload("res://Props/Dumpster/Dumpster.tscn"))
	place_objects(number_of_scaffolding, preload("res://Props/Scaffolding/Scaffolding.tscn"))


func random_tile(tile_count):
	var tile_list = tiles
	var selected_tiles = []
	tile_list.shuffle()
	for i in range(tile_count):
		var tile = tile_list[i]
		selected_tiles.append(tile)
	return selected_tiles

func place_objects(number_of_object, object_reference):
	var tile_list = random_tile(number_of_object)
	for i in range(number_of_object):
		var tile = tile_list[0]
		var tile_type = get_node("..").get_cell_item(tile.x, 0, tile.z)
		var allowed_rotations = $ObjectRotLookup.lookup_rotation(tile_type)
		if not allowed_rotations == null:
			var tile_rotation =  allowed_rotations[randi() % allowed_rotations.size() - 1] * -1
			tile.y = tile.y + 0.5 # Adjust for the height of the cars if needed
			var object_instance = object_reference.instance()
			rpc("spawn_object", object_instance , tile, tile_rotation)
		tile_list.pop_front()

sync func spawn_object(object_instance, tile, object_rotation):
	object_instance.translation  = Vector3((tile.x * 20) + 10, tile.y, (tile.z * 20) + 10)
	object_instance.rotation_degrees.y = object_rotation
	add_child(object_instance, true)

