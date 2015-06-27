; http://pastebin.com/bJyN9Lb9
; https://github.com/Anatolt/Rogue-PB

EnableExplicit

#myName = "Rogue-PB v0.3"

Structure objects
  x.w
  y.w
  type.l ;   #player   #foe   #money   #stone   #tree   #water 
EndStructure

Global NewList all.objects(), worldW=30, worldH=30, ww = 10, hh = 10, Dim pWorld.l(worldH,worldW)

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

Procedure createMap()
  Protected y, x, type, curnoise.f
  For y = 0 To worldH
    For x = 0 To worldW
      curnoise = Modulo(noise(x,y))
;       Debug "x="+x+",y="+y+",noise="+curnoise
      If curnoise > 0.5
        type = Random(3)
        Select type
          Case #player 
            pWorld(x,y) = #player
          Case #foe
            pWorld(x,y) = #foe
          Case #money
            pWorld(x,y) = #money
          Case 0
            pWorld(x,y) = 0
          Case 1
            pWorld(x,y) = #stone
          Case 2 
            pWorld(x,y) = #tree
          Case 3
            pWorld(x,y) = #water
          Default
            Debug "Creation of map type ERROR"
        EndSelect
      Else
        pWorld(x,y) = 0
      EndIf
    Next
  Next
EndProcedure

Procedure start()
  AddObj(0,0,#player)
  AddObj(5*ww,10*hh,#foe)
  AddObj(10*ww,5*hh,#foe)
  AddObj(4*ww,4*hh,#money)
EndProcedure  

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
        Debug "type=DEAFULT"
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
  ; если соседний объект не проходим или соседний объект край уровня - ничего не делать
  
;   If 
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

start()
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