
local function getindex(t,id) 
for i,v in pairs(t) do 
if v == id then 
return i 
end 
end 
return nil 
end

local function reload_plugins( ) 
  plugins = {} 
  load_plugins() 
end

local function moody_sudo(user_id)
  for k,v in pairs(_config.sudo_users) do
    if user_id == v then
      return k
    end
  end
  -- If not found
  return false
end

local function sudolist(msg)
local sudo_users = _config.sudo_users
text = "*🔖┇   قـائـمـه الـمـطـوريـن ☑️┇🔒  : *\n"
for i=1,#sudo_users do
    text = text..i.." - "..sudo_users[i].."\n"
end
return text
end


local function chat_list(msg)
	i = 1
	local data = load_data(_config.moderation.data)
    local groups = 'groups'
    if not data[tostring(groups)] then
        return "🔖┇  لا يـوجـد مـجـمـوعـات مـفـعـله حـالـيـا "
    end
    local message = '🔖┇   قـائمـه الـكـروبـات  :\n\n'
    for k,v in pairsByKeys(data[tostring(groups)]) do
		local group_id = v
		if data[tostring(group_id)] then
			settings = data[tostring(group_id)]['settings']
		end
        for m,n in pairsByKeys(settings) do
			if m == 'set_name' then
				name = n:gsub("", "")
				chat_name = name:gsub("‮", "")
				 group_name_id = name .. ' \n* 🔖┇  ايـدي : [<code>' ..group_id.. '</code>]\n'

					group_info = i..' ـ '..group_name_id

				i = i + 1
			end
        end
		message = message..group_info
    end
	send_msg(msg.to.id, message,nil,"html")
end

 function botrem(msg)
	local data = load_data(_config.moderation.data)
	if data[tostring(msg.to.id)] then
	data[tostring(msg.to.id)] = nil
	save_data(_config.moderation.data, data)
	local groups = 'groups'
	if not data[tostring(groups)] then
		data[tostring(groups)] = nil
		save_data(_config.moderation.data, data)
	end
	data[tostring(groups)][tostring(msg.to.id)] = nil
	save_data(_config.moderation.data, data)
	if redis:get('CheckExpire::'..msg.to.id) then
		redis:del('CheckExpire::'..msg.to.id)
	end
	if redis:get('ExpireDate:'..msg.to.id) then
		redis:del('ExpireDate:'..msg.to.id)
	end
	  leave_group(msg.to.id)
	end
  leave_group(msg.to.id)
end

local function warning(msg)
local expiretime = redis:ttl('ExpireDate:'..msg.to.id)
if expiretime == -1 then
return
else
local d = math.floor(expiretime / 86400) + 1
if tonumber(d) == 1 and not is_sudo(msg) and is_mod(msg) then
send_msg(msg.to.id,'🔖┇  يرجى التواصل مع مطور البوت لتجديد اشتراك البوت والا ساخرج تلقائيا ‼️', msg.id, 'md')
end
end
end
local function pre_process(msg)
if msg.to.type ~= 'private' then
local data = load_data(_config.moderation.data)
local gpst = data[tostring(msg.to.id)]
local chex = redis:get('CheckExpire::'..msg.to.id)
local exd = redis:get('ExpireDate:'..msg.to.id)
if gpst and not chex and msg.from.id ~= sudo_id and not is_sudo(msg) then
redis:set('CheckExpire::'..msg.to.id,true)
redis:set('ExpireDate:'..msg.to.id,true)
redis:setex('ExpireDate:'..msg.to.id, 86400, true)
send_msg(msg.to.id, '🔖┇  تم دعم المجموعه ليوم واحد \n🔖┇  راسل المطور لتجديد الوقت',msg.id,'md')
end
if chex and not exd and msg.from.id ~= sudo_id and not is_sudo(msg) then
local text1 = '🔖┇ اشتراك المجموعه انتهى  🎐\n🔖┇ '..msg.to.title..'\n\nID:  <code>'..msg.to.id..'</code>'
local text2 = '🔖┇ الاشتراك البوت انتهى \n🔖┇ سوف اغادر \n🔖┇ لتجديد الاشتراك راسل '..botname
send_msg(sudo_id, text1, nil, 'html')
send_msg(msg.to.id, text2, msg.id, 'html')
botrem(msg)
else
local expiretime = redis:ttl('ExpireDate:'..msg.to.id)
local day = (expiretime / 86400)
if tonumber(day) > 0.208 and not is_sudo(msg) and is_mod(msg) then
warning(msg)
end
end
end
end


local function run(msg, matches)

local data = load_data(_config.moderation.data)

  if tonumber(msg.from.id) == tonumber(sudo_id) then
   if matches[1] == "رفع مطور" then
   if not matches[2] and msg.reply_to_message then
	if msg.reply.username then
	username = "@"..check_markdown(msg.reply.username)
    else
	username = escape_markdown(msg.reply.print_name)
