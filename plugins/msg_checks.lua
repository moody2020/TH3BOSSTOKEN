local function pre_process(msg)
 if not msg.query then
local data = load_data(_config.moderation.data)
local chat = msg.to.id
local user = msg.from.id
local is_channel = msg.to.type == "supergroup"
local is_chat = msg.to.type == "group"
local auto_leave = 'AutoLeaveBot'
local TIME_CHECK = 2
if msg.from.username then -- فانكشن اليوزرنيم
usernamex = "@"..(msg.from.username or "---")
else
usernamex = "ما مسوي  😹💔"
end

if is_channel or is_chat then
if msg.text and msg.text:match("(.*)") then
if not data[tostring(chat)] and redis:get(auto_leave) and not is_sudo(msg) then
send_msg(chat, "🔖 ┇  سـوف اغـادر _ الـمـجـمـوعـه لـيـسـت فـي قـائـمـه _ *مـجـمـوعـاتـي* ", nil, "md")
leave_group(chat)
end
end

if data[tostring(chat)] then
mutes = data[tostring(chat)]['mutes']
settings = data[tostring(chat)]['settings']
else
return
end

if msg.newuser then

 if settings.lock_join == "yes" and not is_owner(msg) then
  kick_user(msg.newuser.id, chat)
local msgx = "🔖┇ الاضافة مقفولة تم طرد العضو \n"
send_msg(chat, '<b>🔖┇ العضو :</b> <code>'..msg.from.first_name..'</code><b>\n🔖 ┇ الايدي :</b> <code>'..msg.from.id..'</code>\n<b>🔖┇ المعرف :</b> '..usernamex..'\n'..msgx, nil, "html")    
end

if msg.newuser.username ~= nil then
if string.sub(msg.newuser.username:lower(), -3) == 'bot' and not is_owner(msg)  then
if settings.lock_bots_inkick == "yes"  then
kick_user(msg.newuser.id, chat)
kick_user(msg.from.id, chat)
send_msg(chat, '<b>🔖┇ العضو :</b> <code>'..msg.from.first_name..'\n</code><b>🔖 ┇ الايدي :</b> <code>'..msg.from.id..'</code>\n<b>🔖 ┇ معرف الي ضافه :</b> '..usernamex..'\n<b>🔖 ┇ معرف البوت : </b>@'..msg.newuser.username..' \n🔖 ┇ ممنوع اضافه البوتات \n🔖 ┇ تم طرد البوت مع الي ضافه 👮‍♀️', nil, "html")    
elseif settings.lock_bots == "yes" then
 kick_user(msg.newuser.id, chat)
 msgx = "🔖 ┇ ممنوع اضافه البوتات \n🔖 ┇ تم طرد البوت 👮‍♀️"
send_msg(chat, '<b>🔖┇ العضو :</b> <code>'..msg.from.first_name..'</code><b>\n🔖┇ الايدي :</b> <code>'..msg.from.id..'</code>\n'..msgx, nil, "html")    
end
end
end
end

if msg.service and mutes.mute_tgservice == "yes" then
del_msg(chat, tonumber(msg.id))
end

-- Total user msgs
if not msg.cb and msg.text then
local hashxmsgs = 'msgs:'..msg.from.id..':'..chat
redis:incr(hashxmsgs)
end


if not msg.cb and not is_mod(msg) and not is_whitelist(msg.from.id, chat) then

if is_silent_user(msg.from.id, chat) then
del_msg(chat, tonumber(msg.id))
return
end

if msg.to.type ~= 'private' and not msg.service then

if settings.flood == "yes" then
local hash = 'user:'..user..':msgs'
local msgs = tonumber(redis:get(hash) or 0)
local NUM_MSG_MAX = 5
if data[tostring(chat)] then
if data[tostring(chat)]['settings']['num_msg_max'] then
NUM_MSG_MAX = tonumber(data[tostring(chat)]['settings']['num_msg_max'])
end
end
if msgs > NUM_MSG_MAX then
if msg.from.username then
user_name = "@"..check_markdown(msg.from.username)
else
user_name = escape_markdown(namecut(msg.from.first_name))
end
if not redis:get('sender:'..user..':flood') then
del_msg(chat, msg.id)
kick_user(user, chat)
send_msg(chat, "🔖┇ العضو : "..user_name.."\n🔖┇ الايدي : ["..user.."]\n🔖┇  عذرا ممنوع التكرار لقد تم طردك 👮‍♀️\n", nil, "md")
redis:setex('sender:'..user..':flood', 30, true)
end
end
redis:setex(hash, TIME_CHECK, msgs+1)
end
end
---- 
if msg.pinned_message and is_channel then
if settings.lock_pin == "yes" and not is_owner(msg) then
local pin_msg = data[tostring(chat)]['pin']
if pin_msg then
pinChatMessage(chat, pin_msg)
elseif not pin_msg then
unpinChatMessage(chat)
end
send_msg(chat, '<b>🔖┇  الايدي :</b> <code>'..msg.from.id..'</code>\n<b>🔖┇  المعرف :</b> '..usernamex..'\n<i>🔖┇ عذرا التثبيث في هذه المجموعه مقفل ?  </i>', msg.id, "html")
end
end

