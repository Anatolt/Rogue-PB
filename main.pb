; http://pastebin.com/bJyN9Lb9
; https://github.com/Anatolt/Rogue-PB

EnableExplicit

#myName = "Rogue-PB v0.2"

Structure objects
  x.w
  y.w
  type.l ;   #player   #foe   #money   #stone   #tree   #water 
EndStructure

Global NewList all.objects(), worldW=30, worldH=30, ww = 10, hh = 10

#player = 16777215  ;white   RGB(255,255 ,255)
#foe = 255          ;red     RGB(255,0   ,0)
#money = 65535      ;yellow  RGB(255,255 ,0)
#stone = 8750469    ;grey    RGB(133,133 ,133)
#tree = 65280       ;green   RGB(0,  255 ,0)
#water = 16711680   ;blue    RGB(0,  0,  255)
#up = 0
#down = 1
#left = 2
#right = 3

Enumeration
  #canva
  #wnd
EndEnumeration

Procedure AddObj(x,y,type)
  AddElement(all())
  all()\x = x
  all()\y = y
  all()\type = type
;   Debug "x="+x+",y="+y+",type="+type
EndProcedure

Procedure.f Modulo(num.f)
  If num < 0
    ProcedureReturn -num
  EndIf
  ProcedureReturn num
EndProcedure

Procedure.f noise(x.l,y.l) 
  Protected n, q
  n=x+y*57 
  n=(n<<13)!n 
  q = ((n*(n*n*15731+789221)+1376312589)&$7fffffff) 
  ProcedureReturn (1.0 - q / 1073741824.0) 
EndProcedure

Global none = 0, Dim pWorld.l(worldH,worldW)

Procedure createMap()
  Protected noiseOffset = Random(10000), y, x, curnoise, type
  For y = 0 To worldH
    For x = 0 To worldW
      curnoise = Modulo(noise(x, y))
      Debug "x="+x+",y="+y+",curnoise="+curnoise
      ; If noise value is high enough
      If (curnoise > 0.5)
        Debug "we are here curnoise > 0.5"
        ; trying To create solid blocks of the same type
        If ((x - 1 >= 0) And Not (pWorld(x - 1,y) = none)) 
;           pWorld(x,y) = pWorld(x - 1,y);
;         ElseIf ((x + 1 < worldW) And Not (pWorld(x + 1,y) = none)) 
;           pWorld(x,y) = pWorld(x + 1,y);
;         ElseIf ((y - 1 >= 0) And Not (pWorld(x,y - 1) = none)) 
;           pWorld(x,y) = pWorld(x,y - 1);
;         ElseIf ((y + 1 < worldH) And Not (pWorld(x,y + 1) = none)) 
;           pWorld(x,y) = pWorld(x,y + 1);
;         ElseIf ((x + 1 < worldW) And (y + 1 < worldH) And Not (pWorld(x + 1,y + 1) = none)) 
;           pWorld(x,y) = pWorld(x + 1,y + 1);
;         ElseIf ((x - 1 >= 0) And (y + 1 < worldH) And Not (pWorld(x - 1,y + 1) = none)) 
;           pWorld(x,y) = pWorld(x - 1,y + 1);
;         ElseIf ((x + 1 < worldW) And (y - 1 >= 0) And Not (pWorld(x + 1,y - 1) = none)) 
;           pWorld(x,y) = pWorld(x + 1,y - 1);
;         ElseIf ((x - 1 >= 0) And (y - 1 >= 0) And Not (pWorld(x - 1,y - 1) = none)) 
;           pWorld(x,y) = pWorld(x - 1,y - 1);
        Else 
          

        EndIf
      Else 
        Debug "we are here curnoise NOT > 0.5"
        type = Random(3,1)
          Select type
            Case #player 
              pWorld(x,y) = #player
            Case #foe
              pWorld(x,y) = #foe
            Case #money
              pWorld(x,y) = #money
            Case 1
              pWorld(x,y) = #stone
            Case 2 
              pWorld(x,y) = #tree
            Case 3
              pWorld(x,y) = #water
            Default
              pWorld(x,y) = #White
          EndSelect
        ;pWorld(x,y) = none;
      EndIf
    Next
  Next
EndProcedure

; Procedure start()
;   AddObj(0,0,#player)
;   AddObj(5*ww,10*hh,#foe)
;   AddObj(10*ww,5*hh,#foe)
;   AddObj(4*ww,4*hh,#money)
;   AddObj(6*ww,6*hh,#stone)
;   AddObj(8*ww,8*hh,#tree)
;   AddObj(10*ww,10*hh,#water)
; EndProcedure  

Procedure MakeRandMap()
  Protected x, y
  For y = 0 To worldH
    For x = 0 To worldW
      AddObj(x*ww,y*hh,pWorld(x,y))
    Next
  Next
EndProcedure
createMap()
MakeRandMap()

Procedure DrawAllObj()
  Protected fin, i, x, y, type
  StartDrawing(CanvasOutput(#canva))
  Box(0,0,worldW*ww,worldH*hh,0)
  fin = ListSize(all())-1
  For i = 0 To fin
    SelectElement(all(),i)
    x = all()\x
    y = all()\y
    type = all()\type
    Select type
      Case #player 
        Box(x,y,ww,hh,#player)
      Case #foe
        Debug "type="+type
        Box(x,y,ww,hh,#foe)
      Case #money
        Box(x,y,ww,hh,#money)
      Case #stone
        Box(x,y,ww,hh,#stone)
      Case #tree 
        Box(x,y,ww,hh,#tree)
      Case #water
        Box(x,y,ww,hh,#water)
      Case 0
        Box(x,y,ww,hh,0)
      Default
        Debug "type="+type
        Box(x,y,ww,hh,#White)
    EndSelect
  Next
  StopDrawing()
EndProcedure

Macro moveIt
  Select param
    Case #up
      all()\y - hh
    Case #down
      all()\y + hh
    Case #left
      all()\x - ww
    Case #right
      all()\x + ww
  EndSelect
EndMacro

Procedure Move(param)
  ;player move
  SelectElement(all(),0)
  moveIt
  ;foe move
  SelectElement(all(),1)
  param = Random(3)
  moveIt
  SelectElement(all(),2)
  param = Random(3)
  moveIt
  DrawAllObj()
EndProcedure

OpenWindow(#wnd,#PB_Any,#PB_Any,worldW*ww,worldH*hh,#myName,#PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_ScreenCentered)
CanvasGadget(#canva,0,0,worldW*ww,worldH*hh)

AddKeyboardShortcut(#wnd,#PB_Shortcut_W,#up)
AddKeyboardShortcut(#wnd,#PB_Shortcut_S,#down)
AddKeyboardShortcut(#wnd,#PB_Shortcut_A,#left)
AddKeyboardShortcut(#wnd,#PB_Shortcut_D,#right)

; start()
DrawAllObj()


Repeat
  Define event = WaitWindowEvent()
  If event = #PB_Event_Menu And #PB_EventType_Focus ; only if mouse on canvas
    Select EventMenu()
      Case #up
        Move(#up)
      Case #down
        Move(#down)
      Case #left
        Move(#left)
      Case #right
        Move(#right)
    EndSelect
  EndIf
Until event = #PB_Event_CloseWindow