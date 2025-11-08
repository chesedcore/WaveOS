class_name TerminalMachine extends Node

func perform_processing(input: String) -> String:
	return input.strip_edges()
