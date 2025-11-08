class_name RegistryEntry

var linked_program: Program
var linked_task: Task

static func from(program: Program, task: Task) -> RegistryEntry:
	var entry := new()
	entry.linked_program = program
	entry.linked_task = task
	return entry

func destroy() -> void:
	assert(linked_program and linked_task, "Either the program or the task is invalid...")
	linked_program.queue_free()
	linked_task.queue_free()
