(* Intelligent enemy with scent tracking *)

Unit redcap_lesser;

{$mode objfpc}{$H+}

Interface

Uses
SysUtils, Math;

(* Create a Redcap Hob *)
Procedure createRedcap(uniqueid, npcx, npcy: smallint);
(* Take a turn *)
Procedure takeTurn(id: smallint);
(* Decision tree for Neutral state *)
Procedure decisionNeutral(id: smallint);
(* Decision tree for Hostile state *)
Procedure decisionHostile(id: smallint);
(* Decision tree for Escape state *)
Procedure decisionEscape(id: smallint);
(* Move in a random direction *)
Procedure wander(id, spx, spy: smallint);
(* Chase enemy *)
Procedure chaseTarget(id, spx, spy: smallint);
(* Check if player is next to NPC *)
Function isNextToPlayer(spx, spy: smallint): boolean;
(* Run from player *)
Procedure escapePlayer(id, spx, spy: smallint);
(* Combat *)
Procedure combat(id: smallint);

Implementation

Uses
entities, globalutils, ui, los, map;

Procedure createRedcap(uniqueid, npcx, npcy: smallint);

Var
  mood: byte;
Begin
  (* Determine hostility *)
  mood := randomRange(1, 2);
  (* Add a redcap to the list of creatures *)
  entities.listLength := length(entities.entityList);
  SetLength(entities.entityList, entities.listLength + 1);
  With entities.entityList[entities.listLength] Do
    Begin
      npcID := uniqueid;
      race := 'Hob';
      description := 'a short Hob wearing a red cap';
      glyph := 'h';
      glyphColour := 'red';
      maxHP := randomRange(3, 5);
      currentHP := maxHP;
      attack := randomRange(entityList[0].attack - 1, entityList[0].attack + 1);
      defence := randomRange(entityList[0].defence - 1, entityList[0].defence + 1);
      weaponDice := 0;
      weaponAdds := 0;
      xpReward := maxHP;
      visionRange := 4;
      moveCount := 0;
      targetX := 0;
      targetY := 0;
      inView := False;
      blocks := False;
      faction:=redcapFaction;
      If (mood = 1) Then
        state := stateHostile
      Else
        state := stateNeutral;
      discovered := False;
      weaponEquipped := False;
      armourEquipped := False;
      isDead := False;
      stsDrunk := False;
      stsPoison := False;
      tmrDrunk := 0;
      tmrPoison := 0;
      posX := npcx;
      posY := npcy;
    End;
  (* Occupy tile *)
  map.occupy(npcx, npcy);
End;

Procedure takeTurn(id: smallint);
Begin
  Case entityList[id].state Of
    stateNeutral: decisionNeutral(id);
    stateHostile: decisionHostile(id);
    stateEscape: decisionEscape(id);
    Else
      decisionNeutral(id);
  End;
End;

Procedure decisionNeutral(id: smallint);

Var
  stopAndSmellFlowers: byte;
Begin
  stopAndSmellFlowers := globalutils.randomRange(1, 2);
  If (stopAndSmellFlowers = 1) Then
    { Either wander randomly }
    wander(id, entityList[id].posX, entityList[id].posY)
  Else
    { or stay in place }
    entities.moveNPC(id, entityList[id].posX, entityList[id].posY);
End;

Procedure decisionHostile(id: smallint);
Begin
  { If health is below 25%, escape }
  If (entityList[id].currentHP < (entityList[id].maxHP Div 2)) Then
    Begin
      entityList[id].state := stateEscape;
      escapePlayer(id, entityList[id].posX, entityList[id].posY);
    End

  { If NPC can see the player }
  Else If (los.inView(entityList[id].posX, entityList[id].posY,
          entityList[0].posX, entityList[0].posY, entityList[id].visionRange) = True) Then
         Begin
    { If next to the player }
           If (isNextToPlayer(entityList[id].posX, entityList[id].posY) = True) Then
      { Attack the Player }
             combat(id)
           Else
      { Chase the player }
             chaseTarget(id, entityList[id].posX, entityList[id].posY);
         End

  { If not injured and player not in sight }
  Else
    wander(id, entityList[id].posX, entityList[id].posY);
End;

Procedure decisionEscape(id: smallint);
Begin
  { Check if player is in sight }
  If (los.inView(entityList[id].posX, entityList[id].posY, entityList[0].posX,
     entityList[0].posY, entityList[id].visionRange) = True) Then
    { If the player is in sight, run away }
    escapePlayer(id, entityList[id].posX, entityList[id].posY)

  { If the player is not in sight }
  Else
    Begin
    { Heal if health is below 50% }
      If (entityList[id].currentHP < (entityList[id].maxHP Div 2)) Then
        Inc(entityList[id].currentHP, 3)
      Else
      { Reset state to Neutral and wander }
        wander(id, entityList[id].posX, entityList[id].posY);
    End;
End;

Procedure wander(id, spx, spy: smallint);

