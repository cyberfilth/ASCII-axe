(* Magic and Spell effects are calculated here *)

unit magicEffects;

{$mode fpc}{$H+}

interface

uses
  SysUtils, los, entities, ui, player_stats;

(* Burn enemies in a cirle area from starting centre coordinates *)
procedure minorScorch;

implementation

procedure minorScorch;
var
  i, damageAmount: smallint;
  anyTargetHit, plural: boolean;
  listOfDead: shortstring;
begin
  i := 0;
  anyTargetHit := False;
  plural := False;
  listOfDead := '';
  (* Damage amount is 4 + player level *)
  damageAmount := 4 + player_stats.playerLevel;
  (* Check if any enemies are near *)
  for i := 1 to entities.npcAmount do
  begin
    (* First check an NPC is visible (and not dead) *)
    if (entityList[i].inView = True) and (entityList[i].isDead = False) then
    begin
      (* Area of effect is Players vision range - 1 *)
      if (los.inView(entityList[0].posX, entityList[0].posY, entityList[i].posX, entityList[i].posY, entityList[0].visionRange - 1) = True) then
      begin
        anyTargetHit := True;
        (* Deal damage *)
        entityList[i].currentHP := (entityList[i].currentHP - damageAmount);
        (* Check if NPC killed *)
        if (entityList[i].currentHP < 1) then
        begin
          entities.killEntity(i);
          entityList[0].xpReward := entityList[0].xpReward + entityList[i].xpReward;
          ui.updateXP;
          (* Create log message *)
          if (listOfDead = '') then
            listOfDead := entityList[i].race
          else
          begin
            plural := True;
            listOfDead := listOfDead + ', ' + entityList[i].race;
          end;
        end;
      end;
    end;
  end;
  (* Display if there were any hits or not *)
  if (anyTargetHit = False) then
    ui.displayMessage('Flames shoot out, but hit nothing')
  else
  begin
    if (plural = False) then
      ui.displayMessage('The ' + listOfDead + ' burns.')
    else
      ui.displayMessage('The ' + listOfDead + ' all burn.');
  end;
end;

end.
