-- //
-- //	Fail, multiple files with same timestamp do not fit in 512 buffer
-- //

function HttpSendFileName(filename) 
	print("message vlosite")
	b,c,h = fa.request{url = "http://192.168.2.101/process.php?deviceID=310&callerID=310&messagetypeID=MESS_TYPE_SCHEME&schemeID=307&commandvalue="..filename }
	return c
end

local lastfile   = "/lastfile.txt"     -- Track last file uploaded
local folder    = "/DCIM/101MFCAM"     -- What folder to upload files from
local server    = "192.168.2.102"      -- The FTP server's IP
local serverDir = "/"                  -- The path on the FTP server to use.
local user      = "cam-11"             -- FTP username
local passwd    = "cam11ftp"            -- FTP passwd

-- Assemble our FTP command string
-- example: "ftp://user:pass@192.168.1.1/"
local ftpstring = "ftp://"..user..":"..passwd.."@"..server..serverDir

local outfile = io.open(lastfile, "r+")

if outfile ~=nil then
	LastUploadedTime = outfile:read()
	outfile:close()
else 
	LastUploadedTime = "00000000"
	local outfile = io.open(lastfile, "w")
	outfile:write(LastUploadedTime)
	outfile:close()
end

LastUploadedTime = tonumber(LastUploadedTime)+1
print( "Last Uploaded "..LastUploadedTime )
GreatestUploadedTime = 0
httpmotion = false

-- For each file in folder...
local result, filelist, time = fa.search("file", folder, LastUploadedTime)
if result ~= 1 then
    print("error: ", result)
end
if filelist ~= nil then
print(filelist)
    for file in string.gmatch(filelist, '([^\\/]-%.?),') do
        print(file)
	    attr = lfs.attributes(folder.."/"..file)
		filetime = attr.modification
		
		response = fa.ftp("put", ftpstring..file, folder .. "/" .. file)
		if httpmotion==false then
			print(HttpSendFileName(folder.."/"..file))
			httpmotion = true
		end
		
		-- --Check to see if it worked, and log the result!
		if response ~= nil then
			print("Success: " .. file)
			if filetime > GreatestUploadedTime then
				GreatestUploadedTime = filetime
			end
		else
			print("Fail")
		end
   end
end

if GreatestUploadedTime ~= 0 then
	if GreatestUploadedTime > LastUploadedTime then
		print(string.format("Update "..lastfile.." time: 0x%08x", GreatestUploadedTime))
		local outfile = io.open(lastfile, "r+")
		outfile:write(GreatestUploadedTime)
		outfile:close()
	end
end




