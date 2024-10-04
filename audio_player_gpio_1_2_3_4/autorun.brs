sub Main()
    ' Initialize variables
    m.port = CreateObject("roMessagePort")

    ' Configure Audio player
    m.v = CreateObject("roAudioPlayer")
    m.v.SetPort(m.port)
    m.v.SetLoopMode(false)

    ' Set Volume
    m.v.SetVolume(100)

    ' Set up GPIO button listeners for navigation
    m.cp = CreateObject("roControlPort", "Brightsign") ' onbaord
    m.cp.SetPort(m.port)
    m.cp.EnableInput(0)
    m.cp.EnableInput(1)
    m.cp.EnableInput(2)
    m.cp.EnableInput(3)
    m.cp.EnableInput(4)

    ' Event loop to listen for button presses and play appropriate files
    while true
        msg = wait(0, m.port)
        if type(msg) = "roControlDown" then
            key = msg.GetInt()
            if key = 0 then' Button 0
                m.v.PlayFile("SD:/1.mp3")
            else if key = 1 then' Button 1
                m.v.PlayFile("SD:/2.mp3")
            else if key = 2 then' Button 2
                m.v.PlayFile("SD:/3.mp3")
            else if key = 3 then' Button 3
                m.v.PlayFile("SD:/4.mp3")
            end if
        end if
    end while
end sub