end
      if msg.reply.id == our_id then return end
   if moody_sudo(tonumber(msg.reply.id)) then
    return "🔖┇  الـعـضـو  :"..username.." \n🔖┇   الايـدي :  ["..msg.reply.id.."]\n🔖┇  اانـه بـالـتـأكـيـد مـطـور ☑️┇🔒"
    else
          table.insert(_config.sudo_users, tonumber(msg.reply.id)) 
     save_config() 
     reload_plugins(true) 
    return "🔖┇  الـعـضـو  :"..username.." \n🔖┇   الايـدي :  ["..msg.reply.id.."]\n🔖┇   تـم تـرقـيـتـه لـيـصـبـح مـطـور ☑️┇🔒"
      end
  elseif matches[2] and matches[2]:match('^%d+') then
            if matches[2] == our_id then return end
   if not getUser(matches[2]).result then
   return "🔖┇ لا يوجد عضو بهذا المعرف"
    end
	  local user_name = '@'..check_markdown(getUser(matches[2]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[2]).information.first_name)
	  end
   if moody_sudo(tonumber(matches[2])) then
     return "🔖┇  الـعـضـو  :  "..user_name.."\n🔖┇  الايدي : ["..matches[2].."]\n🔖┇  اانـه بـالـتـأكـيـد مـطـور ☑️┇🔒"
    else
           table.insert(_config.sudo_users, tonumber(matches[2])) 
     save_config() 
     reload_plugins(true) 
    return "🔖┇  الـعـضـو  :  "..user_name.."\n🔖┇  الايدي : ["..matches[2].."] \n🔖┇   تـم تـرقـيـتـه لـيـصـبـح مـطـور ☑️┇🔒"
   end
   elseif matches[2] and string.match(matches[2], '@[%a%d_]')  then
    local status = resolve_username(matches[2])
         if status.information.id == our_id then return end
   if not resolve_username(matches[2]).result then
   return "🔖┇لا يوجد عضو بهذا المعرف"
end
if moody_sudo(tonumber(status.information.id)) then
     return "🔖┇  الـعـضـو  :  @"..check_markdown(status.information.username).."\n🔖┇  الايدي : ["..status.information.id.."] \n🔖┇  اانـه بـالـتـأكـيـد مـطـور ☑️┇🔒"
    else
          table.insert(_config.sudo_users, tonumber(status.information.id)) 
     save_config() 
     reload_plugins(true) 
    return "🔖┇  الـعـضـو  :  @"..check_markdown(status.information.username).."\n🔖┇  الايدي : ["..status.information.id.."] \n🔖┇   تـم تـرقـيـتـه لـيـصـبـح مـطـور ☑️┇🔒"
     end
  end
end
   if matches[1] == "تنزيل مطور" then
      if not matches[2] and msg.reply_to_message then
	if msg.reply.username then
	username = "@"..check_markdown(msg.reply.username)
    else
	username = escape_markdown(msg.reply.print_name)
end
if tonumber(msg.reply.id) == tonumber(our_id) then return end
   if not moody_sudo(tonumber(msg.reply.id)) then
    return "🔖┇  الـعـضـو  :"..username.." \n🔖┇   الايـدي :  ["..msg.reply.id.."]\n🔖┇  انـه بـالـتـأكـيـد تـم تـنـزيـلـه مـن الـمـطـوريـن ☑️┇🔓"
    else
          table.remove(_config.sudo_users, getindex( _config.sudo_users, tonumber(msg.reply.id)))
		save_config()
     reload_plugins(true) 
    return "🔖┇  الـعـضـو  :"..username.." \n🔖┇   الايـدي :  ["..msg.reply.id.."]\n🔖┇  تـم تـنـزيـلـه مـن الـمـطـوريـن  ☑️┇🔓"
      end
	  elseif matches[2] and matches[2]:match('^%d+') then
 if tonumber(matches[2]) == tonumber(our_id) then return end
  if not getUser(matches[2]).result then
   return "🔖┇ لا يوجد عضو بهذا المعرف"
    end
	  local user_name = '@'..check_markdown(getUser(matches[2]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[2]).information.first_name)
	  end
   if not moody_sudo(tonumber(matches[2])) then
    return "🔖┇  الـعـضـو  :  "..user_name.." \n🔖┇   الايـدي :  ["..matches[2].."]\n🔖┇  انـه بـالـتـأكـيـد تـم تـنـزيـلـه مـن الـمـطـوريـن ☑️┇🔓"
    else
          table.remove(_config.sudo_users, getindex( _config.sudo_users, tonumber(matches[2])))
		save_config()
     reload_plugins(true) 
    return "🔖┇  الـعـضـو  :  "..user_name.." \n🔖┇   الايـدي :  ["..matches[2].."] \n🔖┇  تـم تـنـزيـلـه مـن الـمـطـوريـن  ☑️┇🔓"
      end
