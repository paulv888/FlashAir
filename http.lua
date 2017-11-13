-- //
-- //	Fail to slow
-- //

function HttpSendAlert(deviceID, message) 
	print("message vlosite: "..message)
	b,c,h = fa.request{url = "http://192.168.2.11/process.php?deviceID="..deviceID.."&callerID="..deviceID.."&messagetypeID=MESS_TYPE_SCHEME&schemeID=308&commandvalue="..message }
	return c
end

local deviceID    = "310"     -- DeviceID
local folder    = "/DCIM/101MFCAM"     -- What folder to upload files from
HttpSendAlert(deviceID, folder)
print("Done")