class_name RegistryEntry

var linked_program: Program
var linked_task: Task

##create a new entry with the given program and task from the taskbar.
static func from(program: Program, task: Task) -> RegistryEntry:
	var entry := new()
	entry.linked_program = program
	entry.linked_task = task
	return entry

##destroy both nodes linked in this entry.
func destroy() -> void:
	assert(linked_program and linked_task, "Either the program or the task is invalid...")
	linked_program.shrink_in()
	linked_task.queue_free()
