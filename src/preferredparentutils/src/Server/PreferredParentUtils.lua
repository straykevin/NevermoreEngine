--[=[
	Handles logic for creating a "preferred" parent container or erroring if
	it already exists.

	@class PreferredParentUtils
]=]
local PreferredParentUtils = {}

--[=[
	@param parent Instance
	@param name string
	@return () -> Instance
]=]
function PreferredParentUtils.createPreferredParentRetriever(parent, name)
	assert(typeof(parent) == "Instance", "Bad parent")
	assert(type(name) == "string", "Bad name")

	local cache
	return function()
		-- Ensure that we don't try to search for duplicates EVERY time.
		if cache and cache.Parent == parent then
			return cache
		end

		cache = PreferredParentUtils.getPreferredParent(parent, name)
		return cache
	end
end

--[=[
	@param parent Instance
	@param name string
	@return Instance
]=]
function PreferredParentUtils.getPreferredParent(parent, name)
	assert(typeof(parent) == "Instance", "Bad parent")
	assert(type(name) == "string", "Bad name")

	local found
	for _, item in pairs(parent:GetChildren()) do
		if item.Name == name then
			if not found then
				found = item
			else
				error(("[PreferredParentUtils.getPreferredParent] - Duplicate of %q")
					:format(tostring(item:GetFullName())))
			end
		end
	end

	if found then
		return found
	end

	local newParent = Instance.new("Folder")
	newParent.Name = name
	newParent.Parent = parent

	return newParent
end


return PreferredParentUtils