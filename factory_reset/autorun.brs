drive=GetDefaultDrive()

modelObject = CreateObject("roDeviceInfo")
deviceFamily$ = modelObject.GetFamily()

' Don't try to print to screen on sebring
if deviceFamily$ <> "sebring" then
	if type(vm) <> "roVideoMode" then vm = CreateObject("roVideoMode")
	meta99 = CreateObject("roAssociativeArray")
	meta99.AddReplace("CharWidth", 30)
	meta99.AddReplace("CharHeight", 50)
	meta99.AddReplace("BackgroundColor", &H101010) ' Dark grey
	meta99.AddReplace("TextColor", &Hffff00) ' Yellow
	tf99 = CreateObject("roTextField", vm.GetSafeX()+10, vm.GetSafeY()+vm.GetSafeHeight()/2, 60, 2, meta99)
	
	tf99.SendBlock("Deleting Recovery settings.")
	sleep(2000)
	tf99.Cls()
end if

if type(registry) <> "roRegistry" then registry = CreateObject("roRegistry")

mfgn=createobject("roMfgtest")
mfgn.FactoryReset()
registry.Flush()

if deviceFamily$ <> "sebring" then tf99.SendBlock("Settings Deleted. If you see this message again, manually remove/replace autorun.brs")

DeleteFile("autorun.brs")
sleep(5000)

if deviceFamily$ <> "sebring" then tf99.Cls()
	
' Check for autorun.backup and rename to autorun.brs if found
if MoveFile(drive + "autorun.backup", drive + "autorun.brs") then
	if deviceFamily$ <> "sebring" then tf99.SendBlock("autorun.backup found - restoring and rebooting in 15 seconds")
else
	if deviceFamily$ <> "sebring" then tf99.SendBlock("Rebooting in 15 seconds")
end if

' Don't reboot on sebring
if deviceFamily$ <> "sebring" then
	sleep(15000)
	RebootSystem()
end if
