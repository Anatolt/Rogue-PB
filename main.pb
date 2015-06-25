#myName = "Rogue-PB v0.1"

Structure objects
  x.w
  y.w
  type.l ;   #player   #foe   #money   #stone   #tree   #water 
EndStructure

Global NewList all.objects(), w=300, h=300, ww = 10, hh = 10

#player = 16777215  ;white  Debug RGB(255,255 ,255)
#foe = 255          ;red    Debug RGB(255,0   ,0)
#money = 65535      ;yellow Debug RGB(255,255 ,0)
#stone = 8750469    ;grey   Debug RGB(133,133 ,133)
#tree = 65280       ;green  Debug RGB(0,  255 ,0)
#water = 16711680   ;blue   Debug RGB(0,  0,  255)
#up = 0
#down = 1
#left = 2
#right = 3

Enumeration
;   #player
;   #foe
;   #money
;   #stone
;   #tree
;   #water
  #canva
  #wnd
EndEnumeration

Procedure AddObj(x,y,type)
  AddElement(all())
  all()\x = x
  all()\y = y
  all()\type = type
EndProcedure

Procedure createMap()
  x = 10*Random(30,0)
  y = 10*Random(30,0)
EndProcedure

Procedure start()
  AddObj(0,0,#player)
  AddObj(50,100,#foe)
  AddObj(100,50,#foe)
  AddObj(40,40,#money)
  AddObj(60,60,#stone)
  AddObj(80,80,#tree)
  AddObj(100,100,#water)
EndProcedure  

Procedure DrawAllObj()
  StartDrawing(CanvasOutput(#canva))
  Box(0,0,w,h,0)
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
    EndSelect
  Next
  StopDrawing()
EndProcedure

Macro moveIt
    Select param
    Case #up
      all()\y - 10
    Case #down
      all()\y + 10
    Case #left
      all()\x - 10
    Case #right
      all()\x + 10
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
;   selectedObject = -1
  DrawAllObj()
EndProcedure

OpenWindow(#wnd,#PB_Any,#PB_Any,w,h,#myName,#PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_ScreenCentered)
CanvasGadget(#canva,0,0,w,h)

AddKeyboardShortcut(#wnd,#PB_Shortcut_W,#up)
AddKeyboardShortcut(#wnd,#PB_Shortcut_S,#down)
AddKeyboardShortcut(#wnd,#PB_Shortcut_A,#left)
AddKeyboardShortcut(#wnd,#PB_Shortcut_D,#right)

start()
DrawAllObj()

Repeat
  event = WaitWindowEvent()
    If event = #PB_Event_Menu And #PB_EventType_Focus ; только если мышь на канве
      Select EventMenu()
        Case #up
          Move(#up)
          Debug "W"
        Case #down
          Move(#down)
          Debug "S"
        Case #left
          Move(#left)
          Debug "A"
        Case #right
          Move(#right)
          Debug "D"
    EndSelect
  EndIf
  Until event = #PB_Event_CloseWindow