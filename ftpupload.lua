-- //
-- //	Fail to slow
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

local ftpstring = "ftp://"..user..":"..passwd.."@"..server..serverDir

local outfile = io.open(lastfile, "r+")

if outfile ~=nil then
	lastuploaded = outfile:read()
	outfile:close()
else 
	lastuploaded = ""
	local outfile = io.open(lastfile, "w")
	outfile:write(lastuploaded)
	outfile:close()
end
print( "Last Uploaded "..lastuploaded )
uploaded = ""
httpmotion = false

-- For each file in folder...
for file in lfs.dir(folder) do

    attr = lfs.attributes(folder .. "/" .. file)
    print( "Found "..attr.mode..": " .. file )
	collectgarbage()
	
    if attr.mode == "file" then
		if file > lastuploaded then
			response = fa.ftp("put", ftpstring..file, folder .. "/" .. file)
			if httpmotion==false then
				print(HttpSendFileName(folder.."/"..file))
				httpmotion = true
			end
			-- --Check to see if it worked, and log the result!
			if response ~= nil then
				print("Success!" .. file)
				if file > uploaded then
					uploaded = file
				end
				-- print(uploaded)
			else
				print("Fail")
			end
		end
		
	end
	
end
print("Done")
if uploaded > lastuploaded then
	local outfile = io.open(lastfile, "r+")
	outfile:write(uploaded)
	outfile:close()
end