elseif matches[2] and string.match(matches[2], '@[%a%d_]')  then
      local status = resolve_username(matches[2])
   if tonumber(status.id) == tonumber(our_id) then return end

   if not resolve_username(matches[2]).result then
   return "🔖┇ لا يوجد عضو بهذا المعرف"
    end
   if not moody_sudo(tonumber(status.information.id)) then
    return "🔖┇  الـعـضـو  :  @"..check_markdown(status.information.username).." \n🔖┇   الايـدي :  ["..status.information.id.."] \n🔖┇  انـه بـالـتـأكـيـد تـم تـنـزيـلـه مـن الـمـطـوريـن ☑️┇🔓"
    else
          table.remove(_config.sudo_users, getindex( _config.sudo_users, tonumber(status.information.id)))
		save_config()
     reload_plugins(true) 
    return "🔖┇  الـعـضـو  :  @"..check_markdown(status.information.username).." \n🔖┇   الايـدي :  ["..status.information.id.."] \n🔖┇  تـم تـنـزيـلـه مـن الـمـطـوريـن  ☑️┇🔓"
          end
      end
   end
end

if is_sudo(msg) then



  
if matches[1] == 'المجموعات' then
return chat_list(msg)
    end
if matches[1] == 'تعطيل' and matches[2] and string.match(matches[2], '^%d+$') then
    local data = load_data(_config.moderation.data)
			-- Group configuration removal
			data[tostring(matches[2])] = nil
			save_data(_config.moderation.data, data)
			local groups = 'groups'
			if not data[tostring(groups)] then
				data[tostring(groups)] = nil
				save_data(_config.moderation.data, data)
			end
			data[tostring(groups)][tostring(matches[2])] = nil
			save_data(_config.moderation.data, data)
	   send_msg(matches[2], "🔖┇ تم تعطيل البوت من قبل المطور", nil, 'md')
    send_msg(msg.to.id , '🔖┇ المجموعه : *'..matches[2]..'* تم تعطيلها')
		end
  if matches[1] == 'اذاعه' and matches[2]  then	
if tonumber(msg.from.id) ~= tonumber(sudo_id) then return " هذا الامر للمطور الاساسي فقط ┇🔖" end
  local data = load_data(_config.moderation.data)		
  local bc = matches[2]		
  local i = 1
  for k,v in pairs(data) do				
send_msg(k, bc)
i = i+1
end	
send_msg(msg.to.id, '🔖┇ تم اذاعه الرساله الى ['..i..'] مجموعه ')

end
if matches[2] == 'الخروج التلقائي' and is_sudo(msg) then
--Enable Auto Leave
     if matches[1] == 'تعطيل' then
    redis:del('AutoLeaveBot')
     return '🔖┇ تم تعطيل الخروج التلقائي'
--Disable Auto Leave
     elseif matches[1] == 'تفعيل' then
    redis:set('AutoLeaveBot', true)
 return '🔖┇ تم تفعيل الخروج التلقائي'
--Auto Leave Status
end
end
if matches[1] =="الخروج التلقائي" then
if redis:get('AutoLeaveBot') then
return '🔖┇ الخروج التلقائي: مفعل'
else
return '🔖┇ الخروج التلقائي: معطل'
end
end


if msg.to.type == 'supergroup' or msg.to.type == 'group' then



 if not data[tostring(msg.to.id)] then return end


if matches[1] == 'شحن' and matches[2] and not matches[3] and is_sudo(msg) then
if tonumber(matches[2]) > 0 and tonumber(matches[2]) < 1001 then
local extime = (tonumber(matches[2]) * 86400)
redis:setex('ExpireDate:'..msg.to.id, extime, true)
if not redis:get('CheckExpire::'..msg.to.id) then
redis:set('CheckExpire::'..msg.to.id)
end
send_msg(msg.to.id, '🔖┇تم شحن الاشتراك ل\n [<code>'..matches[2]..'</code>] يوم ⌚️',msg.id, 'html')
send_msg(sudo_id, ' 🔖┇تم تمديد فتره الاشتراك لـ[<code>'..matches[2]..'</code>].\n 🔖┇ في المجموعه\n🔖┇ [<code>'..msg.to.title..'</code>]',nil, 'html')
else
send_msg(msg.to.id,  '_ اختر من 1 الى 1000 فقط ⌚️    ._',msg.id, 'md')
end
end

if matches[1]:lower() == 'الاشتراك' and is_mod(msg) and not matches[2] then
local expi = redis:ttl('ExpireDate:'..msg.to.id)
if expi == -1 then
	send_msg(msg.to.id, '_المجموعه مفعله مدى الحياه⌚️_', msg.id, 'md')
else
local day = math.floor(expi / 86400) + 1
if expi == -1 then
	expire_date = 'مفتوح👮‍♀️'
    elseif day == 1 then
	expire_date = 'يوم واحد' 
	elseif day == 2 then
   	expire_date = 'يومين'
	elseif day <= 10 then
   	expire_date = day..' ايام'
   	else
	expire_date = day..' يوم'