Var
  direction, attempts, testx, testy: smallint;
Begin
  { Set NPC state }
  entityList[id].state := stateNeutral;
  attempts := 0;
  testx := 0;
  testy := 0;
  direction := 0;
  Repeat
    (* Reset values after each failed loop so they don't keep dec/incrementing *)
    testx := spx;
    testy := spy;
    direction := random(6);
    (* limit the number of attempts to move so the game doesn't hang if NPC is stuck *)
    Inc(attempts);
    If attempts > 10 Then
      Begin
        entities.moveNPC(id, spx, spy);
        exit;
      End;
    Case direction Of
      0: Dec(testy);
      1: Inc(testy);
      2: Dec(testx);
      3: Inc(testx);
      4: testx := spx;
      5: testy := spy;
    End
  Until (map.canMove(testx, testy) = True) And (map.isOccupied(testx, testy) = False);
  entities.moveNPC(id, testx, testy);
End;

Procedure chaseTarget(id, spx, spy: smallint);

Var
  newX, newY, dx, dy: smallint;
  distance: double;
Begin
  newX := 0;
  newY := 0;
  (* Get new coordinates to chase the player *)
  dx := entityList[0].posX - spx;
  dy := entityList[0].posY - spy;
  If (dx = 0) And (dy = 0) Then
    Begin
      newX := spx;
      newy := spy;
    End
  Else
    Begin
      distance := sqrt(dx ** 2 + dy ** 2);
      dx := round(dx / distance);
      dy := round(dy / distance);
      newX := spx + dx;
      newY := spy + dy;
    End;
  (* New coordinates set. Check if they are walkable *)
  If (map.canMove(newX, newY) = True) Then
    Begin
    (* Do they contain the player *)
      If (map.hasPlayer(newX, newY) = True) Then
        Begin
      (* Remain on original tile and attack *)
          entities.moveNPC(id, spx, spy);
          combat(id);
        End
    (* Else if tile does not contain player, check for another entity *)
      Else If (map.isOccupied(newX, newY) = True) Then
             Begin
               ui.bufferMessage('The giant rat bumps into ' + getCreatureName(newX, newY));
               entities.moveNPC(id, spx, spy);
             End
    (* if map is unoccupied, move to that tile *)
      Else If (map.isOccupied(newX, newY) = False) Then
             entities.moveNPC(id, newX, newY);
    End
  Else
    wander(id, spx, spy);
End;

Function isNextToPlayer(spx, spy: smallint): boolean;

Var
  dx, dy: smallint;
  distance: double;
  // try single
Begin
  Result := False;
  dx := entityList[0].posX - spx;
  dy := entityList[0].posY - spy;
  distance := sqrt(dx ** 2 + dy ** 2);
  If (round(distance) = 0) Then
    Result := True;
End;

Procedure escapePlayer(id, spx, spy: smallint);

Var
  newX, newY, dx, dy: smallint;
  distance: single;
Begin
  newX := 0;
  newY := 0;
  (* Get new coordinates to escape the player *)
  dx := entityList[0].posX - spx;
  dy := entityList[0].posY - spy;
  If (dx = 0) And (dy = 0) Then
    Begin
      newX := spx;
      newy := spy;
    End
  Else
    Begin
      distance := sqrt(dx ** 2 + dy ** 2);
      dx := round(dx / distance);
      dy := round(dy / distance);
      If (dx > 0) Then
        dx := -1;
      If (dx < 0) Then
        dx := 1;
      dy := round(dy / distance);
      If (dy > 0) Then
        dy := -1;
      If (dy < 0) Then
        dy := 1;
      newX := spx + dx;
      newY := spy + dy;
    End;
  If (map.canMove(newX, newY) = True) Then
    Begin
      If (map.hasPlayer(newX, newY) = True) Then
        Begin
          entities.moveNPC(id, spx, spy);
          combat(id);
        End
      Else If (map.isOccupied(newX, newY) = False) Then
             entities.moveNPC(id, newX, newY);
    End
  Else
    wander(id, spx, spy);
End;

Procedure combat(id: smallint);

Var
  damageAmount: smallint;
Begin
  damageAmount := globalutils.randomRange(1, entities.entityList[id].attack) -
                  entities.entityList[0].defence;
  If (damageAmount > 0) Then
    Begin
      entities.entityList[0].currentHP :=
                                          (entities.entityList[0].currentHP - damageAmount);
      If (entities.entityList[0].currentHP < 1) Then
        Begin
          killer := entityList[id].race;
          exit;
        End
      Else
        Begin
          If (damageAmount = 1) Then
            ui.displayMessage('The hob slightly wounds you')
          Else
            ui.displayMessage('The hob claws you, dealing ' +
                              IntToStr(damageAmount) + ' damage');
      (* Update health display to show damage *)
          ui.updateHealth;
        End;
    End
  Else
    ui.displayMessage('The hob misses');
End;

End.
