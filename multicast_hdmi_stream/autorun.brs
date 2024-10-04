sub Main()

	m.mp = CreateObject("roMessagePort")

	m.vm = CreateObject("roVideoMode")
	' Set up HD resolution
	m.vm.SetMode("1920x1080x60p")
	m.vm.SetPort(m.mp)

	m.v = CreateObject("roVideoPlayer")
	m.r1 = CreateObject("roRectangle", 0, 0, 1920, 1080)
	m.v.SetRectangle(m.r1)
	m.v.SetPort(m.mp)


	' Stream hdmi-in to udp://239.194.0.202:2234
	m.streamer = CreateObject("roMediaStreamer")
	m.streamer.SetPipeline("hdmi:,encoder:vbitrate=15000,udp://239.0.0.10:4000")
	m.streamer.SetPort(m.mp)
	startStream()

	' Set up a timer to tune the stream. If it's not yet available, we will retry every second
	m.timer = CreateObject("roTimer")
	m.timer.SetPort(m.mp)
	m.timer.SetElapsed(1, 0)

	' Decode the hdmi-in stream
	playStream()

	' Wait for events
	while true
		ev = m.mp.WaitMessage(0)
		if type(ev) = "roTimerEvent" then
			' Try tuning to the stream. If it's not yet available, we will retry every second
			playStream()
		else if type(ev) = "roHdmiInputChanged" then
			print "=== Got Event: roHdmiInputChanged"
			print ev
			' If the user plugs in the hdmi cable to hdmi-in after boot-up, this will handle it
			startStream()
		else if type(ev) = "roVideoEvent" then
			num = ev.GetInt()
			if num = 3 then
				print "=== Stream is playing"
			else if num = 8 then
				print "=== Media endet, restarting"
				playStream()
			else if num = 26 then
				print "=== Underfollowing"
			else
				print "other roVideoEvent num:"
				print num
			end if
		else
			print "got other event"
			print type(ev)
			print ev
		end if
	end while

end sub


sub startStream()
	aa2 = m.vm.GetHdmiInputStatus()
	if type(aa2) = "roAssociativeArray" then
		print "GetHdmiInputStatus=";aa2
		if aa2.device_present then
			' Start the stream once hdmi-in is detected
			print "=== Starting Stremer"
			m.streamer.Start()
		end if
	else
		m.streamer.Reset()
	end if
end sub


sub playStream()
	rtspStream = CreateObject("roRtspStream", "udp://239.0.0.10:4000")
	aa = {}
	aa["Rtsp"] = rtspStream

	ok = m.v.PlayFile(aa)
	if ok then
		print "=== Up and running!"
	else
		print "=== Starting timer (again)"
		m.timer.Start()
	end if
end sub
