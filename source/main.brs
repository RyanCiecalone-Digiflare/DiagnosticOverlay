' Fix the bug with the flashing. Fixed!!!
' Total session length is resetting, it shouldn't. Fixed !!!
' Make sure avg number of interruptions works.  Appears to work!!!
' Average bit rate is not changing. Need to fix.  Appears to work!!!
' Remove bottom line.  Make the line appear when the event is triggered.
' Title is not showing up properly
Sub RunUserInterface()
    o = Setup()
    o.setup()
    o.paint()
    o.eventloop()
End Sub

Sub Setup() As Object
    this = {
        port:      CreateObject("roMessagePort")
        progress:  0 'buffering progress
        position:  0 'playback position (in seconds)
        paused:    false 'is the video currently paused?
        feedData:  invalid
        playing:   0
        playingPrev: 0
        playlistSize: 0
        canvas:    CreateObject("roImageCanvas") 'user interface
        player:    CreateObject("roVideoPlayer")
        load:      LoadFeed
        setup:     SetupFullscreenCanvas
        paint:     PaintFullscreenCanvas
        create_playlist_text: CreatePlaylistText
        timeStampGMT : "0"
        timeStampLocal: "0"
        timeElapsedBeforePlay: "0"
        timeWithoutInterruption: "0"
        totalSessionTime: "0"
        bitRate: "0"
        title: ""
        totalNumOfInterruptions: "0"
        avgBetweenInterruptions: 0
        interruptionTimeTotal: 0
        beforeFirstVideoInterruption: "No Interruptions yet"
        timeOfLastInterruption: "No Interruptions yet"
        interruptionTimeTotal: "0"
        avgBetweenInterruptions: "0"
        totalNumOfInterruptions: "0"
        timeElapsedBetweenInterruptions: "0"
        timeOfLastBuffer: "No Buffering Yet"
        totalBufferEvents: "-1"
        avgAllBufferEvents: "0 ms"
        bufferTimeTotal: 0
        numOfBitrateChanges: 0
        bitRateTotal: 0
        avgBitRate: "0"
		    drawtext:  false
        eventloop: EventLoop
        bufferEventsExist: false
    }

    this.targetRect = this.canvas.GetCanvasRect()
    this.textRect = {x: 520, y: 480, w: 300, h:200}

    this.load()
    'Setup image canvas:
    this.canvas.SetMessagePort(this.port)
    this.canvas.SetLayer(0, { Color: "#000000" })
    this.canvas.Show()

    this.player.SetMessagePort(this.port)
    this.player.SetLoop(true)
    this.player.SetPositionNotificationPeriod(1)
    this.player.SetDestinationRect(this.targetRect)

    this.player.Play()
    this.playingPrev = this.playing

    return this
End Sub