end
 send_msg(msg.to.id, '🔖┇ باقي '..day..' وينتهي اشتراك البوت 👮‍♀️', msg.id, 'md')
end
end

if matches[1]:lower() == 'الاشتراك' and matches[2] == '1' and not matches[3] then
			local timeplan1 = 2592000
			redis:setex('ExpireDate:'..msg.to.id, timeplan1, true)
			if not redis:get('CheckExpire::'..msg.to.id) then
				redis:set('CheckExpire::'..msg.to.id,true)
			end
send_msg(sudo_id, '🔖┇ تم تفعيل المجموعه\n🔖┇  [ <code>'..msg.to.title..'</code> ]\n🔖┇الاشتراك : شهر واحد 🛠 )' , nil, 'html')
send_msg(msg.to.id, '🔖┇ تم تفعیل المجموعه ستبقی صالحه الی 30 یوم⌚️', msg.id, 'md')
		end
if matches[1]:lower() == 'الاشتراك' and matches[2] == '2' and not matches[3] then
			local timeplan2 = 7776000
			redis:setex('ExpireDate:'..msg.to.id,timeplan2,true)
			if not redis:get('CheckExpire::'..msg.to.id) then
				redis:set('CheckExpire::'..msg.to.id,true)
			end
send_msg(sudo_id, '🔖┇ تم تفعيل المجموعه \n🔖┇ [ <code>'..msg.to.title..'</code> ]\n🔖┇ الاشتراك : 3 اشهر 🛠 )', nil, 'html')
send_msg(msg.to.id, '🔖┇ تم تفعيل البوت بنجاح وصلاحيته لمده 90 يوم  )', msg.id, 'md')
		end
if matches[1]:lower() == 'الاشتراك' and matches[2] == '3' and not matches[3] then
			redis:set('ExpireDate:'..msg.to.id,true)
			if not redis:get('CheckExpire::'..msg.to.id) then
				redis:set('CheckExpire::'..msg.to.id,true)
			end
send_msg(sudo_id, '🔖┇ تم تفعيل المجموعه \n🔖┇ [ <code>'..msg.to.title..'</code> ]\n🔖┇ الاشتراك : مدى الحياه', nil, 'html')
send_msg(msg.to.id, '🔖┇ تم تفعيل البوت بنجاح وصلاحيته مدى الحياه ', msg.id, 'md')
end
end



end
---------------Help Tools----------------
  
if matches[1] == 'السورس' and data[tostring(msg.to.id)]  then
send_msg(msg.to.id, _config.info_text, msg.id)
end
if matches[1] == "المطورين" and data[tostring(msg.to.id)] and is_sudo(msg) then
return sudolist(msg)
end


if matches[1]:lower() == 'معلوماتي' or matches[1]:lower() == 'موقعي'  then
if msg.from.username then username = '@'..msg.from.username
else username = '<i>ما مسوي  😹💔</i>'
end
if is_sudo(msg) then rank = 'المطور مالتي 😻'
elseif is_owner(msg) then rank = 'مدير المجموعه 😽'
elseif is_mod(msg) then rank = 'ادمن في البوت 😺'
elseif is_whitelist (msg) then rank = '😺 عضو مميز'
else rank = 'مجرد عضو 😹'
end
local info = '<b>👮‍♀️️┇ اهـلا بـك معلوماتك :</b>\n\n<b>🔖┇ الاسم :</b> <i>'..(msg.from.first_name)..'</i>\n<b>🔖┇ المعرف:</b> '..username
..'\n<b>🔖┇ الايدي :</b> [ <code>'..msg.from.id
..'</code> ]\n<b>🔖┇ ايدي الكروب :</b> [ <code>'..msg.to.id
..'</code> ]\n<b>🔖┇ موقعك :</b> <i>'..rank..'</i>'
send_msg(msg.to.id, info, msg.id, 'html')
end
 if matches[1] == "مواليدي" then
local kyear = tonumber(os.date("%Y"))
local kmonth = tonumber(os.date("%m"))
local kday = tonumber(os.date("%d"))
--
local agee = kyear - matches[2]
local ageee = kmonth - matches[3]
local ageeee = kday - matches[4]

return  " 👮🏼 مرحبا عزيزي"
.."\n👮🏼 لقد قمت بحسب عمرك 👮‍♀️  \n\n"

.."🔖┇ "..agee.." سنه\n"
.."🔖┇ "..ageee.." اشهر \n"
.."🔖┇ "..ageeee.." يوم \n\n"

end
-------



