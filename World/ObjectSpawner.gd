extends Node
 
enum PropType { VehicleProp = 0, BillboardProp, TrafficCones, FireHydrant, Lamps, Dumpsters, Beacon, Scaffolding, Goal }
 
var tiles: Array = []
var map_size: Vector2 = Vector2.ZERO
var max_number_of_park_cars: int = 100
var max_number_of_billboards: int = 75
var max_number_of_traffic_cones: int = 40
var max_number_of_fire_hydrants: int = 20
var max_number_of_lamps: int = 40
var max_number_of_dumpsters: int = 25
var max_number_of_beacons: int = 20
var max_number_of_scaffoldings: int = 25
var max_number_of_goals: int = 2
 
var used_cells: Dictionary = {
	PropType.VehicleProp: [],
	PropType.FireHydrant: [],
	PropType.BillboardProp: [],
	PropType.TrafficCones: [],
}
 
onready var rotation_lookup: Node = $ObjectRotLookup
 
 
func generate_props(tile_list: Array, size: Vector2) -> void:
 
	randomize()
	tiles = tile_list
	map_size = size
	place_prop(PropType.VehicleProp)
	place_prop(PropType.Dumpsters)
	place_prop(PropType.BillboardProp)
	place_prop(PropType.TrafficCones)
	place_prop(PropType.FireHydrant)
	place_prop(PropType.Lamps)
	place_prop(PropType.Scaffolding)
	place_prop(PropType.Beacon)
	place_prop(PropType.Goal)
 
 
func pick_random_tiles(tile_count: int) -> Array:
 
	# make a copy of the grid's list of tiles
	var tile_list: Array = tiles
	var selected_tiles: Array = []
 
	# shuffle the copy of the Grid's list of tiles
	tile_list.shuffle()
 
	# iterate over the list of tiles
	for i in range(tile_count):
		var tile: Vector3 = tile_list[i]
		selected_tiles.append(tile)
 
	return selected_tiles
 
 
func place_prop(prop_type: int) -> void:
 
	var max_tiles_number: int = get_max_number_of_props(prop_type)
 
	# handle props that can spawn in same positions
	var matching_prop_type: int = prop_type
	match prop_type:
		PropType.VehicleProp, PropType.Dumpsters:
			if not used_cells[PropType.VehicleProp]:
				used_cells[PropType.VehicleProp] = pick_random_tiles(max_number_of_dumpsters + max_number_of_park_cars)
			matching_prop_type = PropType.VehicleProp
		PropType.FireHydrant, PropType.Lamps:
			if not used_cells[PropType.FireHydrant]:
				used_cells[PropType.FireHydrant] = pick_random_tiles(max_number_of_fire_hydrants + max_number_of_lamps)
			matching_prop_type = PropType.FireHydrant
		_:
			used_cells[prop_type] = pick_random_tiles(max_tiles_number)
 
	# spawn a prop of the given type
	for i in range(max_tiles_number):
		var tile: Vector3 = used_cells[matching_prop_type].pop_front()
		var tile_type: int = get_parent().get_cell_item(tile.x, 0, tile.z)
		var available_rotations: Array = rotation_lookup.lookup_rotation(tile_type)
 
		if available_rotations:
			var tile_rotation: int = available_rotations[randi() % available_rotations.size() - 1] * -1
			tile.y = tile.y + 0.5
			rpc('spawn_prop', prop_type, tile, tile_rotation, tile_type)
 
 
func get_max_number_of_props(prop_type: int) -> int:
 
	var max_tiles_number: int = 0
	match prop_type:
		PropType.BillboardProp:
			max_tiles_number = max_number_of_billboards
		PropType.TrafficCones:
			max_tiles_number = max_number_of_traffic_cones
		PropType.VehicleProp:
			max_tiles_number = max_number_of_park_cars
		PropType.Dumpsters:
			max_tiles_number = max_number_of_dumpsters
		PropType.FireHydrant:
			max_tiles_number = max_number_of_fire_hydrants
		PropType.Lamps:
			max_tiles_number = max_number_of_lamps
		PropType.Scaffolding:
			max_tiles_number = max_number_of_scaffoldings
		PropType.Beacon:
			max_tiles_number = max_number_of_beacons
		PropType.Goal:
			max_tiles_number = max_number_of_goals
		
 
	return max_tiles_number
 
 
func load_prop_scene(prop_type: int) -> Node:
 
	var scene: Node = null
	match prop_type:
		PropType.VehicleProp:
			scene = preload('res://Props/ParkedCars.tscn').instance()
		PropType.BillboardProp:
			scene = preload('res://Props/Billboards/Billboard.tscn').instance()
		PropType.TrafficCones:
			scene = preload('res://Props/TrafficCones/TrafficCones.tscn').instance()
		PropType.FireHydrant:
			scene = preload('res://Props/Hydrant/Hydrant.tscn').instance()
		PropType.Lamps:
			scene = preload('res://Props/StreetLight/StreetLight.tscn').instance()
		PropType.Dumpsters:
			scene = preload('res://Props/Dumpster/Dumpster.tscn').instance()
		PropType.Scaffolding:
			scene = preload('res://Props/Scaffolding/Scaffolding.tscn').instance()
		PropType.Beacon:
			scene = preload('res://Beacon/Beacon.tscn').instance()
		PropType.Goal:
			scene = preload('res://Beacon/Goal.tscn').instance()
		
 
	return scene
 
 
### Remote Procedure Calls
sync func spawn_prop(prop_type: int, tile: Vector3, prop_rotation: int, tile_type: int) -> void:
 
	var prop = load_prop_scene(prop_type)
	prop.translation = Vector3((tile.x * 20) + 10, tile.y, (tile.z * 20) + 10)
	prop.rotation_degrees.y = prop_rotation	
		
 
	add_child(prop, true)