if msg.cb and mutes.mute_inline == "yes" then
--del_msg(chat, tonumber(msg.id))
 if settings.lock_woring ==  "yes" then
local msgx = "🔖┇ عذرا ممنوع ارسال الانلاين ⚠️"
--send_msg(chat, '<b>🔖┇ العضو :</b> <code>'..msg.from.first_name..'\n</code><b>🔖┇ الايدي :</b> <code>'..msg.from.id..'</code>\n<b>🔖┇ المعرف :</b> '..usernamex..'\n'..msgx, nil, "html")    
end
elseif edited_message and settings.lock_edit == "yes" then
 del_msg(chat, tonumber(msg.id))
 if settings.lock_woring ==  "yes" then
local msgx = "🔖 ┇ عذرا ممنوع التعديل ⚠️"
send_msg(chat, '<b>🔖┇ العضو :</b> <code>'..msg.from.first_name..'\n</code><b>🔖┇ الايدي :</b> <code>'..msg.from.id..'</code>\n<b>🔖┇ المعرف :</b> '..usernamex..'\n'..msgx, nil, "html")    
end
elseif msg.fwd_from and mutes.mute_forward == "yes" then
 del_msg(chat, tonumber(msg.id))
 if settings.lock_woring ==  "yes" then
local msgx = "🔖┇ عذرا ممنوع عمل اعادة التوجيه ⚠️"
send_msg(chat, '<b>🔖┇ العضو :</b> <code>'..msg.from.first_name..'\n</code><b>🔖┇ الايدي :</b> <code>'..msg.from.id..'</code>\n<b>🔖┇ المعرف :</b> '..usernamex..'\n'..msgx, nil, "html")    
end
elseif msg.text then
local link_msg_web = msg.text:match("[Hh][Tt][Tt][Pp][Ss]://") or msg.text:match("[Hh][Tt][Tt][Pp]://") or msg.text:match("[Ww][Ww][Ww].") or msg.text:match(".[Cc][Oo][Mm]") 
local link_msg = msg.text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or msg.text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]/") or msg.text:match("[Tt].[Mm][Ee]/") or msg.text:match("[Tt].[Mm][Ee]") or msg.text:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/") or msg.text:match("[Tt][Ee][Ll][Ee][Ss][Cc][Oo].[Pp][Ee]/") or msg.text:match(".[Pp][Ee]/")
if mutes.mute_text == "yes" then
 del_msg(chat, tonumber(msg.id))
elseif string.len(msg.text) > 850 and settings.lock_spam == "yes" then
 del_msg(chat, tonumber(msg.id))
 if settings.lock_woring ==  "yes" then
local msgx = "🔖┇ ممنوع ارسال الكليشه عزيزي ⚠️"
send_msg(chat, '<b>🔖┇ العضو :</b> <code>'..msg.from.first_name..'\n</code><b>🔖┇ الايدي :</b> <code>'..msg.from.id..'</code>\n<b>🔖┇ المعرف :</b> '..usernamex..'\n'..msgx, nil, "html")    
end
elseif link_msg and settings.lock_link == "yes" then
 del_msg(chat, tonumber(msg.id))
 if settings.lock_woring ==  "yes" then
local msgx = "🔖┇ عذرا ممنوع ارسال الروابط ⚠️"
send_msg(chat, '<b>🔖┇ العضو :</b> <code>'..msg.from.first_name..'\n</code><b>🔖┇ الايدي :</b> <code>'..msg.from.id..'</code>\n<b>🔖┇ المعرف :</b> '..usernamex..'\n'..msgx, nil, "html")    
end
elseif link_msg_web and settings.lock_webpage =="yes" then
 del_msg(chat, tonumber(msg.id))
 if settings.lock_woring ==  "yes" then
