-- Field to display a value

function Field(
	psrf,	-- mother surface
	x,y,	-- position in the mother surface
	font,	-- font to use
	color,	-- initial foreground color
	opts
)
--[[ known options  :
--	align : how to align the text (LEFT by default)
--	sample_text : text to use to compute the field width
--	width, height : force the field's geometry
--	bgcolor : background color
--	ndecimal : round to ndecimal
--	refresh : force refresh even if the data doesn't change
--		(useful if smax overlap gfx with mask)
--
--	At last one of sample_text or width MUST be provided
--]]
	if not opts then
		opts = {}
	end

	-- initialize
	if not opts.width then
		opts.width = font:StringWidth( opts.sample_text )
	end
	if not opts.height then
		opts.height = font:GetHeight()
	end
	if not opts.bgcolor then
		opts.bgcolor = COL_BLACK
	end

	if opts.align == ALIGN_FRIGHT then
		x = x - opts.width
	end

	local self = SubSurface(psrf, x,y, opts.width, opts.height )
	self.get():SetFont( font )
	self.setColor( color )

	-- methods
	function self.GetHeight()
		return font:GetHeight()
	end

	function self.Clear()
		self.get():Clear( opts.bgcolor.get() )
	end

	function self.DrawStringOff( v, x,y )	-- Draw a string a the specified offset
		local srf = self.get()

		if opts.align == ALIGN_RIGHT or opts.align == ALIGN_FRIGHT then
			srf:DrawString( v, srf:GetWidth() - font:StringWidth(v) - x, y )
		elseif opts.align == ALIGN_CENTER then
			srf:DrawString( v, (srf:GetWidth() - font:StringWidth(v))/2 - x, y )
		else	-- left
			srf:DrawString( v, x,y )
		end
	end

	function self.update( v )
		if opts.ndecimal then
			v = string.format("%." .. (opts.ndecimal or 0) .. "f", v)
		end
		self.Clear()
		self.DrawStringOff(v, 0,0)
		self.refresh()
	end

	return self
end

