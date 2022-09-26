V3SqrMagnitude = function(self)
    return self.x * self.x + self.y * self.y + self.z * self.z
end

V3SetNormalize = function(self)
    local num = V3Magnitude(self)
    if num == 1 then
        return self
    elseif num > 1e-5 then
        self = V3Div(self,num)
    else
        self = vector3(0.0,0.0,0.0)
    end
    return self
end

V3Div = function(self, d)
    self = vector3(self.x / d,self.y / d,self.z / d)
    
    return self
end

V3Mul = function(self,q)
    if type(q) == "number" then
        self = self * q
    else
        self = V3MulQuat(self,q)
    end
    return self
end

V3ClampMagnitude = function(self, max)
    local result = V3SqrMagnitude(self)
    local totalmax = max * max
    if result > totalmax then
        self = V3SetNormalize(self)
        self = V3Mul(self, max)
    end
    return self
end

V3Magnitude = function(self)
    return math.sqrt(self.x * self.x + self.y * self.y + self.z * self.z)
end

V3MulQuat = function(self,quat)    
    local num   = quat.x * 2
    local num2  = quat.y * 2
    local num3  = quat.z * 2
    local num4  = quat.x * num
    local num5  = quat.y * num2
    local num6  = quat.z * num3
    local num7  = quat.x * num2
    local num8  = quat.x * num3
    local num9  = quat.y * num3
    local num10 = quat.w * num
    local num11 = quat.w * num2
    local num12 = quat.w * num3
    
    local x = (((1 - (num5 + num6)) * self.x) + ((num7 - num12) * self.y)) + ((num8 + num11) * self.z)
    local y = (((num7 + num12) * self.x) + ((1 - (num4 + num6)) * self.y)) + ((num9 - num10) * self.z)
    local z = (((num8 - num11) * self.x) + ((num9 + num10) * self.y)) + ((1 - (num4 + num5)) * self.z)
    
    self = vector3(x, y, z) 
    return self
end