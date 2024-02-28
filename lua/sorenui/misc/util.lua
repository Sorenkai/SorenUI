local blurMat = Material("pp/blurscreen")

function SorenUI:CreateFont(name, size, weight)
    surface.CreateFont("SorenUI."..name, {
        font = "Roboto",
        size = size or 16,
        weight = weight or 500
    })
end

function SorenUI:FindPly(string_ply)
    local name = string.lower(string_ply)
    for _,v in ipairs(player.GetAll()) do
        if(string.find(string.lower(v:Name()), name, 1, true) != nil) then
            return v
        end
    end
end

function SorenUI:MaskInverse(maskFn, drawFn, pixel)
	pixel = pixel or 1

	render.ClearStencil()
	render.SetStencilEnable(true)

	render.SetStencilWriteMask(1)
	render.SetStencilTestMask(1)

	render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
	render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
	render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
	render.SetStencilReferenceValue(pixel)

	maskFn()

	render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
	render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
	render.SetStencilZFailOperation(STENCILOPERATION_KEEP)
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
	render.SetStencilReferenceValue(pixel - 1)

	drawFn()

	render.SetStencilEnable(false)
	render.ClearStencil()
end


function SorenUI:DrawArc(x, y, ang, p, rad, color, seg)
	seg = seg or 80
	ang = (-ang) + 180
	local circle = {}

	table.insert(circle, {x = x, y = y})
	for i = 0, seg do
		local a = math.rad((i / seg) * -p + ang)
		table.insert(circle, {x = x + math.sin(a) * rad, y = y + math.cos(a) * rad})
	end

	surface.SetDrawColor(color)
	draw.NoTexture()
	surface.DrawPoly(circle)
end

function SorenUI:DrawBackgroundBlur(pnl, layers, density, alpha)
	local x, y = pnl:LocalToScreen(0, 0)
	local scrW, scrH = ScrW(), ScrH()
	surface.SetDrawColor(255, 255, 255, alpha or 255)
	surface.SetMaterial(blurMat)
	for i = 1, layers do
		blurMat:SetFloat("$blur", (i / layers) * (density or 6))
		blurMat:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
	end
end	


function SorenUI:DrawRoundedBoxEx(radius, x, y, w, h, col, tl, tr, bl, br)
	--Validate input
	x = math.floor(x)
	y = math.floor(y)
	w = math.floor(w)
	h = math.floor(h)
	radius = math.Clamp(math.floor(radius), 0, math.min(h/2, w/2))
	
	if (radius == 0) then
		surface.SetDrawColor(col)
		surface.DrawRect(x, y, w, h)

		return
	end

	--Draw all rects required
	surface.SetDrawColor(col)
	surface.DrawRect(x+radius, y, w-radius*2, radius)
	surface.DrawRect(x, y+radius, w, h-radius*2)
	surface.DrawRect(x+radius, y+h-radius, w-radius*2, radius)

	--Draw the four corner arcs
	if(tl) then
		SorenUI:DrawArc(x+radius, y+radius, 270, 90, radius, col, radius)
	else
		surface.SetDrawColor(col)
		surface.DrawRect(x, y, radius, radius)
	end

	if(tr) then
		SorenUI:DrawArc(x+w-radius, y+radius, 0, 90, radius, col, radius)
	else
		surface.SetDrawColor(col)
		surface.DrawRect(x+w-radius, y, radius, radius)
	end

	if(bl) then
		SorenUI:DrawArc(x+radius, y+h-radius, 180, 90, radius, col, radius)
	else
		surface.SetDrawColor(col)
		surface.DrawRect(x, y+h-radius, radius, radius)
	end

	if(br) then
		SorenUI:DrawArc(x+w-radius, y+h-radius, 90, 90, radius, col, radius)
	else
		surface.SetDrawColor(col)
		surface.DrawRect(x+w-radius, y+h-radius, radius, radius)
	end
end

function SorenUI:DrawRoundedBox(radius, x, y, w, h, col)
	SorenUI:DrawRoundedBoxEx(radius, x, y, w, h, col, true, true, true, true)
end

function SorenUI:DrawShadowText(text, font, x, y, col, xAlign, yAlign, amt, shadow)
    for i = 1, amt do
      draw.SimpleText(text, font, x + i, y + i, Color(0, 0, 0, i * (shadow or 50)), xAlign, yAlign)
    end
  
    draw.SimpleText(text, font, x, y, col, xAlign, yAlign)
  end
  

function SorenUI:Ease(t, b, c, d)
	t = t / d
	local ts = t * t
	local tc = ts * t

	--return b + c * ts
	return b + c * (-2 * tc + 3 * ts)
end


-- [[ ANIMATION ]] --
local PNL = FindMetaTable("Panel")

function PNL:EndAnimations()
	for i, v in pairs(self.m_AnimList or {}) do
		if (v.OnEnd) then v:OnEnd(self) end
		self.m_AnimList[i] = nil
	end
end


function PNL:Lerp(var, to, duration, callback)
	if (!duration) then duration = SorenUI.Config.TransitionTime end

	local varStart = self[var]
	local anim = self:NewAnimation(duration)
	anim.Goal = to
	anim.Think = function(anim, pnl, fract)
		local newFract = SorenUI:Ease(fract, 0, 1, 1)

		if (!anim.Start) then
			anim.Start = varStart
		end

		local new = Lerp(newFract, anim.Start, anim.Goal)
		self[var] = new
	end
	anim.OnEnd = function()
		if (callback) then
			callback(self)
		end
	end
end





