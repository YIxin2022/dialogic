@tool
class_name DialogicPortraitAnimationUtil

enum AnimationType {ALL=-1, IN=1, OUT=2, ACTION=3, CROSSFADE=4}


static func guess_animation(string:String, type := AnimationType.ALL) -> String:
	var default := {}
	var filter := {}
	var ignores := []
	match type:
		AnimationType.ALL:
			pass
		AnimationType.IN:
			filter = {"type":AnimationType.IN}
			ignores = ["in"]
		AnimationType.OUT:
			filter = {"type":AnimationType.OUT}
			ignores = ["out"]
		AnimationType.ACTION:
			filter = {"type":AnimationType.ACTION}
		AnimationType.CROSSFADE:
			filter = {"type":AnimationType.CROSSFADE}
			ignores = ["cross"]
	return DialogicResourceUtil.guess_special_resource(&"PortraitAnimation", string, default, filter, ignores).get("path", "")


static func get_portrait_animations_filtered(type := AnimationType.ALL) -> Dictionary:
	var filter := {"type":type}
	if type == AnimationType.ALL:
		filter["type"] = [AnimationType.IN, AnimationType.OUT, AnimationType.ACTION]
	return DialogicResourceUtil.list_special_resources("PortraitAnimation", filter)


static func get_suggestions(_search_text := "", current_value:= "", empty_text := "Default", action := AnimationType.ALL) -> Dictionary:
	var suggestions := {}
	
	var trans := {
		"Default": "默认 (Default)",
		"Fade In Up": "向上淡入 (Fade In Up)",
		"Bounce In": "弹跳进入 (Bounce In)",
		"Fade In Down": "向下淡入 (Fade In Down)",
		"Fade In": "淡入 (Fade In)",
		"Instant In": "瞬间出现 (Instant In)",
		"Slide In Down": "向下滑入 (Slide In Down)",
		"Slide From Left": "自左侧滑入 (Slide From Left)",
		"Slide From Right": "自右侧滑入 (Slide From Right)",
		"Slide In Up": "向上滑入 (Slide In Up)",
		"Tada In": "当当当入场 (Tada In)",
		"Tiptoe In": "踮脚进入 (Tiptoe In)",
		"Zoom In": "缩放进入 (Zoom In)",
		
		"Bounce Out": "弹跳退出 (Bounce Out)",
		"Fade Out": "淡出 (Fade Out)",
		"Fade Out Down": "向下淡出 (Fade Out Down)",
		"Fade Out Up": "向上淡出 (Fade Out Up)",
		"Instant Out": "瞬间消失 (Instant Out)",
		"Slide Out Down": "向下滑出 (Slide Out Down)",
		"Slide Out Left": "向左滑出 (Slide Out Left)",
		"Slide Out Right": "向右滑出 (Slide Out Right)",
		"Slide Out Up": "向上滑出 (Slide Out Up)",
		"Zoom Out": "缩放退出 (Zoom Out)",
		
		"Bounce": "弹跳 (Bounce)",
		"Heartbeat": "心跳 (Heartbeat)",
		"Shake X": "水平摇晃 (Shake X)",
		"Shake Y": "垂直摇晃 (Shake Y)",
		"Tada": "当当当 (Tada)",
		"Ticking": "钟摆摇晃 (Ticking)",
		"Wobble": "摇摆 (Wobble)",
		"Zoom Bounce": "缩放弹跳 (Zoom Bounce)",
		
		"Fade Cross": "交叉淡入淡出 (Fade Cross)",
		"Cross Fade": "交叉淡入淡出 (Cross Fade)"
	}
	
	if empty_text and current_value:
		var txt = empty_text
		if empty_text in trans:
			txt = trans[empty_text]
		suggestions[txt] = {'value':"", 'editor_icon':["GuiRadioUnchecked", "EditorIcons"]}

	for anim_name in get_portrait_animations_filtered(action):
		var p_name = DialogicUtil.pretty_name(anim_name)
		var trans_name = p_name
		if p_name in trans:
			trans_name = trans[p_name]
			
		suggestions[trans_name] = {
			'value'			: p_name,
			'editor_icon'	: ["Animation", "EditorIcons"]
			}

	return suggestions
