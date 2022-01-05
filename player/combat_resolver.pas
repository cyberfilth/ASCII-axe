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
  SysUtils, globalUtils, ui;

(* Attack NPC's *)
procedure combat(npcID: smallint);
(* Spite damage - damage dealt by the loser of a combat round 'in spite' of losing *)
procedure spiteDMG(npc: smallint);

implementation

uses
  entities;

procedure combat(npcID: smallint);
var
  damageAmount: smallint;
begin
  (* Attacking an NPC automatically makes it hostile *)
  entities.entityList[npcID].state := stateHostile;
  (* Number of turns NPC will follow you if out of sight *)
  entities.entityList[npcID].moveCount := 10;

  damageAmount :=
    (globalutils.randomRange(1, entityList[0].attack) + { Base attack }
    globalutils.rollDice(entityList[0].weaponDice) +    { Weapon dice }
    entityList[0].weaponAdds) -                         { Weapon adds }
    entities.entityList[npcID].defence;

  if ((damageAmount - entities.entityList[0].tmrDrunk) > 0) then
  begin
    entities.entityList[npcID].currentHP := (entities.entityList[npcID].currentHP - damageAmount);
    (* If it was a killing blow *)
    if (entities.entityList[npcID].currentHP < 1) then
    begin
      (* If the target was a barrel that was broken open *)
      if (entities.entityList[npcID].race = 'barrel') then
        ui.bufferMessage('You break open the barrel')
      else
        (* If the target was an NPC *)
        ui.displayMessage('You manage to kill the ' + entities.entityList[npcID].race);
      entities.killEntity(npcID);
      entities.entityList[0].xpReward := entities.entityList[0].xpReward + entities.entityList[npcID].xpReward;
      ui.updateXP;
      exit;
    end
    else
    if (damageAmount = 1) then
      ui.displayMessage('Parrying, you slightly injure the ' + entities.entityList[npcID].race)
    else
      ui.displayMessage('You hit the ' + entities.entityList[npcID].race + ' for ' + IntToStr(damageAmount) + ' points of damage');
  end;
end;

procedure spiteDMG(npc: smallint);
var
  spiteDamage, i: smallint;
begin
  spiteDamage := 0;
  (* If player is armed *)
  if (entityList[0].weaponEquipped = True) then
  begin
    for i := 1 to entityList[0].weaponDice do
    begin
      if (globalutils.randomRange(1, 6) = 6) then
        Inc(spiteDamage);
    end;
  end
  else
  (* If the player is unarmed *)
  if (globalutils.randomRange(1, 6) = 6) then
    Inc(spiteDamage);
  if (spiteDamage > 0) then
    (* The player got in a lucky shot whilst defending themselves *)
  begin
    entities.entityList[npc].currentHP := (entities.entityList[npc].currentHP - spiteDamage);
    (* If it was a killing blow *)
    if (entities.entityList[npc].currentHP < 1) then
    begin
      ui.displayMessage('You kill the ' + entities.entityList[npc].race);
      entities.killEntity(npc);
      entities.entityList[0].xpReward := entities.entityList[0].xpReward + entities.entityList[npc].xpReward;
      ui.updateXP;
      exit;
    end
    else
    if (spiteDamage = 1) then
      ui.displayMessage('You slightly injure the ' + entities.entityList[npc].race)
    else
      ui.displayMessage('You hit the ' + entities.entityList[npc].race + ' for ' + IntToStr(spiteDamage) + ' points of damage');
  end;
end;

end.
