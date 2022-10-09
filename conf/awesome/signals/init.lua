req = {
	"volume",
	"mic",
	"cpu",
	"mem",
	"player",
	"disk",
	"uptime",
	"playerctl",
}

for _, x in pairs(req) do
	require("signals."..x)
end
