

function AT_SELF(pics,txts)
	pics = pics or "77"
	txts = txts or "88"
	DebugLogId(string.format("me  [%s] ret: %s", pics,txts ))
	return pics,txts
end
Action_self={
	{"[1],[TOUCH],[B|B|B],[],[退出确认_S]"},
	{"[1],[AT_SELF],[CC],[AA],[退出no确认]"},
	{"[1],[title],[Y],[EE],[退出no确认]"},
	{"[1],[title],[Y],[DD],[<退认>]"},
}