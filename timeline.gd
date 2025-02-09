@tool
extends Resource
class_name Timeline

##
## Base class for all Timelines
##
## This resource only keeps an ordered reference of all commands registered on it.
##

var commands:Array[Command]:
	set(value):
		commands = value
		emit_changed()
	get:
		return commands

## Adds a [Command] to the timeline
func add_command(command:Command) -> void:
	if has(command):
		push_error("add_command: Trying to add an command to the timeline, but the command is already added")
		return
	commands.append(command)
	emit_changed()

## Insert an [code]Command[/code] at position.
func insert_command(command:Command, at_position:int) -> void:
	if has(command):
		push_error("insert_command: Trying to add an command to the timeline, but the command already exist")
		return
	
	var idx = at_position if at_position > -1 else commands.size()
	commands.insert(idx, command)
	
	emit_changed()


## Moves an [code]command[/code] to position.
func move_command(command, to_position:int) -> void:
	if !has(command):
		push_error("move_command: Trying to move an command in the timeline, but the command is not added.")
		return
	
	var old_position:int = get_command_idx(command)
	if old_position < 0:
		return
	
	to_position = to_position if to_position > -1 else commands.size()
	if to_position == old_position:
		emit_changed()
		return
	
	commands.remove_at(old_position)
	
	if to_position < 0 or to_position > commands.size():
		to_position = commands.size()
	
	commands.insert(to_position, command)
	
	emit_changed()
	notify_property_list_changed()

## Get the command at [code]position[/code]
func get_command(position:int) -> Resource:
	if position < commands.size():
		return commands[position]
	
	push_error("get_command: Tried to get an command on a non-existing position: ", position)
	return null

## Removes an command from the timeline.
func erase_command(command) -> void:
	commands.erase(command)
	emit_changed()

## Removes an command at [code]position[/code] from the timelin
func remove_command(position:int) -> void:
	commands.remove_at(position)
	emit_changed()

## Returns the command position in the timeline.
func get_command_idx(command) -> int:
	return commands.find(command)

func has(value:Command) -> bool:
	return commands.has(value)


func _get_property_list() -> Array:
	var p:Array = []
	p.append({"name":"commands", "type":TYPE_ARRAY, "usage":PROPERTY_USAGE_NO_EDITOR|PROPERTY_USAGE_SCRIPT_VARIABLE})
	return p
