type pos = int
type lexresult = Tokens.token

val lineNum = ErrorMsg.lineNum
val linePos = ErrorMsg.linePos
fun err(p1,p2) = ErrorMsg.error p1

fun eof() = let val pos = hd(!linePos) in Tokens.EOF(pos,pos) end

fun escape s =
    let val exploded = String.explode s
    in String.concat (map Char.toString exploded)
    end

fun unescape s =
    let val exploded = String.explode s


fun getStr (s, pos) =
    let val len = (String.size s)
    in Tokens.STRING(substring(s,1,(len-2)),pos,pos+len)
    end

fun getInt (s, pos, cont) =
    case (Int.fromString s)
     of (SOME c) => (Tokens.INT(c,pos,pos+(String.size s)))
      | NONE => ((ErrorMsg.error pos ("failed to parse integer: " ^ s));
                 cont())

%%
%%

type       => (Tokens.TYPE(yypos,yypos+4));
var        => (Tokens.VAR(yypos,yypos+3));
function   => (Tokens.FUNCTION(yypos,yypos+8));
break      => (Tokens.BREAK(yypos,yypos+5));
of         => (Tokens.OF(yypos,yypos+2));
end        => (Tokens.END(yypos,yypos+3));
in         => (Tokens.IN(yypos,yypos+2));
nil        => (Tokens.NIL(yypos,yypos+3));
let        => (Tokens.LET(yypos,yypos+3));
do         => (Tokens.DO(yypos,yypos+2));
to         => (Tokens.TO(yypos,yypos+2));
for        => (Tokens.FOR(yypos,yypos+3));
while      => (Tokens.WHILE(yypos,yypos+5));
else       => (Tokens.ELSE(yypos,yypos+4));
then       => (Tokens.THEN(yypos,yypos+4));
if         => (Tokens.IF(yypos,yypos+2));
array      => (Tokens.ARRAY(yypos,yypos+5));
":="     => (Tokens.ASSIGN(yypos,yypos+6));
"|"         => (Tokens.OR(yypos,yypos+2));
"&"        => (Tokens.AND(yypos,yypos+3));
">="         => (Tokens.GE(yypos,yypos+2));
">"          => (Tokens.GT(yypos,yypos+2));
"<="         => (Tokens.LE(yypos,yypos+2));
"<"          => (Tokens.LT(yypos,yypos+2));
"<>"         => (Tokens.NEQ(yypos,yypos+3));
"="          => (Tokens.EQ(yypos,yypos+2));
"/"          => (Tokens.DIVIDE(yypos,yypos+6));
"*"          => (Tokens.TIMES(yypos,yypos+5));
"-"          => (Tokens.MINUS(yypos,yypos+5));
"+"          => (Tokens.PLUS(yypos,yypos+4));
"."          => (Tokens.DOT(yypos,yypos+3));
"{"          => (Tokens.RBRACE(yypos,yypos+6));
"}"          => (Tokens.LBRACE(yypos,yypos+6));
"["          => (Tokens.RBRACK(yypos,yypos+6));
"]"          => (Tokens.LBRACK(yypos,yypos+6));
"("          => (Tokens.RPAREN(yypos,yypos+6));
")"          => (Tokens.LPAREN(yypos,yypos+6));
";"          => (Tokens.SEMICOLON(yypos,yypos+9));
":"          => (Tokens.COLON(yypos,yypos+5));
","          => (Tokens.COMMA(yypos,yypos+5));

"\""("\\\""|[^\"])*"\"" => (getStr(yytext,yypos));

[0-9]+ => (getInt(yytext,yypos,continue));

[a-zA-Z][_a-zA-Z0-9]* => (Tokens.ID(yytext,yypos,yypos+(String.size yytext)));

\/\*.*\*\/ => (continue());

\n	=> (lineNum := !lineNum+1; linePos := yypos :: !linePos; continue());
\t|" "  => (continue());
.       => (ErrorMsg.error yypos ("illegal character " ^ (escape yytext)); continue());
