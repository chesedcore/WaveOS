class_name ChoiceContainer extends ChatItem

signal choice_determined(
	container: ChoiceContainer,
	choice_txt: String,
	next_id: String
)

var id: String

func _init() -> void:
	self.type = ChatItem.TYPE.CHOICE

static func from(line: DialogueLine) -> ChoiceContainer:
	assert(line.responses, "This line has no responses, dumbass!")
	
	var container: ChoiceContainer = load("res://scenes/utility/messenger/choice_container.tscn").instantiate()
	var responses: Array[DialogueResponse]= line.responses
	container.id = line.id
	
	for response in responses:
		var choice := Choice.from(response.text, response.id, response.next_id)
		container.add_child.call_deferred(choice)
		choice.clicked.connect.call_deferred(container.choice_clicked)
	
	return container

func choice_clicked(choice: Choice) -> void:
	choice_determined.emit(self, choice.label.text, choice.next_id)
	print("Choice clicked! "+choice.label.text)
