; http://pastebin.com/bJyN9Lb9
; https://github.com/Anatolt/Rogue-PB

EnableExplicit

#myName = "Rogue-PB v0.8"

Structure objects
  x.w
  y.w
  type.l ;   #player   #foe   #money   #stone   #tree   #water 
EndStructure

Global worldW=30, worldH=30
;прога не компилится, если worldW!=worldH
Global NewList all.objects(), ww = 20, hh = 20, Dim pWorld.l(worldH,worldW), www = worldW*ww, hhh = worldH*hh

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
  Protected y, x, type, curnoise.f, none
  For y = 0 To worldH
    For x = 0 To worldW
      curnoise = Modulo(noise(x,y))
      ;Debug "x="+x+",y="+y+",noise="+curnoise
      If curnoise > 0.6
        ;код который группирует похожие объекты. дерево - лес, камень - гряда, вода - озеро
        If ((x - 1 >= 0) And Not (pWorld(x - 1,y) = none)) 
          pWorld(x,y) = pWorld(x - 1,y);
        ElseIf ((x + 1 < worldW) And Not (pWorld(x + 1,y) = none)) 
          pWorld(x,y) = pWorld(x + 1,y);
        ElseIf ((y - 1 >= 0) And Not (pWorld(x,y - 1) = none)) 
          pWorld(x,y) = pWorld(x,y - 1);
        ElseIf ((y + 1 < worldH) And Not (pWorld(x,y + 1) = none)) 
          pWorld(x,y) = pWorld(x,y + 1);
        ElseIf ((x + 1 < worldW) And (y + 1 < worldH) And Not (pWorld(x + 1,y + 1) = none)) 
          pWorld(x,y) = pWorld(x + 1,y + 1);
        ElseIf ((x - 1 >= 0) And (y + 1 < worldH) And Not (pWorld(x - 1,y + 1) = none)) 
          pWorld(x,y) = pWorld(x - 1,y + 1);
        ElseIf ((x + 1 < worldW) And (y - 1 >= 0) And Not (pWorld(x + 1,y - 1) = none)) 
          pWorld(x,y) = pWorld(x + 1,y - 1);
        ElseIf ((x - 1 >= 0) And (y - 1 >= 0) And Not (pWorld(x - 1,y - 1) = none)) 
          pWorld(x,y) = pWorld(x - 1,y - 1);
        Else
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
        EndIf
      Else
        pWorld(x,y) = 0
      EndIf
    Next
  Next
EndProcedure

Macro place(num,typ)
  ;RandomSeed(Date())
  SelectElement(all(),num)
  x = Random(29,2)
  y = Random(29,2)
  While pWorld(x,y)
    x = Random(29,2)
    y = Random(29,2)
    all()\x = x*hh
    all()\y = y*ww
  Wend
  all()\type = typ
  Debug "placing to " + Str(x) + "," + Str(y)
EndMacro

Procedure player_foe_money()
  Protected x, y
  place(0, #player)
  place(1, #foe)
  place(2, #foe)
  place(3, #money)
  place(4, #money)
  place(5, #money)
EndProcedure  

Procedure MakeRandMap()
  Protected x, y
  For y = 0 To worldH
    For x = 0 To worldW
      AddObj(x*ww,y*hh,pWorld(x,y))
    Next
  Next
EndProcedure

Procedure DrawAllObj()
  Protected fin, i, x, y, type
  StartDrawing(CanvasOutput(#canva))
  Box(0,0,www,hhh,0)
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

Procedure moveIt(n)
  Protected pX, pY, param, ok
  SelectElement(all(),n)
  pX = all()\x / ww
  pY = all()\y / hh
  While Not ok
    param = Random(3)
    Select param
      Case #up
        If Not (pY = 0 Or pWorld(pX,pY-1))
          all()\y - hh
          ok = 1
        EndIf
      Case #down
        If Not (pWorld(pX,pY+1) Or pY = worldH-1)
          all()\y + hh
          ok = 1
        EndIf
      Case #left
        If Not (pX = 0 Or pWorld(pX-1,pY))
          all()\x - ww
          ok = 1
        EndIf
      Case #right
        If Not (pWorld(pX+1,pY) Or pX = worldW-1)
          all()\x + ww
          ok = 1
        EndIf
    EndSelect
  Wend
  ok = 0
EndProcedure

Procedure foeMove()
  moveIt(1)
  moveIt(2)
EndProcedure

Procedure playerMove(param)
  ; если соседний объект не проходим или соседний объект край уровня - ничего не делать
  ; если двинулся игрок - двигаются враги. если игрок не двигался - враги тоже не двигаются
  Protected player_x, player_y, pX, pY
  SelectElement(all(),0)
  pX = all()\x / ww
  pY = all()\y / hh
  Select param
    Case #up
      If Not (pY = 0 Or pWorld(pX,pY-1))
        all()\y - hh
        foeMove()
      EndIf
    Case #down
      If Not (pWorld(pX,pY+1) Or pY = worldH-1)
        all()\y + hh
        foeMove()
      EndIf
    Case #left
      If Not (pX = 0 Or pWorld(pX-1,pY))
        all()\x - ww
        foeMove()
      EndIf
    Case #right
      If Not (pWorld(pX+1,pY) Or pX = worldW-1)
        all()\x + ww
        foeMove()
      EndIf
  EndSelect
  DrawAllObj()
EndProcedure

OpenWindow(#wnd,#PB_Any,#PB_Any,www,hhh,#myName,#PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_ScreenCentered)
CanvasGadget(#canva,0,0,www,hhh)

AddKeyboardShortcut(#wnd,#PB_Shortcut_W,#up)
AddKeyboardShortcut(#wnd,#PB_Shortcut_S,#down)
AddKeyboardShortcut(#wnd,#PB_Shortcut_A,#left)
AddKeyboardShortcut(#wnd,#PB_Shortcut_D,#right)

createMap()
MakeRandMap()
player_foe_money()
DrawAllObj()

Repeat
  Define event = WaitWindowEvent()
  If event = #PB_Event_Menu And #PB_EventType_Focus ; only if mouse on canvas
    Select EventMenu()
      Case #up
;         Debug "нажата кнопка ВВЕРХ"
        playerMove(#up)
      Case #down
;         Debug "нажата кнопка ВНИЗ"
        playerMove(#down)
      Case #left
;         Debug "нажата кнопка ВЛЕВО"
        playerMove(#left)
      Case #right
;         Debug "нажата кнопка ВПРАВО"
        playerMove(#right)
    EndSelect
  EndIf
Until event = #PB_Event_CloseWindow