; http://pastebin.com/bJyN9Lb9 
; оригинальный код на C (c) de7
; https://github.com/Anatolt/Rogue-PB

EnableExplicit

#myName = "Rogue-PB v0.17"

Structure objects
  x.w
  y.w
  type.l ;   #player   #foe   #money   #stone   #tree   #water 
EndStructure

Global worldW=10, worldH=10
; прога не компилится, если worldW!=worldH
Global ww = 20, hh = 20, Dim pWorld.l(worldH+1,worldW+1), www = worldW*ww, hhh = worldH*hh, Money, playerX, playerY;, pX, pY

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
  #status
  #wnd
  ; #up
  ; #down
  ; #left
  ; #right
EndEnumeration

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

Procedure generateRandomMap()
  Protected y, x, type, curnoise.f, none
  For y = 0 To worldH
    For x = 0 To worldW
      curnoise = Modulo(noise(x,y))
      ;Debug "x="+x+",y="+y+",noise="+curnoise
      If curnoise > 0.7
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
            Case 0
              pWorld(x,y) = 0
            Case 1
              pWorld(x,y) = #stone
            Case 2 
              pWorld(x,y) = #tree
            Case 3
              pWorld(x,y) = #water
          EndSelect
        EndIf
      Else
        pWorld(x,y) = 0
      EndIf
      ; строим оградку вокруг мира
      pWorld(0,y) = #stone
      pWorld(x,0) = #stone
      pWorld(x,worldW+1) = #stone
      pWorld(worldH+1,y) = #stone
    Next
  Next
EndProcedure

Procedure.s num2names(type)
  Protected txt$
  If type = 16777215
    txt$ = "#player"
  ElseIf type = 255
    txt$ = "#foe"
  ElseIf type = 65535
    txt$ = "#money"
  EndIf
  ProcedureReturn txt$
EndProcedure
  
Macro place(type)
  x = Random(worldW,2)
  y = Random(worldH,2)
  While pWorld(x,y)
    Debug Str(x)+ "," + Str(y) + " занято"
    x = Random(worldW,2)
    y = Random(worldH,2)
  Wend
  pWorld(x,y) = type
  Debug "placing "+num2names(type)+" To " + Str(x) + "," + Str(y)
EndMacro

Procedure player_foe_money()
  Protected x, y, txt$
  place(#foe)
  place(#foe)
  place(#money)
  place(#money)
  place(#money)
  ;place player
  x = Random(worldW,2)
  y = Random(worldH,2)
  While pWorld(x,y)
    Debug Str(x)+ "," + Str(y) + " занято"
    x = Random(worldW,2)
    y = Random(worldH,2)
  Wend
  playerX = x
  playerY = y
EndProcedure  

Macro bx(param)
Case param 
  Box(pX,pY,ww,hh,param)
EndMacro

Procedure DrawAllObj()
  Protected i, x, y, type, pX, pY
  StartDrawing(CanvasOutput(#canva))
  Box(0,0,www,hhh,0)
  For y = 1 To worldH
    For x = 1 To worldW
      type = pWorld(x,y)
      pX = x * ww - ww
      pY = y * hh - hh
      Select type
          bx(#foe)
        Case #money 
          Circle(pX+ww/2,pY+ww/2,ww/2-1,#money)
          Money+1
          bx(#stone)
        Case #tree 
          Box(pX,pY,ww,hh/2,#tree)
          Box(pX+hh/2,pY+ww/2,ww/10,hh/2,RGB(150, 75, 0))
          bx(#water)
      EndSelect
    Next
  Next
  Box(playerX*ww-ww,playerY*hh-hh,ww,hh,#player)
  StopDrawing()
  SetGadgetText(#status,"Coins: "+Str(Money))
EndProcedure

Macro dead
  MessageRequester(#myName,"Player is dead. Game Over")
EndMacro

Macro pMove(axis,sub,arg)
  If axis = "y"
    pY = sub
  ElseIf axis = "x"
    pX = sub
  EndIf
  If Not arg
    ok = 1
  ElseIf arg = #money
    pWorld(pX,pY) = 0
    ok = 1
  Else
    Debug "занято "+Str(pX)+","+Str(pY)+","+Str(pWorld(pX,pY))
  EndIf
EndMacro

Procedure foeMove(playerX,playerY)
  Protected x, y, arg, sub, pX, pY, ok, param
  For y = 1 To worldH
    For x = 1 To worldW
      If pWorld(x,y) = #foe
        Debug "we find a foe"
        pX = x
        pY = y
        param = Random(3)
        Select param
          Case #up
            sub = pY-1
            arg = pWorld(pX,sub)
            pMove("y",sub,arg)
            
          Case #down
            sub = pY+1
            arg = pWorld(pX,sub)
            pMove("y",sub,arg) 
            
          Case #left
            sub = pX-1
            arg = pWorld(sub,pY)
            pMove("x",sub,arg)
            
          Case #right
            sub = pX+1
            arg = pWorld(sub,pY)
            pMove("x",sub,arg)
        EndSelect
      EndIf
      If ok
        pWorld(x,y) = 0
        pWorld(pX,pY) = #foe
      EndIf
      ok = 0
    Next
  Next
EndProcedure

Procedure playerMove(param)
  ; если соседний объект не проходим или соседний объект край уровня - ничего не делать
  ; если двинулся игрок - двигаются враги. если игрок не двигался - враги тоже не двигаются
  Protected arg, sub, pX, pY, ok
  pX = playerX
  pY = playerY
  Select param
    Case #up
      sub = pY-1
      arg = pWorld(pX,sub)
      pMove("y",sub,arg)
    Case #down
      sub = pY+1
      arg = pWorld(pX,sub)
      pMove("y",sub,arg) 
    Case #left
      sub = pX-1
      arg = pWorld(sub,pY)
      pMove("x",sub,arg)
      
    Case #right
      sub = pX+1
      arg = pWorld(sub,pY)
      pMove("x",sub,arg)
      
  EndSelect
  If ok
    playerY = pY
    playerX = pX
    foeMove(playerX, playerY)
  EndIf
  ok = 0
  DrawAllObj()
EndProcedure

OpenWindow(#wnd,#PB_Any,#PB_Any,www,hhh+20,#myName,#PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_ScreenCentered)
CanvasGadget(#canva,0,0,www,hhh)
TextGadget(#status,hhh,0,www,20,"hi")

AddKeyboardShortcut(#wnd,#PB_Shortcut_W,#up)
AddKeyboardShortcut(#wnd,#PB_Shortcut_S,#down)
AddKeyboardShortcut(#wnd,#PB_Shortcut_A,#left)
AddKeyboardShortcut(#wnd,#PB_Shortcut_D,#right)

generateRandomMap()
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