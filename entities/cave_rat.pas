(* Weak enemy with simple AI, no pathfinding *)

unit cave_rat;

{$mode fpc}{$H+}

interface

uses
  SysUtils, Math, map;

(* Create a cave rat *)
procedure createCaveRat(uniqueid, npcx, npcy: smallint);

implementation

procedure createCaveRat(uniqueid, npcx, npcy: smallint);
begin
   // Add a cave rat to the list of creatures
  entities.listLength := length(entities.entityList);
  SetLength(entities.entityList, entities.listLength + 1);
  with entities.entityList[entities.listLength] do
  begin
    npcID := uniqueid;
    race := 'cave rat';
    description := 'a large rat';
    glyph := 'r';
    glyphColour := 'brown';
    maxHP := randomRange(4, 6);
    currentHP := maxHP;
    attack := randomRange(entityList[0].attack - 2, entityList[0].attack + 3);
    defense := randomRange(entityList[0].defense - 2, entityList[0].defense + 2);
    weaponDice := 0;
    weaponAdds := 0;
    xpReward := maxHP;
    visionRange := 4;
    NPCsize := 1;
    trackingTurns := 0;
    moveCount := 0;
    targetX := 0;
    targetY := 0;
    inView := False;
    blocks := False;
    discovered := False;
    weaponEquipped := False;
    armourEquipped := False;
    isDead := False;
    abilityTriggered := False;
    stsDrunk := False;
    stsPoison := False;
    tmrDrunk := 0;
    tmrPoison := 0;
    posX := npcx;
    posY := npcy;
  end;
  (* Occupy tile *)
  map.occupy(npcx, npcy);
end;

end.