local msgx = "🔖┇ ممنوع ارسال روابط الويب ⚠️"
send_msg(chat, '<b>🔖 ┇ العضو :</b> <code>'..msg.from.first_name..'\n</code><b>🔖 ┇ الايدي :</b> <code>'..msg.from.id..'</code>\n<b>🔖 ┇ المعرف :</b> '..usernamex..'\n'..msgx, nil, "html")    
end
elseif ( msg.text:match("@") or msg.text:match("#")) and settings.lock_tag == "yes" then
 del_msg(chat, tonumber(msg.id))
 if settings.lock_woring ==  "yes" then
local msgx = "🔖┇ عذرا ممنوع ارسال التاك او المعرف ⚠️"
send_msg(chat, '<b>🔖 ┇ العضو :</b> <code>'..msg.from.first_name..'\n</code><b>🔖 ┇ الايدي :</b> <code>'..msg.from.id..'</code>\n<b>🔖 ┇ المعرف :</b> '..usernamex..'\n'..msgx, nil, "html")    
end
elseif is_filter(msg, msg.text) then
 del_msg(chat, tonumber(msg.id))
end

elseif msg.photo and mutes.mute_photo == "yes" then
 del_msg(chat, tonumber(msg.id))
 if settings.lock_woring ==  "yes" then
local msgx = "🔖┇ عذرا ممنوع ارسال الصور ⚠️"
send_msg(chat, '<b>🔖 ┇ العضو :</b> <code>'..msg.from.first_name..'\n</code><b>🔖 ┇ الايدي :</b> <code>'..msg.from.id..'</code>\n<b>🔖┇ المعرف :</b> '..usernamex..'\n'..msgx, nil, "html")    
end
elseif msg.video and mutes.mute_video == "yes" then
 del_msg(chat, tonumber(msg.id))
 if settings.lock_woring ==  "yes" then
local msgx = "🔖┇ عذرا ممنوع ارسال الفيديو ⚠️"
send_msg(chat, '<b>🔖┇ العضو :</b> <code>'..msg.from.first_name..'\n</code><b>🔖┇ الايدي :</b> <code>'..msg.from.id..'</code>\n<b>🔖┇ المعرف :</b> '..usernamex..'\n'..msgx, nil, "html")    
end
elseif msg.document and mutes.mute_document == "yes" and msg.document.mime_type ~= "audio/mpeg" and msg.document.mime_type ~= "video/mp4" then
 del_msg(chat, tonumber(msg.id))
 if settings.lock_woring ==  "yes" then
local msgx = "🔖┇ عذرا ممنوع ارسال الملفات ⚠️"
send_msg(chat, '<b>🔖┇ العضو :</b> <code>'..msg.from.first_name..'\n</code><b>🔖┇ الايدي :</b> <code>'..msg.from.id..'</code>\n<b>🔖┇ المعرف :</b> '..usernamex..'\n'..msgx, nil, "html")    
end
elseif msg.sticker and mutes.mute_sticker == "yes" then
 del_msg(chat, tonumber(msg.id))
 if settings.lock_woring ==  "yes" then
local msgx = "🔖 ┇ عذرا ممنوع ارسال الملصقات ⚠️"
send_msg(chat, '<b>🔖┇ العضو :</b> <code>'..msg.from.first_name..'\n</code><b>🔖 ┇ الايدي :</b> <code>'..msg.from.id..'</code>\n<b>🔖 ┇ المعرف :</b> '..usernamex..'\n'..msgx, nil, "html")    
end
elseif msg.document and msg.document.mime_type == "video/mp4" and mutes.mute_gif == "yes" then
 del_msg(chat, tonumber(msg.id))
 if settings.lock_woring ==  "yes" then
local msgx = "🔖┇ ممنوع ارساله صور المتحركه ⚠️"
send_msg(chat, '<b>🔖 ┇ العضو :</b> <code>'..msg.from.first_name..'\n</code><b>🔖 ┇ الايدي :</b> <code>'..msg.from.id..'</code>\n<b>🔖 ┇ المعرف :</b> '..usernamex..'\n'..msgx, nil, "html")    
end
elseif msg.contact and mutes.mute_contact == "yes" then
 del_msg(chat, tonumber(msg.id))
 if settings.lock_woring ==  "yes" then
local msgx = "🔖 ┇ عذرا يمنع ارسال الجهات الاتصال ⚠️"
send_msg(chat, '<b>🔖 ┇ العضو :</b> <code>'..msg.from.first_name..'\n</code><b>🔖 ┇ الايدي :</b> <code>'..msg.from.id..'</code>\n<b>🔖 ┇ المعرف :</b> '..usernamex..'\n'..msgx, nil, "html")    
end
elseif msg.location and mutes.mute_location == "yes" then
 del_msg(chat, tonumber(msg.id))
 if settings.lock_woring ==  "yes" then
