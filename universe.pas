(* Store each dungeon, its levels and related info *)

unit universe;

{$mode objfpc}{$H+}
{$modeswitch UnicodeStrings}

interface

uses
  SysUtils, DOM, XMLWrite, XMLRead, globalutils, cave, map, logging;

var
  (* Number of dungeons *)
  dlistLength, uniqueID: smallint;
  (* Info about current dungeon *)
  totalRooms, currentDepth, totalDepth, dungeonType: byte;
  (* Name of the current dungeon *)
  title: string;
  (* Is it possible to leave the current dungeon *)
  canExitDungeon: boolean;
  (* Used when a dungeon is first generated *)
  currentDungeon: array[1..MAXROWS, 1..MAXCOLUMNS] of shortstring;

(* Creates a dungeon of a specified type *)
procedure createNewDungeon(levelType: byte);
(* Write a newly generate level of a dungeon to disk *)
procedure writeNewDungeonLevel(idNumber, dType, lvlNum, totalDepth, totalRooms: byte);
(* Write explored dungeon level to disk *)
procedure saveDungeonLevel;
(* Read dungeon level from disk *)
procedure loadDungeonLevel;

implementation

procedure createNewDungeon(levelType: byte);
begin
  r := 1;
  c := 1;
  (* Increment the number of dungeons *)
  Inc(dlistLength);
  (* First dungeon is locked when you enter *)
  if (dlistLength = 1) then
    canExitDungeon := False;
  (* Dungeons unique ID number becomes the highest dungeon amount number *)
  uniqueID := dlistLength;
  // hardcoded values for testing
  title := 'First cave';
  dungeonType := levelType;
  totalDepth := 3;
  currentDepth := 1;

  (* generate the dungeon *)
  case levelType of
    0: ; { reserved for random type 1 }
    1: ; { reserved for random type 2 }
    { cave }
    2: cave.generate(dlistLength, totalDepth);
    3: ;//bitmask_dungeon.generate;
  end;

  (* Copy the 1st floor of the current dungeon to the game map *)
  map.setupMap;
end;

procedure writeNewDungeonLevel(idNumber, dType, lvlNum, totalDepth, totalRooms: byte);
var
  r, c, id_int: smallint;
  Doc: TXMLDocument;
  RootNode, dataNode: TDOMNode;
  dfileName: string;

  procedure AddElement(Node: TDOMNode; Name, Value: string);
  var
    NameNode, ValueNode: TDomNode;
  begin
    { creates future Node/Name }
    NameNode := Doc.CreateElement(Name);
    { creates future Node/Name/Value }
    ValueNode := Doc.CreateTextNode(Value);
    { place value in place }
    NameNode.Appendchild(ValueNode);
    { place Name in place }
    Node.Appendchild(NameNode);
  end;

  function AddChild(Node: TDOMNode; ChildName: string): TDomNode;
  var
    ChildNode: TDomNode;
  begin
    ChildNode := Doc.CreateElement(ChildName);
    Node.AppendChild(ChildNode);
    Result := ChildNode;
  end;

begin
  id_int := 0;
  dfileName := globalUtils.saveDirectory + PathDelim + 'd_' +
    IntToStr(idNumber) + '_f' + IntToStr(lvlNum) + '.dat';
  try
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
    AddElement(datanode, 'mapType', IntToStr(dType));
    AddElement(datanode, 'totalRooms', IntToStr(totalRooms));

    (* map tiles *)
    for r := 1 to MAXROWS do
    begin
      for c := 1 to MAXCOLUMNS do
      begin
        Inc(id_int);
        DataNode := AddChild(RootNode, 'map_tiles');
        TDOMElement(dataNode).SetAttribute('id', IntToStr(id_int));
        { if dungeon type is a cave }
        if (dType = 2) then
        begin
          if (cave.terrainArray[r][c] = '*') then
            AddElement(datanode, 'Blocks', BoolToStr(True))
          else
            AddElement(datanode, 'Blocks', BoolToStr(False));
        end;
        AddElement(datanode, 'Visible', BoolToStr(False));
        AddElement(datanode, 'Occupied', BoolToStr(False));
        AddElement(datanode, 'Discovered', BoolToStr(False));
        { if dungeon type is a cave }
        if (dType = 2) then
        begin
          AddElement(datanode, 'Glyph', cave.terrainArray[r][c]);
        end;
      end;
    end;
    (* Save XML *)
    WriteXMLFile(Doc, dfileName);
  finally
    { free memory }
    Doc.Free;
  end;
