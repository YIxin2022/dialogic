@tool
class_name DialogicEndTimelineEvent
extends DialogicEvent

## Event that ends a timeline (even if more events come after).


#region EXECUTE
################################################################################

func _execute() -> void:
	dialogic.end_timeline()

#endregion


#region INITIALIZE
################################################################################

func _init() -> void:
	event_name = "结束"
	event_description = "Ends the timeline early. Not required at the timeline end."
	set_default_color('Color4')
	event_category = "流程"
	event_sorting_index = 10

#endregion


#region SAVING/LOADING
################################################################################

func get_shortcode() -> String:
	return "end_timeline"

#endregion


#region EDITOR REPRESENTATION
################################################################################

func build_event_editor() -> void:
	add_header_label('End Timeline')

#endregion
