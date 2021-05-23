(*
  Combat Resolver unit

  Combat is decided by rolling a random number between 1 and the entity's ATTACK value.
  Then modifiers are added, for example, a 1D6+4 axe will roll a 6 sided die and
  add the result plus 4 to the total damage amount. This is then removed from the
  opponents defence rating. If the opponents defence doesn't soak up the whole damage
  amount, the remainder is taken from their Health. This is partly inspired by the
  Tunnels & Trolls rules, my favourite tabletop RPG.
*)

unit combat_resolver;

{$mode fpc}{$H+}

interface

uses
  SysUtils, entities, globalUtils, ui;

(* Attack NPC's *)
procedure combat(npcID: smallint);

implementation

procedure combat(npcID: smallint);
var
  damageAmount: smallint;
begin
  (* Attacking an NPC automatically makes it hostile *)
  entities.entityList[npcID].state := stateHostile;

  damageAmount :=
    (globalutils.randomRange(1, entityList[0].attack) + { Base attack }
    globalutils.rollDice(entityList[0].weaponDice) +    { Weapon dice }
    entityList[0].weaponAdds) -                         { Weapon adds }
    entities.entityList[npcID].defence;

  if ((damageAmount - entities.entityList[0].tmrDrunk) > 0) then
  begin
    entities.entityList[npcID].currentHP :=
      (entities.entityList[npcID].currentHP - damageAmount);
    if (entities.entityList[npcID].currentHP < 1) then
    begin
      if (entities.entityList[npcID].race = 'barrel') then
        ui.bufferMessage('You break open the barrel')
      else
        ui.displayMessage('You kill the ' + entities.entityList[npcID].race);
      entities.killEntity(npcID);
      entities.entityList[0].xpReward :=
        entities.entityList[0].xpReward + entities.entityList[npcID].xpReward;
      ui.updateXP;
      exit;
    end
    else
    if (damageAmount = 1) then
      ui.displayMessage('You slightly injure the ' + entities.entityList[npcID].race)
    else
      ui.displayMessage('You hit the ' + entities.entityList[npcID].race +
        ' for ' + IntToStr(damageAmount) + ' points of damage');
  end
  else
  begin
    if (entities.entityList[0].stsDrunk = True) then
      ui.displayMessage('You drunkenly miss')
    else
      ui.displayMessage('You miss');
  end;
end;

end.