Sub EventLoop()

    'initialize variables for event loop'

    'Create Clocks for GMT and local values'
    diagClockGMT = CreateObject("roDateTime")
    diagClockLocal = CreateObject("roDateTime")
    diagClockLocal.ToLocalTime()
    diagTimer = CreateObject("roTimespan")
    diagTotalTimer = CreateObject("roTimespan")
    bufferTimer = CreateObject("roTimespan")

    timeElapsedBeforePlayback = ""

    'set up customized time stamp'

    initiatedTimeStampDateGMT = diagClockGMT.AsDateString("short-date")
    initiatedTimeStampHoursGMT = itostr(diagClockGMT.GetHours())
    initiatedTimeStampMinutesGMT = itostr(diagClockGMT.GetMinutes())
    initiatedTimeStampSecondsGMT = itostr(diagClockGMT.GetSeconds())
    initiatedTimeStampMillisecondsGMT = itostr(diagClockGMT.GetMilliseconds())
    m.timeStampGMT = initiatedTimeStampDateGMT + " " + initiatedTimeStampHoursGMT.Trim() + ":" + initiatedTimeStampMinutesGMT.Trim() + ":" + initiatedTimeStampSecondsGMT.Trim() + ":" + initiatedTimeStampMillisecondsGMT.Trim() + " (GMT)"
    ' (hh:mm.s.ms GMT)


    'set up customized time stamp'
    initiatedTimeStampDateLocal = diagClockGMT.AsDateString("short-date")
    initiatedTimeStampHoursLocal = itostr(diagClockLocal.GetHours())
    initiatedTimeStampMinutesLocal = itostr(diagClockLocal.GetMinutes())
    initiatedTimeStampSecondsLocal = itostr(diagClockLocal.GetSeconds())
    initiatedTimeStampMillisecondsLocal = itostr(diagClockLocal.GetMilliseconds())
    m.timeStampLocal = initiatedTimeStampDateLocal + " " + initiatedTimeStampHoursLocal.Trim() + ":" + initiatedTimeStampMinutesLocal.Trim() + ":" + initiatedTimeStampSecondsLocal.Trim() + ":" + initiatedTimeStampMillisecondsLocal.Trim() + " (Local)"

    while true
        msg = wait(0, m.port)
          m.paint()
          ' ? msg " message ************************"
          m.totalSessionTime = diagTotalTimer.TotalMilliseconds()
          m.totalSessionTime = itostr(m.totalSessionTime)
          ' ? m.totalSessionTime " session time"



          '   textArr2 = m.create_playlist_text()
          '  for each str in textArr2
          '      if index = m.playing
          '        ? m.playing " playing *******************"
          '      end if
          '  end for
           m.title = m.passTitle

          if msg.isStatusMessage()
              playStatusMessage = msg.GetMessage()
                  if (playStatusMessage = "start of play")

                        ' initiatedTimeStamp = diagClockGMT.ToISOString()
                        m.timeElapsedBeforePlay = diagTimer.TotalMilliseconds()
                        m.timeElapsedBeforePlay = itostr(m.timeElapsedBeforePlay)
                        diagClockGMT.Mark()
                        ' Print "Task took: " + m.timeElapsedBeforePlay
                  end if
            end if

            if msg.isStreamStarted()
              m.bitRate = m.bitRate.ToInt()
              m.bitRate = msg.getInfo().MeasuredBitrate
              m.numOfBitrateChanges += 1
              ' ? m.numOfBitrateChanges " bit rate changes ***********************"
              m.bitRateTotal += m.bitRate
              m.avgBitRate = m.bitRateTotal / m.numOfBitrateChanges
              m.avgBitRate = itostr(m.avgBitRate)
              m.bitRate = itostr(m.bitRate)
              ' ? m.bitRate " bit rate **********************************"
              diagTimer.Mark()
              ? " stream started"
              ? m.timeStampGMT
              if msg.GetInfo().IsUnderrun
              end if
            end if
            m.timeWithoutInterruption = diagTimer.TotalMilliseconds()
            m.timeWithoutInterruption = itostr(m.timeWithoutInterruption)
            ' ? m.timeWithoutInterruption " time "

            if m.progress < 100
                  if m.progress = 0
                    buffering = true
                    bufferTimer.Mark()
                    m.totalBufferEvents = m.totalBufferEvents.ToInt()
                    m.totalBufferEvents += 1
                    m.totalBufferEvents = m.totalBufferEvents.ToStr()
                  end if
                  ' ? m.totalBufferEvents " buffer events *******************"
                ' ? m.progress " progress ********************************"
            else if  buffering = 100
                m.timeOfLastBuffer = bufferTimer.TotalMilliseconds()
                ? m.timeOfLastBuffer " buffer time"
                m.bufferTimeTotal += m.timeOfLastBuffer
                m.avgAllBufferEvents = m.bufferTimeTotal / m.totalBufferEvents.ToInt()
                ? m.avgAllBufferEvents " all buffer events average *********************"
                buffering = false
                m.avgAllBufferEvents = m.avgAllBufferEvents.tostr()
                m.timeOfLastBuffer = bufferTimer.TotalMilliseconds().tostr()
            end if

            if msg.isPaused()
              ? " paused  "
              m.timeElapsedBetweenInterruptions = m.timeElapsedBetweenInterruptions.ToInt()
              m.timeElapsedBetweenInterruptions = diagTimer.TotalMilliseconds()
              ' ? timeForTest " time test *************************"
              m.beforeFirstVideoInterruption = diagTimer.TotalMilliseconds()
              m.beforeFirstVideoInterruption = itostr(m.beforeFirstVideoInterruption) + " ms"
              ' ? " Time since last interruption " m.beforeFirstVideoInterruption
              ' stamp = diagTimer.TotalMilliseconds()
              diagClockGMT2 = CreateObject("roDateTime")
              initiatedTimeStampDateGMT = diagClockGMT2.AsDateString("short-date")
              initiatedTimeStampHoursGMT = itostr(diagClockGMT2.GetHours())
              initiatedTimeStampMinutesGMT = itostr(diagClockGMT2.GetMinutes())
              initiatedTimeStampSecondsGMT = itostr(diagClockGMT2.GetSeconds())
              initiatedTimeStampMillisecondsGMT = itostr(diagClockGMT2.GetMilliseconds())
              m.timeStampGMT = initiatedTimeStampDateGMT + " " + initiatedTimeStampHoursGMT.Trim() + ":" + initiatedTimeStampMinutesGMT.Trim() + ":" + initiatedTimeStampSecondsGMT.Trim() + ":" + initiatedTimeStampMillisecondsGMT.Trim() + " (GMT)"
              ' (hh:mm.s.ms GMT)
              m.timeOfLastInterruption = m.timeStampGMT
              m.timeElapsedBetweenInterruptions = itostr(m.timeElapsedBetweenInterruptions)

            end if
            if msg.isResumed()
            m.avgBetweenInterruptions = m.avgBetweenInterruptions.ToInt()
            m.interruptionTimeTotal = m.interruptionTimeTotal.ToInt()
            m.totalNumOfInterruptions = m.totalNumOfInterruptions.ToInt()
            ' ? type(m.totalNumOfInterruptions) " total num"
            ' m.interruptionTimeTotal = ToInt(m.interruptionTimeTotal)
              stamp2 = diagTimer.TotalMilliseconds()
              ' ? stamp2 " stamp 2"
              ' ? "Time of last interruption " stamp2
              diagTimer.Mark()
              m.totalNumOfInterruptions += 1
              ' ? m.totalNumOfInterruptions " num of interruptions"

              m.interruptionTimeTotal += stamp2
              ' ? m.interruptionTimeTotal " interruption time total"

              m.avgBetweenInterruptions = m.interruptionTimeTotal / m.totalNumOfInterruptions
              m.avgBetweenInterruptions = itostr(m.avgBetweenInterruptions)
              m.interruptionTimeTotal = itostr(m.interruptionTimeTotal)
              m.totalNumOfInterruptions = itostr(m.totalNumOfInterruptions)
              ' ? m.avgBetweenInterruptions " interruption avg"
            end if
            timeBeforeInterruption = stamp2


        if msg <> invalid
            if msg.isStatusMessage() and msg.GetMessage() = "startup progress"
                m.paused = false
                ' print "Raw progress: " + stri(msg.GetIndex())
                progress% = msg.GetIndex() / 10
                if m.progress <> progress%
                    m.progress = progress%
                    m.paint()
                end if

            'Playback progress (in seconds):
            else if msg.isPlaybackPosition()
                m.position = msg.GetIndex()
                ' print "Playback position: " + stri(m.position)

            else if msg.isRemoteKeyPressed()
                index = msg.GetIndex()
                print "Remote button pressed: " + index.tostr()
                if index = 4  '<LEFT>
                    m.playing = m.playing - 1
                    if (m.playing < 0)
                        m.playing = 2
                    endif
                    m.player.SetNext(m.playing)
                    m.player.Play()
                    m.playingPrev = m.playing
                else if index = 8 '<REV>
                    m.position = m.position - 60
                    m.player.Seek(m.position * 1000)
                else if index = 5 '<RIGHT>
                    m.playing = m.playing + 1
                    if (m.playing > 2)
                        m.playing = 0
                    endif
                    m.player.SetNext(m.playing)
                    m.player.Play()
                    m.playingPrev = m.playing
                else if index = 9 '<REV>
                    m.position = m.position + 60
                    m.player.Seek(m.position * 1000)
                else if index = 2 '<Up>
                    if m.drawtext
                        m.playing = m.playing - 1
                        if (m.playing < 0)
                            m.playing = m.playlistSize-1
                        endif
                        m.paint()
                    endif
                else if index = 3 '<Down>
                    if m.drawtext
                        m.playing = m.playing + 1
                        if (m.playing > m.playlistSize-1)
                            m.playing = 0
                        endif
                        m.paint()
                    endif
                else if index = 13  '<PAUSE/PLAY>
                    if m.paused m.player.Resume() else m.player.Pause()
				else if index = 6 'OK
					if m.drawtext
					   m.drawtext = false
					   if m.playing <> m.playingPrev
                            m.player.SetNext(m.playing)
						  m.player.Play()
						  m.playingPrev = m.playing
					   endif
					else
						m.drawtext = true
					endif
					m.paint()
                end if

            else if msg.isPaused()
                m.paused = true
                m.paint()

            else if msg.isResumed()
                m.paused = false
                m.paint()
            end if
        endif
    end while