if matches[1] == "الاوامر" then
if not is_mod(msg) then return "🔖┇ للاداريين فقط 👮‍♀️" end
local usersudo = string.gsub(_config.sudouser, '@', '')
keyboard = {}
keyboard.inline_keyboard = {
{
{text= '  • تحدث مع المطور •' ,url = 'https://t.me/'..usersudo} -- هنا خلي معرفك انته كمطور
}					
}
tkey = [[
👨‍✈️┇مرحبـا بك ياعزيزي الاوامر 👇🏿
⚜┇ﮧ➖⚜➖⚜➖⚜➖⚜
🔖┇م1 ✧✧ اوامر الادارة
🔖┇م2 ✧✧ اوامر اعدادت الكروب
🔖┇م3 ✧✧ اوامر الحماية 
🔖┇م4 ✧✧ الاوامـر الـ؏ـامه 
🔖┇م5 ✧✧ اوامر اضافه ردود
🔖┇م6 ✧✧ اوامر الزخرفه
🔖┇م المطور ✧✧ للمطور فقط 
⚜┇ ﮧ➖⚜➖⚜➖⚜➖⚜
👨‍✈️┇اضغط للتحدث مع المطور 👇🏿
]]
send_key(msg.chat.id, tkey, keyboard, msg.message_id, "html")
end
if matches[1]== 'م1' then
if not is_mod(msg) then return "🔖 ┇ للاداريين فقط 👮‍♀️" end
local usersudo = string.gsub(_config.sudouser, '@', '')
keyboard = {}
keyboard.inline_keyboard = {
{
{text= '  • تحدث مع المطور •' ,url = 'https://t.me/'..usersudo} -- هنا خلي معرفك انته كمطور
}					
}
tkey = [[
👨‍✈️┇ مرحبا عزيزي اوامر الادارة 👇🏿
⚜┇ﮧ➖⚜➖⚜➖⚜➖⚜
👨‍🔧┇اوامر التنزيل والرفع بـ البوت👇🏿
⚜┇ﮧ➖⚜➖⚜➖⚜➖⚜
🔖┇ رفع ادمن ✧✧ لرفع ادمن 
🔖┇تنزيل ادمن ✧✧ لتنزيل ادمن
🔖┇رفع عضو مميز ✧✧ لرفع مميز 
🔖┇تنزيل عضو مميز✧لتنزيل مميز 
🔖┇ الادمنيه ✧✧ لعرض الادمنيه
🔖┇ الاداريين ✧✧لعرض الاداريين
⚜┇ﮧ➖⚜➖⚜➖⚜➖⚜
👨‍🔧┇ اوامر الطرد والحضر 
⚜┇ﮧ➖⚜➖⚜➖⚜➖⚜
🔖┇ طرد بالرد ✧✧ لطرد العضو 
🔖┇ حظر بالرد ✧✧لحظر وطرد 
🔖┇ الغاء الحظر ✧✧ لالغاء الحظر 
🔖┇ منع ✧✧لمنع كلمه في الكروب
🔖┇ الغاء منع ✧✧لالغاء منع الكلمه  
🔖┇ كتم ✧✧ لكتم عضو  
🔖┇ الغاء الكتم✧✧ لالغاء الكتم 
⚜┇ﮧ➖⚜➖⚜➖⚜➖⚜
👨‍✈️┇ اضغط للتحدث مع المطور 👇🏿
]]
send_key(msg.chat.id, tkey, keyboard, msg.message_id, "html")
end
if matches[1]== 'م2' then
if not is_mod(msg) then return "🔖 ┇ للاداريين فقط 👮‍♀️" end
local usersudo = string.gsub(_config.sudouser, '@', '')
keyboard = {}
keyboard.inline_keyboard = {
{
{text= ' • تحدث مع المطور •' ,url = 'https://t.me/'..usersudo} -- هنا خلي معرفك انته كمطور
}					
}
tkey = [[
👨‍✈️┇مرحبا عزيزي اوامر اعدادت👇🏿
⚜┇ﮧ➖⚜➖⚜➖⚜➖⚜
👨‍🔧┇ اوامر الوضع للمجموعه👇🏿
⚜┇ﮧ➖⚜➖⚜➖⚜➖⚜
🔖┇ضع الترحيب✧✧لوضع ترحيب  
🔖┇ ضع قوانين✧✧ لوضع قوانين 
🔖┇ ضع وصف ✧✧ لوضع وصف    
🔖┇ الرابط ✧✧ لعرض الرابط  
⚜️┇ﮧ➖⚜️➖⚜️➖⚜️➖⚜
👨‍🔧┇ اوامر رؤيه الاعدادات 👇🏿
⚜️┇ﮧ➖⚜️➖⚜️➖⚜️➖⚜️
🔖┇ القوانين ✧✧لعرض القوانين  
🔖┇ المكتومين ✧✧لعرض المكتومين 
🔖┇ المطور ✧✧ لعرض المطور 
🔖┇ معلوماتي ✧✧لعرض معلوماتك  
🔖┇ الحمايه ✧✧ لعرض اعدادات 
🔖┇الوسائط ✧✧لعرض  الميديا 
🔖┇المجموعه ✧معلومات المجموعه 
⚜┇ﮧ➖⚜➖⚜➖⚜➖⚜
👨‍✈️┇اضغط للتحدث مع المطور 👇🏿
]]
send_key(msg.chat.id, tkey, keyboard, msg.message_id, "html")
end
if matches[1]== 'م3' then
if not is_mod(msg) then return "🔖 ┇ للاداريين فقط 👮‍♀️" end
local usersudo = string.gsub(_config.sudouser, '@', '')
keyboard = {}
keyboard.inline_keyboard = {
{
{text= '  • تحدث مع المطور • ' ,url = 'https://t.me/'..usersudo} -- هنا خلي معرفك انته كمطور
}					
}
tkey = [[
👨‍✈️┇مرحبا عزيزي اوامر حمايه👇🏿
⚜┇ﮧ➖⚜➖⚜➖⚜➖⚜
👨‍🔧┇ اوامر حمايه المجموعه ⚡️
⚜┇ﮧ➖⚜➖⚜➖⚜➖⚜
🔖┇قفل┇ فتح ✧  التثبيت
🔖┇قفل┇ فتح ✧ التعديل
🔖┇قفل┇ فتح ✧ البصمات
🔖┇قفل┇ فتح ✧ الـفيديو
🔖┇قفل┇ فتح ✧ الـصوت 
🔖┇قفل┇ فتح ✧  الـصور 
🔖┇قفل┇ فتح ✧ الملصقات
🔖┇قفل┇ فتح ✧ المتحركه
🔖┇قفل┇ فتح ✧ الدردشه
🔖┇قفل┇ فتح ✧ الملصقات
🔖┇قفل┇ فتح ✧ الروابط
🔖┇قفل┇ فتح ✧التاك
🔖┇قفل┇ فتح ✧ البوتات
🔖┇قفل┇ فتح ✧ البوتات بالطرد
🔖┇قفل┇ فتح ✧ الكلايش
🔖┇قفل┇ فتح ✧ التكرار
🔖┇قفل┇ فتح ✧ التوجيه
🔖┇قفل┇ فتح ✧ الجهات 
🔖┇قفل┇ فتح ✧ المجموعه 
🔖┇قفل┇ فتح ✧ الماركدون
⚜┇ﮧ➖⚜➖⚜➖⚜➖⚜
🔖┇تشغيل┇ ايقاف ✧ الترحيب 
🔖┇تشغيل┇ ايقاف ✧ الردود 
🔖┇تشغيل┇ ايقاف ✧ التحذير
🔖┇تشغيل┇ ايقاف ✧ الايدي
⚜┇ﮧ➖⚜➖⚜➖⚜➖⚜
👨‍✈️┇ اضغط للتحدث مع المطور 👇🏿
]]
send_key(msg.chat.id, tkey, keyboard, msg.message_id, "html")
end
if matches[1]== 'م4' then
if not is_mod(msg) then return "🔖 ┇ للاداريين فقط 👮‍♀️" end
local usersudo = string.gsub(_config.sudouser, '@', '')
keyboard = {}
keyboard.inline_keyboard = {
{
{text= '  • تحدث مع المطور • ' ,url = 'https://t.me/'..usersudo} -- هنا خلي معرفك انته كمطور
}					
}
tkey = [[
👨‍✈️┇مرحبا عزيزي اوامر اضافيه👇🏿 
⚜┇ﮧ➖⚜➖⚜➖⚜➖⚜
🔖┇ معلوماتك الشخصيه 👨‍🎤
🔖┇ اسمي ✧ لعرض اسمك 🥀
🔖┇ رتبتي ✧ لعرض رتبتك 🥀
🔖┇ الرتبه ✧ لعرض الرتبه 🥀
🔖┇ معرفي ✧ لعرض معرفك 🥀
🔖┇ ايديي ✧ لعرض ايديك 🥀
🔖┇ رقمي ✧ لعرض رقمك  🥀
⚜┇ﮧ➖⚜➖⚜➖⚜➖⚜
👨‍🔧┇ اوامر التحشيش 👇🏿
⚜┇ﮧ➖⚜➖⚜➖⚜➖⚜
🔖┇ تحب + (اسم الشخص)
🔖┇ بوس + (اسم الشخص) 
🔖┇ كول + (اسم الشخص) 
🔖┇ كله + الرد + (الكلام) 
⚜┇ﮧ➖⚜➖⚜➖⚜➖⚜
👨‍✈️┇اضغط للتحدث مع المطور 👇🏿
]]
send_key(msg.chat.id, tkey, keyboard, msg.message_id, "html")
end
if matches[1]== "م المطور" then
if not is_sudo(msg) then return "🔖 ┇ للمطوين فقط 👮‍♀️" end
local usersudo = string.gsub(_config.sudouser, '@', '')
keyboard = {}
keyboard.inline_keyboard = {
{
{text= '  • تحدث مع المطور • ' ,url = 'https://t.me/'..usersudo} -- هنا خلي معرفك انته كمطور
}					
}
tkey = [[
👨‍✈️┇مرحبا مطوري اوامرك 👇🏿
⚜┇ﮧ➖⚜➖⚜➖⚜➖⚜
🔖┇ تفعيل  ≫ لتفعيل البوت 
🔖┇ تعطيل ≫ لتعطيل البوت
 🔖┇ الاشتراك 1 ≫ لتفعيل البوت 1 شهر
🔖┇ الاشتراك 2 ≫ لتفعيل البوت 3 اشهر 
🔖┇ الاشتراك 3 ≫ لتفعيل البوت مدى الحياه
🔖┇ اذاعه ≫ لنشر في كل الكروبات
🔖┇اسم البوت + غادر ≫ لطرد البوت
🔖┇ مسح الادمنيه ≫ لمسح الادمنيه 
🔖┇ مسح الاداريين≫ لمسح الاداريين 
🔖┇ تحديث ≫ لتحديث الملفات 
🔖┇اوامر الملفات ≫لعرض الاوامر
🔖┇ﮧ➖⚜➖⚜➖⚜➖⚜
👨‍✈️┇ اضغط للتحدث مع المطور
]]
send_key(msg.chat.id, tkey, keyboard, msg.message_id, "html")
end
if matches[1]== 'م5' then
if not is_owner(msg) then return "🔖 ┇ للمدراء فقط 👮‍♀️" end
local usersudo = string.gsub(_config.sudouser, '@', '')
keyboard = {}
keyboard.inline_keyboard = {
{
{text= '  • تحدث مع المطور • ' ,url = 'https://t.me/'..usersudo} -- هنا خلي معرفك انته كمطور
}					
}
tkey = [[
👨‍✈️┇ مرحبا عزيزي اوامر الردود 👇🏿
⚜┇ﮧ➖⚜➖⚜➖⚜➖⚜
🔖┇ الردود ✧ لعرض الردود المثبته
🔖┇ رد اضف + الرد ✧ أضافةرد جديد
🔖┇ رد مسح  + الرد ✧ المراد مسحه
🔖┇ رد مسح الكل ✧ لمسح الكل
⚜┇ﮧ➖⚜➖⚜➖⚜➖⚜
👨‍✈️┇ اضغط للتحدث مع المطور 👇🏿
]]
send_key(msg.chat.id, tkey, keyboard, msg.message_id, "html")
end
if matches[1]== "م6" then
if not is_mod(msg) then return "🔖 ┇ للاداريين فقط 👮‍♀️" end
local usersudo = string.gsub(_config.sudouser, '@', '')
keyboard = {}
keyboard.inline_keyboard = {
{
{text= '  • تحدث مع المطور • ' ,url = 'https://t.me/'..usersudo} -- هنا خلي معرفك انته كمطور
}					
}
tkey = [[
👨‍✈️┇مرحبا عزيزي اوامر زخرفه👇🏿
⚜┇ﮧ➖⚜➖⚜➖⚜➖⚜
🔖┇زخرف+الكلمه لزخرفه بالانكلش
🔖┇زخرفه+الكلمه لزخرفه بالعربي 
⚜┇ﮧ ➖⚜➖⚜➖⚜➖⚜
👨‍✈️┇اضغط للتحدث مع المطور 👇🏿
]]
send_key(msg.chat.id, tkey, keyboard, msg.message_id, "html")
end
if matches[1]== "اوامر الملفات" then
if not is_sudo(msg) then return "🔖 ┇ للمطوين فقط 👮‍♀️" end
local usersudo = string.gsub(_config.sudouser, '@', '')
keyboard = {}
keyboard.inline_keyboard = {
{
{text= '  • تحدث مع المطور • ' ,url = 'https://t.me/'..usersudo} -- هنا خلي معرفك انته كمطور
}					
}
tkey = [[
👨‍✈️┇ HELLO YOU SUDO MY 🥀
⚜┇➖⚜➖⚜➖⚜➖⚜
🔖┇ /p | لعرض قائمه الملفات 
🔖┇ /p + اسم الملف المراد تفعيله 
🔖┇ /p - اسم الملف المراد تعطيله 
🔖┇ sp + الاسم | لارسال الملف اليك 
🔖┇ dp + اسم الملف المراد حذفه 
🔖┇ sp all | لارسالك كل ملفات
⚜┇ﮧ ➖⚜➖⚜➖⚜➖⚜
👨‍✈️┇اضغط للتحدث مع المطور 👇🏿
]]
send_key(msg.chat.id, tkey, keyboard, msg.message_id, "html")
end
if matches[1]=="المطور" then
local usersudo = string.gsub(_config.sudouser, '@', '')
keyboard = {}
keyboard.inline_keyboard = {
{
{text= '  • تحدث مع المطور • ' ,url = 'https://t.me/'..usersudo} -- هنا خلي معرفك انته كمطور
}					
}
tkey = [[🔖┇ ᗯEᒪᑕOᗰE ᗰY ᗪEᗩᖇ

●-•-•-•-•-•-○-•-•-•-•-•-●

🔖┇ SᑌᗪO ↭ @TH3BOSS

🔖┇ Tᗯᔕ ↭ @TH3BOSSBOT

🔖┇ TH3BOSS ↭ Final Version 21

●-•-•-•-•-•-○-•-•-•-•-•-●

🔖┇ ᑕᕼ ↭ @llDEV1ll ]]
send_key(msg.chat.id, tkey, keyboard, msg.message_id, "html")
end
if matches[1]=="start" then
local usersudo = string.gsub(_config.sudouser, '@', '')
keyboard = {}
keyboard.inline_keyboard = {
{
{text= '  • تحدث مع المطور • ' ,url = 'https://t.me/'..usersudo} -- هنا خلي معرفك انته كمطور
}					
}
tkey = [[🔖┇ مرحبا انا بوت اسمي ]].._config.botname..[[ 🎖
🔖┇ اقوم بحمايه المجموعات حتى 20k 
🔖┇ المطور فقط يستطيع تفعيلي في المجموعات ⇩⇩
🔖┇ او اترك رسالتك هنا وسوف يرد عليك المطور ]]
send_key(msg.chat.id, tkey, keyboard, msg.message_id, "html")
end

