# character_list.gd
extends ScrollContainer


# Script
const RadioButtonContainer: Script = preload("uid://dgxb13iyu7nlx")


func get_radio_btn_container() -> RadioButtonContainer:
	return get_node(^"%CharacterRadioButtonContainer") as RadioButtonContainer



	
