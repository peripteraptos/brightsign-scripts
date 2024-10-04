sub Main()
    ' Initialize variables
    m.port = CreateObject("roMessagePort")
    m.sdCardPath = "SD:/" ' Adjust this path if needed
    m.volume = 100 ' Adjust this if needed
    m.playlist = []
    currentIndex = 0

    ' Load the playlist with all files on the SD card
    LoadPlaylist()

    ' Configure the Audio Player
    m.v = CreateObject("roAudioPlayer")
    m.v.SetPort(m.port)
    m.v.SetLoopMode(false)
    m.v.SetVolume(m.volume)

    ' Play the first file
    m.v.PlayFile(m.playlist[currentIndex])

    ' Set up GPIO button listeners for navigation
    m.cp = CreateObject("roControlPort", "Brightsign") ' onbaord
    m.cp.SetPort(m.port)
    m.cp.EnableInput(0)
    m.cp.EnableInput(1)
    m.cp.EnableInput(2)

    ' Event loop to listen for button presses and play appropriate files
    while true
        msg = wait(0, m.port)
        if type(msg) = "roAudioEvent" and msg.GetInt() = 8 then
            print "file ended"
            ' Automatically loop to the next file after the current file ends
            currentIndex = currentIndex + 1
            if currentIndex >= m.playlist.count() then
                currentIndex = 0 ' Loop back to the beginning
            end if
            m.v.PlayFile(m.playlist[currentIndex])
        else if type(msg) = "roControlDown"
            key = msg.GetInt()
            if key = 0 ' Next button
                print "next button pressed"
                currentIndex = currentIndex + 1
                if currentIndex >= m.playlist.count() then
                    currentIndex = 0 ' Loop back to the beginning
                end if
            else if key = 1 ' Previous button
                print "prev button pressed"
                currentIndex = currentIndex - 1
                if currentIndex < 0 then
                    currentIndex = m.playlist.count() - 1 ' Loop to the end
                end if
            end if
            m.v.PlayFile(m.playlist[currentIndex])
        else if msg <> invalid:
            print "other event: " + type(msg)
        end if
    end while
end sub

' Function to load all files from the SD card into the playlist array
sub LoadPlaylist()
    m.playlist = []
    dirList = ListDir(m.sdCardPath)

    for each file in dirList
        if file <> "." and file <> ".." and IsPlayableFile(file)
            m.playlist.push(m.sdCardPath + file)
        end if
    end for
end sub


function IsPlayableFile(filename as string) as boolean
    ' Convert the filename to lowercase for case-insensitive comparison
    filename = LCase(filename)

    ' List of allowed extensions
    allowedExtensions = [".wav", ".mp3"]

    ' Iterate through each extension and check if the filename ends with it
    for each extension in allowedExtensions
        if Right(filename, Len(extension)) = extension then
            if Left(filename, 1) <> "." then
                return true
            end if
        end if
    end for

    ' Return false if no matching extension is found
    return false
end function
