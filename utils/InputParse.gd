extends Node

const NUMBERS = [KEY_0, KEY_1, KEY_2, KEY_3, KEY_4,
				 KEY_5, KEY_6, KEY_7, KEY_8, KEY_9,
				 KEY_KP_0, KEY_KP_1, KEY_KP_2, KEY_KP_3, KEY_KP_4,
				 KEY_KP_5, KEY_KP_6, KEY_KP_7, KEY_KP_8, KEY_KP_9]


func parse(event: InputEventKey) -> String:
	if event.scancode in NUMBERS:
		match event.scancode:
			KEY_0, KEY_KP_0:
				return "0"
			KEY_1, KEY_KP_1:
				return "1"
			KEY_2, KEY_KP_2:
				return "2"
			KEY_3, KEY_KP_3:
				return "3"
			KEY_4, KEY_KP_4:
				return "4"
			KEY_5, KEY_KP_5:
				return "5"
			KEY_6, KEY_KP_6:
				return "6"
			KEY_7, KEY_KP_7:
				return "7"
			KEY_8, KEY_KP_8:
				return "8"
			KEY_9, KEY_KP_9:
				return "9"
	return "-1"
