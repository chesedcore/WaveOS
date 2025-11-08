class_name BottomBar extends HBoxContainer

@export var taskbar_container: HBoxContainer
#@export var 

func add_to_taskbar(program_res: ProgramResource) -> Task:
	var task: Task = preload("res://scenes/taskbar_task.tscn").instantiate()
	task.change_icon(program_res.icon)
	taskbar_container.add_child(task)
	return task
