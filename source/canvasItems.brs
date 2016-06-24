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
         Text: "Total Session length: " + m.totalSessionTime + " ms    | "
         TextAttrs:{Color:"#FFCCCCCC", Font:"Medium",
         HAlign:"Left", VAlign:"VCenter",
         Direction:"LeftToRight"}
         TargetRect:{x:40,y:200,w:800,h:60}
     },
     {
         Text: "Time Without Interruption: " + m.timeWithoutInterruption + " ms"
         TextAttrs:{Color:"#FFCCCCCC", Font:"Medium",
         HAlign:"Left", VAlign:"VCenter",
         Direction:"LeftToRight"}
         TargetRect:{x:440,y:200,w:800,h:60}
     },
     {
         Text: "Bit Rate: " + m.bitRate + " bits per second   |  "
         TextAttrs:{Color:"#FFCCCCCC", Font:"Medium",
         HAlign:"Left", VAlign:"VCenter",
         Direction:"LeftToRight"}
         TargetRect:{x:40,y:250,w:800,h:60}
     },
     {
         Text: "Avg Bit Rate: " + m.avgBitRate
         TextAttrs:{Color:"#FFCCCCCC", Font:"Medium",
         HAlign:"Left", VAlign:"VCenter",
         Direction:"LeftToRight"}
         TargetRect:{x:440,y:250,w:800,h:60}
     },
     {
         Text: "TimeStamp of last interruption: " + m.timeOfLastInterruption
         TextAttrs:{Color:"#FFCCCCCC", Font:"Medium",
         HAlign:"Left", VAlign:"VCenter",
         Direction:"LeftToRight"}
         TargetRect:{x:40,y:300,w:800,h:60}
     },
     {
         Text: "Time since last interruption: " + m.beforeFirstVideoInterruption + " ms"
         TextAttrs:{Color:"#FFCCCCCC", Font:"Medium",
         HAlign:"Left", VAlign:"VCenter",
         Direction:"LeftToRight"}
         TargetRect:{x:40,y:350,w:800,h:60}
     },
     {
         Text: "Total Number of interruption: " + m.totalNumOfInterruptions
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
         Text: "Total of all Buffering Events: " + m.allBufferEvents
         TextAttrs:{Color:"#FFCCCCCC", Font:"Medium",
         HAlign:"Left", VAlign:"VCenter",
         Direction:"LeftToRight"}
         TargetRect:{x:40,y:600,w:800,h:60}
     },
     {
         Text: "Average of all Buffering Events: " + m.avgAllBufferEvents
         TextAttrs:{Color:"#FFCCCCCC", Font:"Medium",
         HAlign:"Left", VAlign:"VCenter",
         Direction:"LeftToRight"}
         TargetRect:{x:540,y:600,w:800,h:60}
     }
 ]
