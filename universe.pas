(* Store each dungeon, its levels and related info *)

Unit universe;

{$mode objfpc}{$H+}
{$modeswitch UnicodeStrings}

Interface

Uses 
SysUtils, DOM, XMLWrite, XMLRead, globalutils, cave, logging;

Type 
  dungeonTerrain = (tCave, tDungeon);

Var 
  (* Number of dungeons *)
  dlistLength, uniqueID: smallint;
  (* Info about current dungeon *)
  totalRooms, currentDepth, totalDepth: byte;
  dungeonType: dungeonTerrain;
  (* Name of the current dungeon *)
  title: string;
  (* Is it possible to leave the current dungeon *)
  canExitDungeon: boolean;
  (* Used when a dungeon is first generated *)
  currentDungeon: array[1..MAXROWS, 1..MAXCOLUMNS] Of shortstring;

(* Creates a dungeon of a specified type *)
Procedure createNewDungeon(levelType: dungeonTerrain);
(* Spawn creatures based on dungeon type and player level *)
Procedure spawnDenizens;
(* Write a newly generate level of a dungeon to disk *)
Procedure writeNewDungeonLevel(idNumber, lvlNum, totalDepth, totalRooms: byte;
                               dtype: dungeonTerrain);
(* Write explored dungeon level to disk *)
Procedure saveDungeonLevel;
(* Read dungeon level from disk *)
Procedure loadDungeonLevel(lvl: byte);

Implementation

Uses 
map, npc_lookup, entities;

Procedure createNewDungeon(levelType: dungeonTerrain);
Begin
  r := 1;
  c := 1;
  (* Increment the number of dungeons *)
  Inc(dlistLength);
  (* First dungeon is locked when you enter *)
  If (dlistLength = 1) Then
    canExitDungeon := False;
  (* Dungeons unique ID number becomes the highest dungeon amount number *)
  uniqueID := dlistLength;
  // hardcoded values for testing
  title := 'First cave';
  dungeonType := levelType;
  totalDepth := 3;
  currentDepth := 1;

  (* generate the dungeon *)
  Case levelType Of 
    tCave: cave.generate(dlistLength, totalDepth);
    tDungeon: ;
    //bitmask_dungeon.generate;
  End;

  (* Copy the 1st floor of the current dungeon to the game map *)
  map.setupMap;
End;

Procedure spawnDenizens;

