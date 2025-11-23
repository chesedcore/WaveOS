extends Node

@export var protagonist_user: User

@onready var username_to_user: Dictionary[String, User] = {
	"protag": protagonist_user,
	"": protagonist_user,
}

@onready var test_res := ChatRes.from("res://dialogue/test.dialogue")
