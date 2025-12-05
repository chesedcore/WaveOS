extends Node

signal request_open_from_icon(program_icon: ProgramIcon)
signal request_close_from_res(program: ProgramResource)

signal request_focus(program: Program)

signal view_image(image_name: String, image: Texture)
signal view_log(with_timestamp: String, log_path: String, log_name: String)
signal message_arrived(username: String, text: String)

signal mizuko_morph(emotion: String)

signal summon_mizuko(dialogue_res: DialogueResource)
signal mizuko_destroyed

#directives
signal destroy_all_icons
signal add_icon(scene_path: String)

#key events
signal app_opened(appname: String)
signal image_opened(image_name: String)
signal log_opened(log_name: String)
signal end_day_one
