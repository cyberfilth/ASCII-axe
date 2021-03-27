(* Generate names and plot elements *)

unit plot_gen;

{$mode objfpc}{$H+}{$R+}

interface

uses
  Dos, SysUtils;

const
  DayStr: array[0..6] of string =
    ('Fastday', 'Onesday', 'Twosday', 'Frogday', 'Hawksday', 'Feastday', 'Marketday');
  MonthStr: array[1..12] of string =
    ('Mistmon', 'Brittleice', 'Windmon', 'Gunther', 'Sweetbriar', 'Greenling',
    'Frogsong', 'Sunmon', 'Southflight',
    'Harvestmoon', 'Ghostmoon', 'Stormlight');

var
  playerName, trollDate: string;
  Year, Month, Day, WDay: word;
  firstSyllable: array[0..73] of
  string = ('A', 'Ag', 'Ar', 'Ara', 'Anu', 'Bal', 'Bil', 'Boro',
    'Bern', 'Bra', 'Cas', 'Cere', 'Co', 'Con', 'Cor', 'Dag', 'Doo',
    'Elen', 'El', 'En', 'Eo', 'Faf', 'Fan', 'Fara', 'Fre', 'Fro',
    'Ga', 'Gala', 'Has', 'He', 'Heim', 'Ho', 'Isil', 'In', 'Ini',
    'Is', 'Ka', 'Kuo', 'Lance', 'Lo', 'Ma', 'Mag', 'Mi', 'Mo', 'Moon',
    'Mor', 'Mora', 'Nin', 'O', 'Obi', 'Og', 'Pelli', 'Por', 'Ran',
    'Rud', 'Sam', 'She', 'Sheel', 'Shin', 'Shog', 'Son', 'Sur', 'Theo',
    'Tho', 'Tris', 'U', 'Uh', 'Ul', 'Vap', 'Vish', 'Vor', 'Ya', 'Yo', 'Yyr');

  secondSyllable: array[0..62] of
  string = ('ba', 'bis', 'bo', 'bus', 'da', 'dal', 'dagz', 'den',
    'di', 'dil', 'dinn', 'do', 'dor', 'dra', 'dur', 'gi', 'gauble',
    'gen', 'glum', 'go', 'gorn', 'goth', 'had', 'hard', 'is', 'karrl',
    'ki', 'koon', 'ku', 'lad', 'ler', 'li', 'lot', 'ma', 'man', 'mir',
    'mus', 'nan', 'ni', 'nor', 'nu', 'pian', 'ra', 'rakh', 'ric',
    'rin', 'rum', 'rus', 'rut', 'sekh', 'sha', 'thos', 'thur', 'toa',
    'tu', 'tur', 'tred', 'varl', 'wain', 'wan', 'win', 'wise', 'ya');

  aquilonianMaleFirst: array[1..188] of
  string = ('Abant', 'Abantiad', 'Ac', 'Acris', 'Act', 'Alc', 'Alcid',
    'Am', 'Andr', 'Andr', 'Arct', 'Arct', 'Arp', 'Asclep', 'Atab',
    'Atab', 'Attal', 'Auf', 'Aufid', 'Bal', 'Balend', 'Barr', 'Barr',
    'Bor', 'Call', 'Call', 'Cenw', 'Cenw', 'Clad', 'Clad', 'Dard',
    'Dard', 'Dec', 'Decual', 'Edr', 'Elig', 'Elig', 'Em', 'Er', 'Erast',
    'Fabr', 'Fabr', 'Glac', 'Glac', 'Gr', 'Grat', 'Grat', 'Guil',
    'Guil', 'Hil', 'Hilar', 'Inach', 'Iph', 'Kl', 'Kost', 'Kost',
    'Laud', 'Laud', 'Lavon', 'Lib', 'Lorm', 'Lorm', 'Luc', 'Metab',
    'Mez', 'Mezent', 'Ner', 'Num', 'Octa', 'Octa', 'Octav', 'Pallant',
    'Parn', 'Parn', 'Periph', 'Periphet', 'Prosp', 'Rin', 'Sept',
    'Sept', 'Sor', 'Soract', 'Th', 'Thor', 'Thor', 'Tib', 'Tiber',
    'Val', 'Vict', 'Vict', 'Victor', 'Viler', 'Zav', 'Zor', 'Acast',
    'Ach', 'Acrision', 'Aeg', 'Aegid', 'Al', 'Amalr', 'Amul', 'Amul',
    'Andron', 'Ang', 'Arar', 'Arar', 'Ascl', 'Ascl', 'Atabul', 'Att',
    'Attel', 'Aur', 'Aurel', 'Ball', 'Ball', 'Baracc', 'Bel', 'Cadm',
    'Cadm', 'Carn', 'Carn', 'Ceph', 'Ceph', 'Codr', 'Codr', 'Dam',
    'Dex', 'Dexith', 'Drag', 'Drag', 'El', 'Emil', 'Emil', 'Ep',
    'Favon', 'Flav', 'Flav', 'Ful', 'Gl', 'Gonz', 'Gonz', 'Grom',
    'Grom', 'Hor', 'Horat', 'Il', 'Kest', 'Kest', 'Klaud', 'Kr',
    'Krel', 'Krel', 'Lar', 'Leon', 'Leon', 'Lor', 'Marin', 'Merc',
    'Merc', 'Met', 'Mod', 'Modest', 'Nol', 'Numed', 'Orast', 'Pall',
    'Pall', 'Parnass', 'Publ', 'Publ', 'Rig', 'Ruf', 'Septim', 'Serv',
    'Serv', 'Sur', 'Thesp', 'Troc', 'Troc', 'Tul', 'Valann', 'Valer',
    'Vil', 'Volm', 'Volm', 'Volman', 'Zet');

  aquilonianMaleLast: array[1..100] of
  string = ('a', 'i', 'o', 'as', 'el', 'er', 'es', 'ic', 'in', 'io',
    'is', 'on', 'os', 'us', 'yc', 'ago', 'ald', 'ana', 'ana', 'eas',
    'ell', 'ell', 'eri', 'eus', 'eus', 'ian', 'ias', 'ias', 'ion',
    'ius', 'ius', 'uis', 'ulf', 'ulk', 'ura', 'abus', 'acus', 'ades',
    'aeon', 'aeus', 'aime', 'alin', 'alle', 'alus', 'alvi', 'anus',
    'ares', 'aris', 'elio', 'elis', 'elus', 'erus', 'etes', 'icus',
    'ides', 'idos', 'idus', 'imer', 'imus', 'ocer', 'omel', 'orin',
    'orus', 'ulio', 'ulus', 'accus', 'achus', 'actus', 'alion', 'alric',
    'annus', 'arras', 'assus', 'astus', 'atian', 'atius', 'avian',
    'avius', 'eades', 'elius', 'endin', 'entius', 'epius', 'ercer',
    'erias', 'erius', 'estus', 'iades', 'igius', 'ilius', 'orian',
    'ostas', 'arioin', 'audius', 'edides', 'ervius', 'espius', 'itheus',
    'onicus', 'antides');

  aquilonianFemaleFirst: array[1..98] of
  string = ('Adam', 'Aeg', 'Al', 'Alb', 'Albion', 'Alc', 'Alcim',
    'Anger', 'Arac', 'Arac', 'Aracel', 'Arian', 'Ariann', 'Balb',
    'Bith', 'Bolb', 'Cair', 'Cairist', 'Call', 'Card', 'Carm', 'Cat',
    'Dac', 'Dac', 'Dam', 'Damian', 'Deid', 'Deidam', 'Dev', 'Don',
    'Ech', 'Echidn', 'Elv', 'Elv', 'Em', 'Ep', 'Epion', 'Euandr',
    'Euryd', 'Fel', 'Fluon', 'Gal', 'Gal', 'Galat', 'Gl', 'Gryn',
    'Halac', 'Hec', 'Hecub', 'Heroph', 'Hor', 'Hor', 'Horac', 'Il',
    'In', 'Iph', 'Kal', 'Kal', 'Korn', 'Lam', 'Lar', 'Lel', 'Let',
    'Lev', 'Levan', 'Lor', 'Lor', 'Lorell', 'Malv', 'Mar', 'Mat',
    'Mess', 'Naut', 'Nel', 'Nol', 'Nyd', 'Pall', 'Pan', 'Pasith',
    'Pell', 'Ph', 'Ren', 'Rh', 'Ros', 'Ros', 'Sal', 'Salv', 'Sec',
    'Suad', 'Teth', 'Tim', 'Tryph', 'Val', 'Vern', 'Vig', 'Vimand', 'Vir', 'Zel');

  aquilonianFemaleLast: array[1..100] of
  string = ('a', 'e', 'ea', 'ia', 'ia', 'ya', 'ys', 'ana', 'ana',
    'are', 'are', 'ata', 'ata', 'ede', 'ede', 'eia', 'eia', 'eis',
    'eis', 'ele', 'ele', 'ena', 'ena', 'ene', 'ene', 'era', 'era',
    'eta', 'ice', 'ice', 'ida', 'ida', 'ige', 'ige', 'ile', 'ina',
    'ina', 'ita', 'ita', 'ona', 'ona', 'ope', 'ope', 'ota', 'ota',
    'uba', 'uba', 'uta', 'uta', 'abel', 'abel', 'acia', 'acia', 'anne',
    'anne', 'atea', 'atea', 'auce', 'auce', 'elia', 'elia', 'elle',
    'elle', 'enta', 'enta', 'eria', 'eria', 'iana', 'iana', 'idna',
    'idna', 'ilia', 'ilia', 'ilis', 'ilis', 'iona', 'iona', 'iona',
    'iona', 'ione', 'ione', 'iope', 'iope', 'ista', 'ista', 'onia',
    'onia', 'unda', 'unda', 'ynia', 'ynia', 'aedra', 'ameia', 'amina',
    'andra', 'antia', 'autia', 'imede', 'inome', 'ithea');

(* Generate a name for the player *)
procedure generateName;
(* Get the current date and display it in the in-game calendar *)
procedure getTrollDate;

implementation

procedure generateName;
var
  a, b: byte;
begin
  a := Random(73);
  b := Random(62);
  playerName := firstSyllable[a] + secondSyllable[b];
end;

procedure getTrollDate;
begin
  Year := 0;
  Month := 0;
  Day := 0;
  WDay := 0;
  trollDate := '';
  GetDate(Year, Month, Day, WDay);
  trollDate := DayStr[WDay] + ', the ' + IntToStr(Day);
  (* Add suffix *)
  if (Day = 11) or (Day = 12) or (Day = 13) then
    trollDate := trollDate + 'th'
  else if (Day mod 10 = 1) then
    trollDate := trollDate + 'st'
  else if (Day mod 10 = 2) then
    trollDate := trollDate + 'nd'
  else if (Day mod 10 = 3) then
    trollDate := trollDate + 'rd'
  else
    trollDate := trollDate + 'th';
  trollDate := trollDate + ' day of ' + MonthStr[Month];
end;

end.
