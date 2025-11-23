##a node that can represent either a message or a choice pane
@abstract
class_name ChatItem extends Control

enum TYPE {
	MESSAGE,
	CHOICE,
}

var type: TYPE
