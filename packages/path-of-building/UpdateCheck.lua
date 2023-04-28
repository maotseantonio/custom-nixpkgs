-- Path of Building
--
-- Module: Update Check
-- Checks for updates

local connectionProtocol, proxyURL = ...

local updateAvailableMsg = "Update available!\n"
local updateCheckFailedMsg = "Update check failed!\n"

local xml = require("xml")
local curl = require("lcurl.safe")

local globalRetryLimit = 10
local function downloadFileText(source, file)
	for i = 1, 5 do
		if i > 1 then
			ConPrintf("Retrying... (%d of 5)", i)
		end
		local text = ""
		local easy = curl.easy()
		local escapedUrl = source .. easy:escape(file)
		easy:setopt_url(escapedUrl)
		easy:setopt(curl.OPT_ACCEPT_ENCODING, "")
		if connectionProtocol then
			easy:setopt(curl.OPT_IPRESOLVE, connectionProtocol)
		end
		if proxyURL then
			easy:setopt(curl.OPT_PROXY, proxyURL)
		end
		easy:setopt_writefunction(function(data)
			text = text .. data
			return true
		end)
		local _, error = easy:perform()
		easy:close()
		if not error then
			return text
		end
		ConPrintf("Download failed (%s)", error:msg())
		if globalRetryLimit == 0 or i == 5 then
			return nil, error:msg()
		end
		globalRetryLimit = globalRetryLimit - 1
	end
end

ConPrintf("Checking for update...")

local scriptPath = GetScriptPath()

-- Load and process local manifest
local localVer
local localBranch
local localManXML = xml.LoadXMLFile(scriptPath .. "/manifest.xml")
local localSource
if localManXML and localManXML[1].elem == "PoBVersion" then
	for _, node in ipairs(localManXML[1]) do
		if type(node) == "table" then
			if node.elem == "Version" then
				localVer = node.attrib.number
				localBranch = node.attrib.branch
			elseif node.elem == "Source" then
				if node.attrib.part == "default" then
					localSource = node.attrib.url
				end
			end
		end
	end
end
if not localVer then
	ConPrintf("Update check failed: invalid local manifest")
	return nil, updateCheckFailedMsg .. "Invalid local manifest"
end
localSource = localSource:gsub("{branch}", localBranch)

-- Download and process remote manifest
local remoteVer
local remoteManText, errMsg = downloadFileText(localSource, "manifest.xml")
if not remoteManText then
	ConPrintf("Update check failed: could not download version manifest")
	return nil,
		updateCheckFailedMsg
			.. "Could not download version manifest.\nReason: "
			.. errMsg
			.. "\nCheck your internet connectivity.\nIf you are using a proxy, specify it in Options."
end
local remoteManXML = xml.ParseXML(remoteManText)
if remoteManXML and remoteManXML[1].elem == "PoBVersion" then
	for _, node in ipairs(remoteManXML[1]) do
		if type(node) == "table" then
			if node.elem == "Version" then
				remoteVer = node.attrib.number
			end
		end
	end
end
if not remoteVer then
	ConPrintf("Update check failed: invalid remote manifest")
	return nil, updateCheckFailedMsg .. "Invalid remote manifest"
end

-- Display notification if there is an update available.
-- Hijacking the error msg is a little scuffed, but it is what it is.
if remoteVer > localVer then
	return nil, updateAvailableMsg .. "Latest version: " .. remoteVer .. "\nUpdate your nix package you lazy fuck!"
end