End Sub

Sub SetupFullscreenCanvas()
    m.canvas.AllowUpdates(false)
    m.paint()
    m.canvas.AllowUpdates(true)
End Sub

Sub PaintFullscreenCanvas()
    splash = []
    list = []

    textArr = m.create_playlist_text()
      m.passTitle = textArr[m.playing]

    if m.progress < 100
        progress_bar = {TargetRect: {x: 350, y: 500, w: 598, h: 37}, url: "pkg:/images/progress_bar.png"}
        color = "#00a0a0a0"
        splash.Push({
            url: "pkg:/images/splash.png"
            TargetRect: m.targetRect
        })
        list.Push({
            Text: "Loading..."
            TextAttrs: { font: "large", color: "#707070" }
            TargetRect: m.textRect
        })
        if m.progress >= 0 AND m.progress < 20
            progress_bar.url = "pkg:/images/progress_bar_1.png"
            ' print progress_bar.url
        else if m.progress >= 20 AND m.progress < 40
            progress_bar.url = "pkg:/images/progress_bar_2.png"
            ' print progress_bar.url
        else if m.progress >= 40 AND m.progress < 75
            progress_bar.url = "pkg:/images/progress_bar_3.png"
            ' print progress_bar.url
        else
            progress_bar.url = "pkg:/images/progress_bar_4.png"
            ' print progress_bar.url
        endif
        list.Push(progress_bar)

    end if

	if m.drawtext

	   textArr = m.create_playlist_text()
	   yTxt = 100
		color = "#00000000"
		index = 0
		for each str in textArr
		    if index = m.playing
		      textColor = "#00ff00"
		    else
		      textColor = "#dddddd"
		    endif
    		list.Push({
    			Text: str
    			TextAttrs: {color: textColor, font: "medium"}
    			TargetRect: {x:200, y:yTxt, w: 500, h: 100}
    		})
    		yTxt = yTxt + 100
    		index = index + 1
		end for
	else
		color = "#00000000"
		list.Push({
			Text: ""
			TextAttrs: {font: "medium"}
			TargetRect: {x:100, y:600, w: 300, h: 100}
		})

    m.canvas1Items = [
         {
             Text: "Video Diagnostics"
             TextAttrs:{Color:"#FFCCCCCC", Font:"Medium",
             HAlign:"Left", VAlign:"VCenter",
             Direction:"LeftToRight"}
             TargetRect:{x:40,y:0,w:700,h:60}
         },
         {
             Text: "Stream Initiated at: " + m.timeStampGMT + "  |  " + m.timeStampLocal
             TextAttrs:{Color:"#FFCCCCCC", Font:"Medium",
             HAlign:"Left", VAlign:"VCenter",
             Direction:"LeftToRight"}
             TargetRect:{x:40,y:50,w:1200,h:60}
         },
         {
             Text: "Time Elapsed Before Video Playback: " + m.timeElapsedBeforePlay + " ms"
             TextAttrs:{Color:"#FFCCCCCC", Font:"Medium",
             HAlign:"Left", VAlign:"VCenter",
             Direction:"LeftToRight"}
             TargetRect:{x:40,y:100,w:700,h:60}
         },
         {
             Text: "Stream Name: " + m.title,
             TextAttrs:{Color:"#FFCCCCCC", Font:"Medium",
             HAlign:"Left", VAlign:"VCenter",
             Direction:"LeftToRight"}
             TargetRect:{x:40,y:150,w:800,h:60}
         },
         {
             Text: "Total Session length: " + m.totalSessionTime + " ms    "
             TextAttrs:{Color:"#FFCCCCCC", Font:"Medium",
             HAlign:"Left", VAlign:"VCenter",
             Direction:"LeftToRight"}
             TargetRect:{x:40,y:200,w:800,h:60}
         },
         {
             Text: "  |       Time Without Interruption: " + m.timeWithoutInterruption + " ms"
             TextAttrs:{Color:"#FFCCCCCC", Font:"Medium",
             HAlign:"Left", VAlign:"VCenter",
             Direction:"LeftToRight"}
             TargetRect:{x:440,y:200,w:800,h:60}
         },
         {
             Text: "Current Bit Rate: " + m.bitRate + " bits per second   "
             TextAttrs:{Color:"#FFCCCCCC", Font:"Medium",
             HAlign:"Left", VAlign:"VCenter",
             Direction:"LeftToRight"}
             TargetRect:{x:40,y:250,w:800,h:60}
         },
         {
             Text: "  |       Avg Bit Rate: " + m.avgBitRate
             TextAttrs:{Color:"#FFCCCCCC", Font:"Medium",
             HAlign:"Left", VAlign:"VCenter",
             Direction:"LeftToRight"}
             TargetRect:{x:520,y:250,w:800,h:60}
         },
         {
             Text: "TimeStamp of last interruption: " + m.timeOfLastInterruption
             TextAttrs:{Color:"#FFCCCCCC", Font:"Medium",
             HAlign:"Left", VAlign:"VCenter",
             Direction:"LeftToRight"}
             TargetRect:{x:40,y:300,w:800,h:60}
         },
         {
             Text: "Length of last interruption: " + m.beforeFirstVideoInterruption
             TextAttrs:{Color:"#FFCCCCCC", Font:"Medium",
             HAlign:"Left", VAlign:"VCenter",
             Direction:"LeftToRight"}
             TargetRect:{x:40,y:350,w:800,h:60}
         },
         {
             Text: "Total Number of interruptions: " + m.totalNumOfInterruptions
             TextAttrs:{Color:"#FFCCCCCC", Font:"Medium",
             HAlign:"Left", VAlign:"VCenter",
             Direction:"LeftToRight"}
             TargetRect:{x:40,y:400,w:800,h:60}
         },
         {
             Text: "Average Time Between Interruptions: " + m.avgBetweenInterruptions + " ms"
             TextAttrs:{Color:"#FFCCCCCC", Font:"Medium",
             HAlign:"Left", VAlign:"VCenter",
             Direction:"LeftToRight"}
             TargetRect:{x:40,y:450,w:800,h:60}
         },
         {
             Text: "Time Elapsed Between Interruptions: " + m.timeElapsedBetweenInterruptions + " ms"
             TextAttrs:{Color:"#FFCCCCCC", Font:"Medium",
             HAlign:"Left", VAlign:"VCenter",
             Direction:"LeftToRight"}
             TargetRect:{x:40,y:500,w:800,h:60}
         },
         {
             Text: "Length Of Last Buffering Event: " + m.timeOfLastBuffer
             TextAttrs:{Color:"#FFCCCCCC", Font:"Medium",
             HAlign:"Left", VAlign:"VCenter",
             Direction:"LeftToRight"}
             TargetRect:{x:40,y:550,w:800,h:60}
         },
         {
             Text: "Total of all Buffering Events: " + m.totalBufferEvents
             TextAttrs:{Color:"#FFCCCCCC", Font:"Medium",
             HAlign:"Left", VAlign:"VCenter",
             Direction:"LeftToRight"}
             TargetRect:{x:40,y:600,w:800,h:60}
         }
         {
             Text: "Average of all Buffering Events: " + m.avgAllBufferEvents
             TextAttrs:{Color:"#FFCCCCCC", Font:"Medium",
             HAlign:"Left", VAlign:"VCenter",
             Direction:"LeftToRight"}
             TargetRect:{x:540,y:600,w:800,h:60}
         }
     ]
	endif


    'Clear previous contents
    ' m.canvas.ClearLayer(0)
    ' m.canvas.ClearLayer(1)
    ' m.canvas.ClearLayer(2)

    m.canvas.SetLayer(0, { Color: color, CompositionMode: "Source" })
    if (splash.Count() > 0)
        m.canvas.SetLayer(1, splash)
        m.canvas.SetLayer(2, list)
    ' else if m.bufferEventsExist = true
    '     m.canvas1Items.push(bufferItems1)
    '     m.canvas1Items.push(bufferItems2)
    '     ? " hit ******************"
    '     ? m.canvas1Items " canvas items ************************"
    '     m.canvas.SetLayer(1, {Color:"#D9000000", CompositionMode:"Source"})
    '     m.canvas.SetLayer(2, m.canvas1Items)
    else if m.bufferEventsExist = false
        m.canvas.SetLayer(1, {Color:"#D9000000", CompositionMode:"Source"})
        m.canvas.SetLayer(2, m.canvas1Items)
    endif
    list.Clear()
    splash.Clear()
End Sub

Function LoadFeed() as void
    jsonAsString = ReadAsciiFile("pkg:/json/feed.json")
    m.feedData = ParseJSON(jsonAsString)
    m.playlistSize = m.feedData.Videos.Count()
    contentList = []
    for each video in m.feedData.Videos
        contentList.Push({
            Stream: { url: video.url }
            StreamFormat: "mp4"
        })
    end for
    m.player.SetContentList(contentList)
End Function

Function CreatePlaylistText() as object
    textArr = []
    for each video in m.feedData.Videos
        textArr.Push(video.title)
    end for
    return textArr
End Function


Function itostr(i As Integer) As String
    str = Stri(i)
    return str
End Function

Function strtoi(s As String) As Integer
    i = I(s)
    return s
End Function