if matches[1]=="رتبتي" and not matches[2] then
if is_sudo(msg) then
rank = 'المطور مالتي 😻'
elseif is_owner(msg) and msg.to.type ~= 'private'  then
rank = 'مدير المجموعه 😽'
elseif is_mod(msg) and msg.to.type ~= 'private'  then
rank = ' ادمن في البوت 😺'
elseif  is_whitelist(msg.from.id, msg.to.id) and msg.to.type ~= 'private' then
rank = 'عضو مميز 🎖'
else
if msg.to.type ~= 'private' then
rank = 'مجرد عضو 😹'
else
rank = 'لست مطور في السورس ✖️'
end
end
return '🔖┇ رتبتك : '..rank
end

if matches[1]=="الرتبه" and not matches[2] and is_owner(msg) and not  msg.to.type ~= 'private' then
if msg.reply_id then
if msg.reply.id == our_id  then
rank = 'هذا البوت 🙄☝🏿'
elseif msg.reply.id == msg.from.id  then
rank = 'انته المطور 👨🏼‍🔧'
elseif is_sudo1(msg.reply.id) then
rank = 'المطور هذا 😻'
elseif is_owner1( msg.to.id,msg.reply.id) then
rank = 'مدير المجموعه 😽'
elseif is_mod1( msg.to.id,msg.reply.id) then
rank = ' ادمن في البوت 😺'
elseif is_whitelist(msg.reply.id, msg.to.id)  then
rank = 'عضو مميز 🎖'
else
rank = 'مجرد عضو 😹'
end
if msg.reply.username then usernamrxx = "@"..msg.reply.username else usernamrxx = " لا يوجد 📛" end
local rtba = '🔖┇ الاسم : '..msg.reply.first_name..'\n🔖┇ المعرف : '..usernamrxx..' \n🔖┇ الايدي : '..msg.reply.id..' \n🔖┇ الرتبه : '..rank
send_msg(msg.to.id,rtba , msg.id)
else
return "📌 سوي رد للعضو حته اكلك شنو رتبته🕵🏻"
end
end