local msgx = "🔖┇ ممنوع ارسال موقعك ⚠️"
send_msg(chat, '<b>🔖 ┇ العضو :</b> <code>'..msg.from.first_name..'\n</code><b>🔖 ┇ الايدي :</b> <code>'..msg.from.id..'</code>\n<b>🔖 ┇ المعرف :</b> '..usernamex..'\n'..msgx, nil, "html")    
end
elseif msg.voice and mutes.mute_voice == "yes" then
 del_msg(chat, tonumber(msg.id))
 if settings.lock_woring ==  "yes" then
local msgx = "🔖 ┇ ممنوع ارسال البصمات ⚠️"
send_msg(chat, '<b>🔖┇ العضو :</b> <code>'..msg.from.first_name..'\n</code><b>🔖 ┇ الايدي :</b> <code>'..msg.from.id..'</code>\n<b>🔖 ┇ المعرف :</b> '..usernamex..'\n'..msgx, nil, "html")    
end
elseif msg.document and msg.document.mime_type == "audio/mpeg" and mutes.mute_audio == "yes" then
 del_msg(chat, tonumber(msg.id))
 if settings.lock_woring ==  "yes" then
local msgx = "🔖┇ عذرا ممنوع ارسال الصوت ⚠️"
send_msg(chat, '<b>🔖 ┇ العضو :</b> <code>'..msg.from.first_name..'\n</code><b>🔖 ┇ الايدي :</b> <code>'..msg.from.id..'</code>\n<b>🔖 ┇ المعرف :</b> '..usernamex..'\n'..msgx, nil, "html")    
end
elseif msg.caption then
local link_caption = msg.caption:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or msg.caption:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]/") or msg.caption:match("[Tt].[Mm][Ee]/") or msg.caption:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/")
local link_caption_web = msg.caption:match("[Hh][Tt][Tt][Pp][Ss]://") or msg.caption:match("[Hh][Tt][Tt][Pp]://") or msg.caption:match("[Ww][Ww][Ww][Ww].") 

if link_caption_web and settings.lock_webpage =="yes" then
 del_msg(chat, tonumber(msg.id))
 if settings.lock_woring ==  "yes" then
local msgx = "🔖 ┇ ممنوع ارسال روابط الويب ⚠️"
send_msg(chat, '<b>🔖 ┇ العضو :</b> <code>'..msg.from.first_name..'\n</code><b>🔖 ┇ الايدي :</b> <code>'..msg.from.id..'</code>\n<b>🔖┇ المعرف :</b> '..usernamex..'\n'..msgx, nil, "html")    
end
end

if link_caption and settings.lock_link == "yes" then
 del_msg(chat, tonumber(msg.id))
 if settings.lock_woring ==  "yes" then
local msgx = "🔖 ┇ عذرا ممنوع ارسال الروابط ⚠️"
send_msg(chat, '<b>🔖┇ العضو :</b> <code>'..msg.from.first_name..'\n</code><b>🔖 ┇ الايدي :</b> <code>'..msg.from.id..'</code>\n<b>🔖 ┇ المعرف :</b> '..usernamex..'\n'..msgx, nil, "html")    
end
elseif (msg.caption:match("@") or msg.caption:match("#")) and settings.lock_tag == "yes" then
 del_msg(chat, tonumber(msg.id))
 if settings.lock_woring ==  "yes" then
local msgx = "🔖 ┇ ممنوع ارسال تاك او معرف ⚠️"
send_msg(chat, '<b>🔖 ┇ العضو :</b> <code>'..msg.from.first_name..'\n</code><b>🔖 ┇ الايدي :</b> <code>'..msg.from.id..'</code>\n<b>🔖 ┇ المعرف :</b> '..usernamex..'\n'..msgx, nil, "html")    
end
elseif is_filter(msg, msg.caption) then
 del_msg(chat, tonumber(msg.id))
end

elseif msg.entities then
  for i,entity in pairs(msg.entities) do


if entity.type == "bold" or entity.type == "code" or entity.type == "italic" then
if settings.lock_markdown == "yes" then
del_msg(chat, tonumber(msg.id))
 if settings.lock_woring ==  "yes" then
local msgx = "🔖┇ ممنوع ارسال الماركدوان  ⚠️"
send_msg(chat, '<b>🔖┇ العضو :</b> <code>'..msg.from.first_name..'\n</code><b>🔖┇ الايدي :</b> <code>'..msg.from.id..'</code>\n<b>🔖┇ المعرف :</b> '..usernamex..'\n'..msgx, nil, "html")    
end
end
end
end


end


end
end
end
end
return {
	patterns = {},
	pre_process = pre_process
}