Var 
  { Number of NPC's to create }
  NPCnumber, i: byte;
Begin
  { Based on number of rooms in current level, dungeon type & dungeon level }
  NPCnumber := totalRooms;  { player level is considered when generating the NPCs }
  entities.npcAmount := NPCnumber;
  Case dungeonType Of 
    tDungeon: ;
    tCave: { Cave }
           Begin
      (* Number of NPC's = total number of rooms + floor level *)
             NPCnumber := (totalRooms + currentDepth);
      (* Create the NPC's *);
             For i := 1 To NPCnumber Do
               Begin
        { create an encounter table: Monster type: Dungeon type: floor number }
        { NPC generation will take the Player level into account when creating stats }
                 npc_lookup.NPCpicker(i, tCave);
               End;
           End;
  End;
End;

Procedure writeNewDungeonLevel(idNumber, lvlNum, totalDepth, totalRooms: byte;
                               dtype: dungeonTerrain);

Var 
  r, c, id_int: smallint;
  Doc: TXMLDocument;
  RootNode, dataNode: TDOMNode;
  dfileName, Value: string;

Procedure AddElement(Node: TDOMNode; Name, Value: String);

Var 
  NameNode, ValueNode: TDomNode;
Begin
    { creates future Node/Name }
  NameNode := Doc.CreateElement(Name);
    { creates future Node/Name/Value }
  ValueNode := Doc.CreateTextNode(Value);
    { place value in place }
  NameNode.Appendchild(ValueNode);
    { place Name in place }
  Node.Appendchild(NameNode);
End;

Function AddChild(Node: TDOMNode; ChildName: String): TDomNode;

Var 
  ChildNode: TDomNode;
Begin
  ChildNode := Doc.CreateElement(ChildName);
  Node.AppendChild(ChildNode);
  Result := ChildNode;
End;

Begin
  id_int := 0;
  dfileName := globalUtils.saveDirectory + PathDelim + 'd_' +
               IntToStr(idNumber) + '_f' + IntToStr(lvlNum) + '.dat';
  Try
    { Create a document }
    Doc := TXMLDocument.Create;
    { Create a root node }
    RootNode := Doc.CreateElement('root');
    Doc.Appendchild(RootNode);
    RootNode := Doc.DocumentElement;

    (* Level data *)
    DataNode := AddChild(RootNode, 'levelData');
    AddElement(datanode, 'dungeonID', IntToStr(idNumber));
    AddElement(datanode, 'title', title);
    AddElement(datanode, 'floor', IntToStr(lvlNum));
    AddElement(datanode, 'totalDepth', IntToStr(totalDepth));
    WriteStr(Value, dungeonType);
    AddElement(datanode, 'mapType', Value);
    AddElement(datanode, 'totalRooms', IntToStr(totalRooms));

    (* map tiles *)
    For r := 1 To MAXROWS Do
      Begin
        For c := 1 To MAXCOLUMNS Do
          Begin
            Inc(id_int);
            DataNode := AddChild(RootNode, 'map_tiles');
            TDOMElement(dataNode).SetAttribute('id', IntToStr(id_int));
        { if dungeon type is a cave }
            If (dType = tCave) Then
              Begin
                If (cave.terrainArray[r][c] = '*') Then
                  AddElement(datanode, 'Blocks', BoolToStr(True))
                Else
                  AddElement(datanode, 'Blocks', BoolToStr(False));
              End;
            AddElement(datanode, 'Visible', BoolToStr(False));
            AddElement(datanode, 'Occupied', BoolToStr(False));
            AddElement(datanode, 'Discovered', BoolToStr(False));
        { if dungeon type is a cave }
            If (dType = tCave) Then
              Begin
                AddElement(datanode, 'Glyph', cave.terrainArray[r][c]);
              End;
          End;
      End;
    (* Save XML *)
    WriteXMLFile(Doc, dfileName);
  Finally
    { free memory }
    Doc.Free;
End;
End;

Procedure saveDungeonLevel;

Var 
  r, c, id_int: smallint;
  Doc: TXMLDocument;
  RootNode, dataNode: TDOMNode;
  dfileName, Value: string;

Procedure AddElement(Node: TDOMNode; Name, Value: String);

Var 
  NameNode, ValueNode: TDomNode;
Begin
    { creates future Node/Name }
  NameNode := Doc.CreateElement(Name);
    { creates future Node/Name/Value }
  ValueNode := Doc.CreateTextNode(Value);
    { place value in place }
  NameNode.Appendchild(ValueNode);
    { place Name in place }
  Node.Appendchild(NameNode);
End;

Function AddChild(Node: TDOMNode; ChildName: String): TDomNode;

Var 
  ChildNode: TDomNode;
Begin
  ChildNode := Doc.CreateElement(ChildName);
  Node.AppendChild(ChildNode);
  Result := ChildNode;
End;

Begin
  id_int := 0;
  dfileName := (globalUtils.saveDirectory + PathDelim + 'd_' +
               IntToStr(uniqueID) + '_f' + IntToStr(currentDepth) + '.dat');
  Try
    { Create a document }
    Doc := TXMLDocument.Create;
    { Create a root node }
    RootNode := Doc.CreateElement('root');
    Doc.Appendchild(RootNode);
    RootNode := Doc.DocumentElement;

    (* Level data *)
    DataNode := AddChild(RootNode, 'levelData');
    AddElement(datanode, 'dungeonID', IntToStr(uniqueID));
    AddElement(datanode, 'title', title);
    AddElement(datanode, 'floor', IntToStr(currentDepth));
    AddElement(datanode, 'totalDepth', IntToStr(totalDepth));
    WriteStr(Value, dungeonType);
    AddElement(datanode, 'mapType', Value);
    AddElement(datanode, 'totalRooms', IntToStr(totalRooms));

    (* map tiles *)
    For r := 1 To MAXROWS Do
      Begin
        For c := 1 To MAXCOLUMNS Do
          Begin
            Inc(id_int);
            DataNode := AddChild(RootNode, 'map_tiles');
            TDOMElement(dataNode).SetAttribute('id', IntToStr(maparea[r][c].id));
            AddElement(datanode, 'Blocks', BoolToStr(map.maparea[r][c].Blocks));
            AddElement(datanode, 'Visible', BoolToStr(map.maparea[r][c].Visible));
            AddElement(datanode, 'Occupied', BoolToStr(map.maparea[r][c].Occupied));
            AddElement(datanode, 'Discovered', BoolToStr(map.maparea[r][c].Discovered));
            AddElement(datanode, 'Glyph', map.maparea[r][c].Glyph);
          End;
      End;
    (* Save XML *)
    WriteXMLFile(Doc, dfileName);
  Finally
    { free memory }
    Doc.Free;
End;
End;

Procedure loadDungeonLevel(lvl: byte);

Var 
  dfileName: string;
  RootNode, Tile, NextNode, Blocks, Visible, Occupied, Discovered, GlyphNode: TDOMNode;
  Doc: TXMLDocument;
  r, c: integer;
Begin
  dfileName := globalUtils.saveDirectory + PathDelim + 'd_' +
               IntToStr(uniqueID) + '_f' + IntToStr(lvl) + '.dat';
  Try
    (* Read in dat file from disk *)
    ReadXMLFile(Doc, dfileName);
    (* Retrieve the nodes *)
    RootNode := Doc.DocumentElement.FindNode('levelData');
    (* Number of rooms in current level *)
    totalRooms := StrToInt(RootNode.FindNode('totalRooms').TextContent);

    (* Map tile data *)
    Tile := RootNode.NextSibling;
    For r := 1 To MAXROWS Do
      Begin
        For c := 1 To MAXCOLUMNS Do
          Begin
            map.maparea[r][c].id := StrToInt(Tile.Attributes.Item[0].NodeValue);
            Blocks := Tile.FirstChild;
            map.maparea[r][c].Blocks := StrToBool(Blocks.TextContent);
            Visible := Blocks.NextSibling;
            map.maparea[r][c].Visible := StrToBool(Visible.TextContent);
            Occupied := Visible.NextSibling;
            map.maparea[r][c].Occupied := StrToBool(Occupied.TextContent);
            Discovered := Occupied.NextSibling;
            map.maparea[r][c].Discovered := StrToBool(Discovered.TextContent);
            GlyphNode := Discovered.NextSibling;
        (* Convert String to Char *)
            map.maparea[r][c].Glyph := GlyphNode.TextContent[1];
            NextNode := Tile.NextSibling;
            Tile := NextNode;
          End;
      End;
  Finally
    (* free memory *)
    Doc.Free;
    currentDepth := lvl;
End;
End;

End.