end
return {
  patterns = {
    "^(م المطور)$", 
    "^[/](start)$", 
    "^(م5)$", 
    "^(الاوامر)$", 
    "^(م1)$", 
    "^(م2)$", 
    "^(م3)$", 
    "^(م4)$", 
    "^(م6)$", 
    "^(اوامر الملفات)$", 
    "^(معلوماتي)$",
    "^(موقعي)$",
    "^(رفع مطور)$",
    "^(تنزيل مطور)$",
    "^(رفع مطور) (%d+)$",
    "^(تنزيل مطور) (%d+)$",
    "^(رفع مطور) (@[%a%d%_]+)$",
    "^(تنزيل مطور) (@[%a%d%_]+)$",
    "^(المطورين)$",
    "^(المجموعات)$",
    "^(الاشتراك)$",
    "^(الاشتراك) ([123])$",
    "^(مواليدي) (.+)/(.+)/(.+)",
    "^(شحن) (%d+)$",
    "^(اذاعه) (.*)$",
    "^(الخروج التلقائي)$",
    "^(تفعيل) (.*)$",
    "^(تعطيل) (.*)$",
    "^(المطور)$",
    "^(رتبتي)$",
    "^(الرتبه)$",
    "^(السورس)$",
    },
  run = run,
  pre_process = pre_process
}
