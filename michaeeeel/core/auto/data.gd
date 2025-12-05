extends Node

@export var protagonist_user: User
@export var ami: User
@export var marina: User

var systime: String = ""

@onready var username_to_user: Dictionary[String, User] = {
	"protag": ami,
	"": ami,
	"Ami": ami,
	"Marina": marina
}

@onready var marina_day_one_chat := ChatRes.from("res://dialogue/marina_live_day1.dialogue", marina.pfp)
var unlocked_chats: Array[ChatRes] = []
var primary_chat: ChatRes

func unlock_chat(chat: ChatRes) -> void:
	unlocked_chats.push_back(chat)
	primary_chat = chat
	chat.needs_rebuild = true
	chat.force_roll()
