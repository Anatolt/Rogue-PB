; http://pastebin.com/bJyN9Lb9 
; оригинальный код на C (c) de7
; https://github.com/Anatolt/Rogue-PB

EnableExplicit

#myName = "Rogue-PB v0.20"

Structure objects
  x.w
  y.w
  type.l ;   #player   #foe   #money   #stone   #tree   #water 
EndStructure

Global worldW=60, worldH=40
Global ww = 8, hh = 12, Dim pWorld.l(worldW+1,worldH+1), www = worldW*ww, hhh = worldH*hh, Money, Lvl, playerX, playerY, count;, pX, pY

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
#canva = 4
#status = 5
#wnd = 6
#restart = 7

Enumeration
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
      pWorld(x,worldH+1) = #stone
      pWorld(worldW+1,y) = #stone
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
  Protected x, y, i, txt$
  For i = 1 To Lvl
    place(#foe)
    place(#money)
  Next
  Money = Lvl
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

Procedure start()
  Lvl = 1
EndProcedure

Procedure restart()
;   Protected x, y
;   FreeArray(pWorld())
  generateRandomMap()
  player_foe_money()
  count = 0
EndProcedure

Procedure DrawAllObj()
  Protected i, x, y, type, pX, pY
  If Money
    SetGadgetText(#status,"Coins: "+Str(Money)+" Lvl: "+Str(Lvl)+" Moves: "+Str(count))
  Else
    Lvl+1
    MessageRequester(#myName,"You collect all coins. Welcome to "+Str(Lvl)+" level")
    restart()
  EndIf
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
          bx(#stone)
        Case #tree 
          Box(pX,pY,ww,hh/2,#tree)
          Box(pX+hh/4,pY+ww/2,ww/4,hh/2,RGB(150, 75, 0))
          bx(#water)
      EndSelect
    Next
  Next
  Box(playerX*ww-ww,playerY*hh-hh,ww,hh,#player)
  StopDrawing()
EndProcedure

Macro dead
  MessageRequester(#myName,"Player is dead. Game Over")
  restart()
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
    Money - 1
    ok = 1
  Else
    If player
      Debug "Ход:"+Str(count)+" Игрок: занято "+Str(pX)+","+Str(pY)+","+Str(pWorld(pX,pY))
    Else
      Debug "Ход:"+Str(count)+" Враг: занято "+Str(pX)+","+Str(pY)+","+Str(pWorld(pX,pY))
    EndIf
  EndIf
  If ok
    player = 0
  EndIf
EndMacro

Procedure foeMove(playerX,playerY)
  Protected x, y, arg, sub, pX, pY, ok, param, player
  For y = 1 To worldH
    For x = 1 To worldW
      If pWorld(x,y) = #foe
        If x = PlayerX And y = PlayerY
          dead
        EndIf
        pX = x
        pY = y
        Repeat 
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
          If ok
            pWorld(x,y) = 0
            pWorld(pX,pY) = #foe
          Else
            pX = x
            pY = y
          EndIf
          ok = 0
        Until Not ok
      EndIf
    Next
  Next
EndProcedure

Procedure playerMove(param)
  ; если соседний объект не проходим или соседний объект край уровня - ничего не делать
  ; если двинулся игрок - двигаются враги. если игрок не двигался - враги тоже не двигаются
  Protected arg, sub, pX, pY, ok, player
  player = 1
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
    count + 1
  EndIf
  ok = 0
  DrawAllObj()
EndProcedure

OpenWindow(#wnd,#PB_Any,#PB_Any,www,hhh+20,#myName,#PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_ScreenCentered)
CanvasGadget(#canva,0,0,www,hhh)
TextGadget(#status,0,hhh,www,20,"",#PB_Text_Center)

AddKeyboardShortcut(#wnd,#PB_Shortcut_W,#up)
AddKeyboardShortcut(#wnd,#PB_Shortcut_S,#down)
AddKeyboardShortcut(#wnd,#PB_Shortcut_A,#left)
AddKeyboardShortcut(#wnd,#PB_Shortcut_D,#right)
AddKeyboardShortcut(#wnd,#PB_Shortcut_F5,#restart)

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
      Case #restart
        restart()
    EndSelect
  EndIf
Until event = #PB_Event_CloseWindow