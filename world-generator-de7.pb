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
      curnoise = noise(x, y)
;       Debug "x="+x+",y="+y+",curnoise="+curnoise
      ; If noise value is high enough
      If (curnoise > 0.5)
;         Debug "we are here curnoise > 0.5"
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
;         Debug "we are here curnoise NOT > 0.5"
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
              pWorld(x,y) = 0
          EndSelect
        ;pWorld(x,y) = none;
      EndIf
    Next
  Next
EndProcedure