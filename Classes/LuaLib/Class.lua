local Class = { className = "Class" }
setmetatable( Class, Class )

function Class:cloneMetatable( source )
    local sourceMetatable = getmetatable( source )
    local targetMetatable = {}

    for index, value in pairs( sourceMetatable ) do
        targetMetatable[ index ] = value
    end

    return setmetatable( self, targetMetatable )
end

function Class:copyMetatable( source )
    local sourceMetatable = getmetatable( source )
    local targetMetatable = getmetatable( self )

    if ( sourceMetatable ~= targetMetatable )
    then
        for index, value in pairs( sourceMetatable ) do
            targetMetatable[ index ] = value
        end
    end

    return self
end

function Class:extend( object )
    object = object or {}

    --[[
        Create a class-specific metatable that copies the metatable of the
        parent class being extended, and sets the fallback prototype chain to
        index the parent class.
    --]]
    object.super = self
    self.cloneMetatable( object, object.super )
    getmetatable( object ).__index = object.super

    --[[
        Create a prototype metatable to be shared by all future child
        instances of this class, so that the fallback index searches this
        class before searching the parent class.  This single metatable
        is shared by all instances of future child instances in order to
        avoid a per-object metatable and their associated memory overhead.
    --]]
    object.class = {}
    self.cloneMetatable( object.class, object )
    getmetatable( object.class ).__index = object

    return object
end

function Class:new( object )
    object = object or {}
    setmetatable( object, getmetatable( self.class ))

    return object
end

function Class:__tostring()
    if ( not self ) then return "undefined" end
    if ( not self.className ) then return self end
    if ( not self.super ) then return self.className end
    if ( not self.super.className ) then return self.className end

    return self.className .. " (" .. self.super.className .. ")"
end

setmetatable( Class, {
    __tostring = Class.__tostring })

return Class
