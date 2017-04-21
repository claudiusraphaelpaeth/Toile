-- Receive an MQTT data and display it

function MQTTDisplay(
	name, topic,
	srf,	-- surface to display the value
	opts
)
--[[ known options  :
--	vfunction : validation function
--
--	+ options supported by MQTTinput
--]]
	if not opts then
		opts = {}
	end

	local self = MQTTinput( name, topic, opts.vfunction, opts)

	function self.update()
		local v = self.get()

		srf.update(v)
	end

	-- init
	self.TaskOnceAdd( self.update )

	return self
end