end;

procedure saveDungeonLevel;
var
  r, c, id_int: smallint;
  Doc: TXMLDocument;
  RootNode, dataNode: TDOMNode;
  dfileName: string;

  procedure AddElement(Node: TDOMNode; Name, Value: string);
  var
    NameNode, ValueNode: TDomNode;
  begin
    { creates future Node/Name }
    NameNode := Doc.CreateElement(Name);
    { creates future Node/Name/Value }
    ValueNode := Doc.CreateTextNode(Value);
    { place value in place }
    NameNode.Appendchild(ValueNode);
    { place Name in place }
    Node.Appendchild(NameNode);
  end;

  function AddChild(Node: TDOMNode; ChildName: string): TDomNode;
  var
    ChildNode: TDomNode;
  begin
    ChildNode := Doc.CreateElement(ChildName);
    Node.AppendChild(ChildNode);
    Result := ChildNode;
  end;

begin

  logAction('>universe.saveDungeonLevel');

  id_int := 0;
  dfileName := (globalUtils.saveDirectory + PathDelim + 'd_' +
    IntToStr(uniqueID) + '_f' + IntToStr(currentDepth) + '.dat');
  try
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
    AddElement(datanode, 'mapType', IntToStr(dungeonType));
    AddElement(datanode, 'totalRooms', IntToStr(totalRooms));

    (* map tiles *)
    for r := 1 to MAXROWS do
    begin
      for c := 1 to MAXCOLUMNS do
      begin
        Inc(id_int);
        DataNode := AddChild(RootNode, 'map_tiles');
        TDOMElement(dataNode).SetAttribute('id', IntToStr(maparea[r][c].id));
        AddElement(datanode, 'Blocks', BoolToStr(map.maparea[r][c].Blocks));
        AddElement(datanode, 'Visible', BoolToStr(map.maparea[r][c].Visible));
        AddElement(datanode, 'Occupied', BoolToStr(map.maparea[r][c].Occupied));
        AddElement(datanode, 'Discovered', BoolToStr(map.maparea[r][c].Discovered));
        AddElement(datanode, 'Glyph', map.maparea[r][c].Glyph);
      end;
    end;
    (* Save XML *)
    WriteXMLFile(Doc, dfileName);
  finally
    { free memory }
    Doc.Free;
  end;
end;

procedure loadDungeonLevel;
var
  dfileName: string;
  RootNode, ParentNode, Tile, NextNode, Blocks, Visible, Occupied,
  Discovered, GlyphNode: TDOMNode;
  Doc: TXMLDocument;
  r, c, i: integer;
begin
  logAction('>universe.loadDungeonLevel');
  dfileName := globalUtils.saveDirectory + PathDelim + 'd_' +
    IntToStr(uniqueID) + '_f' + IntToStr(currentDepth + 1) + '.dat';
  try
    logAction('- Opening ' + dfileName);
    (* Read in dat file from disk *)
    ReadXMLFile(Doc, dfileName);

    logAction('- Read XML file');
    (* Retrieve the nodes *)
    RootNode := Doc.DocumentElement.FindNode('levelData');
    logAction('- Found levelData node');
    ParentNode := RootNode.FirstChild.NextSibling;

    logAction('- Retrieving first child of levelData');

    (* Number of rooms in current level *)
    totalRooms := StrToInt(RootNode.FindNode('totalRooms').TextContent);

    logAction('- totalRooms: ' + IntToStr(totalRooms));

    (* Map tile data *)
    Tile := RootNode.NextSibling;
    for r := 1 to MAXROWS do
    begin
      for c := 1 to MAXCOLUMNS do
      begin
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
      end;
    end;
  finally
    (* free memory *)
    Doc.Free;
    Inc(currentDepth);
  end;
  logAction(' Exiting universe.loadDungeonLevel');
end;

end.
