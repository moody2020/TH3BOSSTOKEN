
local function moody(msg, matches)
local data = load_data(_config.moderation.data)
 if not data[tostring(msg.to.id)] then return end

----------------kick by replay ----------------
if matches[1] == 'طرد' and is_mod(msg) then
   if msg.reply_id and not matches[2] then
if tonumber(msg.reply.id) == tonumber(our_id) then
   return "🔖┇ عـذرا لا اسـتـطـيـع طـرد نـفـسـي ⚠️"
   end
if is_mod1(msg.to.id, msg.reply.id) then
return "🔖┇ عـذرا لا اسـتـطـيـع طـرد الـمـدراء او الادمـنـيـه ⚠️" 
   else
	kick_user(msg.reply.id, msg.to.id) 
    return "🔖┇ الـعـضـو  : "..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).."\n🔖┇ الايـدي :  ["..msg.reply.id.."]\n🔖┇ تـم طـرده  ☑️┇🔒 "
 end
	elseif matches[2] and string.match(matches[2], '@[%a%d_]')  then
   if not resolve_username(matches[2]).result then
   return "🔖┇   الـعـضـو  غـيـر مـوجـود ⚠️"
   end
	local User = resolve_username(matches[2]).information
if tonumber(User.id) == tonumber(our_id) then
   return "🔖┇ عـذرا لا اسـتـطـيـع طـرد نـفـسـي ⚠️"
    end
if is_mod1(msg.to.id, User.id) then
return "🔖┇ عـذرا لا اسـتـطـيـع طـرد الـمـدراء او الادمـنـيـه ⚠️"
     else
	kick_user(User.id, msg.to.id) 
return "🔖┇ الـعـضـو  : "..check_markdown(matches[2]).."\n🗯┇ الايـدي :  ["..User.id.."]\n🗯┇ تـم طـرده  ☑️┇🔒 "
  end
   elseif matches[2] and string.match(matches[2], '^%d+$') then
if tonumber(matches[2]) == tonumber(our_id) then
   return "🔖┇ عـذرا لا اسـتـطـيـع طـرد نـفـسـي ⚠️"
    end
if is_mod1(msg.to.id, tonumber(matches[2])) then
return "🔖┇ عـذرا لا اسـتـطـيـع طـرد الـمـدراء او الادمـنـيـه ⚠️"   
else
kick_user(tonumber(matches[2]), msg.to.id) 
return "🔖┇ الايـدي :  ["..check_markdown(matches[2]).."]\n🔖┇ تـم طـرده  ☑️┇🔒 "
end
end
end 

---------------Ban-------------------      

if matches[1] == 'حظر' and is_mod(msg) then
if msg.reply_id and not matches[2] then
if tonumber(msg.reply.id) == tonumber(our_id) then
   return "🔖┇ عـذرا لا اسـتـطـيـع حـظـر نـفـسـي ⚠️"
    end
if is_mod1(msg.to.id, msg.reply.id) then
return "🔖┇ عـذرا لا اسـتـطـيـع حـظـر الـمـدراء او الادمـنـيـه ⚠️"   
    end
  if is_banned(msg.reply.id, msg.to.id) then
    return "🔖┇ الـعـضـو  : "..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).."\n🔖┇ الايـدي :  ["..msg.reply.id.."]\n🔖┇ انـه بـالـتـأكـيـد تـم حـظـره  ☑️┇🔒 "
    else
ban_user(("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)), msg.reply.id, msg.to.id)
kick_user(msg.reply.id, msg.to.id) 
return "🔖┇ الـعـضـو  : "..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).."\n🔖┇ الايـدي :  ["..msg.reply.id.."]\n🔖┇ تـم حـظـره   ☑️┇🔒 "
  end
	elseif matches[2] and string.match(matches[2], '@[%a%d_]') then
   if not resolve_username(matches[2]).result then
   return "🔖┇   الـعـضـو  غـيـر مـوجـود ⚠️" 
   end
	local User = resolve_username(matches[2]).information
if tonumber(User.id) == tonumber(our_id) then
   return "🔖┇ عـذرا لا اسـتـطـيـع حـظـر نـفـسـي ⚠️"
    end
if is_mod1(msg.to.id, User.id) then
return "🔖┇ عـذرا لا اسـتـطـيـع حـظـر الـمـدراء او الادمـنـيـه ⚠️"   
    end
  if is_banned(User.id, msg.to.id) then
    return "🔖┇ الـعـضـو  : @"..check_markdown(User.username).."\n🔖┇ الايـدي :  "..User.id.." \n🔖┇ انـه بـالـتـأكـيـد تـم حـظـره  ☑️┇🔒 "
    else
   ban_user(check_markdown(User.username), User.id, msg.to.id)
     kick_user(User.id, msg.to.id) 
return "🔖┇ الـعـضـو  : @"..check_markdown(User.username).."\n🔖┇ الايـدي :  "..User.id.." \n🔖┇ انـه بـالـتـأكـيـد تـم حـظـره  ☑️┇🔒 "
  end
   elseif matches[2] and string.match(matches[2], '^%d+$') then
if tonumber(matches[2]) == tonumber(our_id) then
   return "🔖┇ عـذرا لا اسـتـطـيـع حـظـر نـفـسـي ⚠️"
    end
if is_mod1(msg.to.id, tonumber(matches[2])) then
return "🔖┇ عـذرا لا اسـتـطـيـع حـظـر الـمـدراء او الادمـنـيـه ⚠️"   
    end
  if is_banned(tonumber(matches[2]), msg.to.id) then
    return "🔖┇ الـعـضـو  :   : "..matches[2].."\n 🔖┇ انـه بـالـتـأكـيـد تـم حـظـره  ☑️┇🔒 "
    else
   ban_user('', matches[2], msg.to.id)
     kick_user(tonumber(matches[2]), msg.to.id)
    return "🔖┇ الـعـضـو  :   : "..matches[2].." \n🔖┇ تـم حـظـره   ☑️┇🔒 "
        end
     end
   end

---------------Unban-------------------                         

if matches[1] == 'الغاء الحظر' and is_mod(msg) then
if msg.reply_id and not matches[2] then
if tonumber(msg.reply.id) == tonumber(our_id) then
   return "🔖┇ عـذرا لا اسـتـطـيـع كـتــم نـفـسـي ⚠️"
    end
if is_mod1(msg.to.id, msg.reply.id) then
return "🔖┇ عـذرا لا اسـتـطـيـع حـظـر الـمـدراء او الادمـنـيـه ⚠️"   
    end
  if not is_banned(msg.reply.id, msg.to.id) then
    return "🔖┇ الـعـضـو  : "..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).." \n🔖┇ الايـدي :  "..msg.reply.id.." \n🔖┇انـه بـالـتـأكـيـد تـم الـغـاء حـظـره  ☑️┇🔓 "
    else
unban_user(msg.reply.id, msg.to.id)
    return "🔖┇ الـعـضـو  : "..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).." \n🔖┇ الايـدي :  "..msg.reply.id.." \n🔖┇  تـم الـغـاء حـظـره  ☑️┇🔓 "
  end
	elseif matches[2] and string.match(matches[2], '@[%a%d_]')  then
   if not resolve_username(matches[2]).result then
   return "🔖┇   الـعـضـو  غـيـر مـوجـود ⚠️"    end
	local User = resolve_username(matches[2]).information
  if not is_banned(User.id, msg.to.id) then
    return "🔖┇ الـعـضـو  : @"..check_markdown(User.username).."\n🔖┇ الايـدي :  "..User.id.." \n🔖┇انـه بـالـتـأكـيـد تـم الـغـاء حـظـره  ☑️┇🔓 "
    else
   unban_user(User.id, msg.to.id)
    return "🔖┇ الـعـضـو  : @"..check_markdown(User.username).." \n🔖┇ الايـدي :  "..User.id.." \n🔖┇  تـم الـغـاء حـظـره  ☑️┇🔓 "
  end
   elseif matches[2] and string.match(matches[2], '^%d+$') then
  if not is_banned(tonumber(matches[2]), msg.to.id) then
    return "🔖┇ الـعـضـو  : "..matches[2].." \n🔖┇انـه بـالـتـأكـيـد تـم الـغـاء حـظـره  ☑️┇🔓  "
    else
   unban_user(matches[2], msg.to.id)
    return "🔖┇ الـعـضـو  : "..matches[2].." \n🔖┇ تـم الـغـاء حـظـره  ☑️┇🔓  "
        end
     end
   end

------------------------Silent-------------------------------------

if matches[1] == 'كتم' and is_mod(msg) then
if msg.reply_id and not matches[2] then
if tonumber(msg.reply.id) == tonumber(our_id) then
   return "🔖┇ عـذرا لا اسـتـطـيـع كـتــم نـفـسـي ⚠️"
    end
if is_mod1(msg.to.id, msg.reply.id) then
   return "🔖┇ عذرا لا استطيع  كتم المدراء او الادمنيه "
    end
  if is_silent_user(msg.reply.id, msg.to.id) then
    return "🔖┇ الـعـضـو  : "..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).."\n🔖┇ الايـدي :  ["..msg.reply.id.."]\n🔖┇ انـه بـالـتـأكـيـد تـم كـتـمـه  ☑️┇🔒 "
    else
silent_user(("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)), msg.reply.id, msg.to.id)
    return "🔖┇ الـعـضـو  : "..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).."\n🔖┇ الايـدي :  ["..msg.reply.id.."]\n🔖┇ تـم كـتـمـه  ☑️┇🔒 "
  end
	elseif matches[2] and string.match(matches[2], '@[%a%d_]')  then
   if not resolve_username(matches[2]).result then
   return "🔖┇   الـعـضـو  غـيـر مـوجـود ⚠️"    end
	local User = resolve_username(matches[2]).information
if tonumber(User.id) == tonumber(our_id) then
   return "🔖┇ عـذرا لا اسـتـطـيـع كـتــم نـفـسـي ⚠️"
    end
if is_mod1(msg.to.id, User.id) then
   return "🔖┇ عذرا لا استطيع  كتم المدراء او الادمنيه "
    end
  if is_silent_user(User.id, msg.to.id) then
    return "🔖┇ الـعـضـو  : @"..check_markdown(User.username).."\n🔖┇ الايـدي :  "..User.id.." \n🔖┇ انـه بـالـتـأكـيـد تـم كـتـمـه  ☑️┇🔒 "
    else
   silent_user("@"..check_markdown(User.username), User.id, msg.to.id)
return "🔖┇ الـعـضـو  : @"..check_markdown(User.username).."\n🔖┇ الايـدي :  "..User.id.." \n🔖┇ انـه بـالـتـأكـيـد تـم كـتـمـه  ☑️┇🔒 "
  end
   elseif matches[2] and string.match(matches[2], '^%d+$') then
if tonumber(matches[2]) == tonumber(our_id) then
   return "🔖┇ عـذرا لا اسـتـطـيـع كـتــم نـفـسـي ⚠️"
    end
if is_mod1(msg.to.id, tonumber(matches[2])) then
   return "🔖┇ عذرا لا استطيع  كتم المدراء او الادمنيه "
    end
  if is_silent_user(tonumber(matches[2]), msg.to.id) then
    return "🔖┇ الـعـضـو  :   : "..matches[2].."\n 🔖┇ انـه بـالـتـأكـيـد تـم كـتـمـه  ☑️┇🔒 "
    else
   ban_user('', matches[2], msg.to.id)
     kick_user(tonumber(matches[2]), msg.to.id)
    return "🔖┇ الـعـضـو  :   : "..matches[2].." \n🔖┇  تم  كتمه  ☑️┇🔒"
        end
     end
   end

------------------------Unsilent----------------------------
if matches[1] == 'الغاء الكتم' and is_mod(msg) then
if msg.reply_id and not matches[2] then
if tonumber(msg.reply.id) == tonumber(our_id) then
   return "🔖┇ عـذرا لا اسـتـطـيـع كـتــم نـفـسـي ⚠️"
    end
if is_mod1(msg.to.id, msg.reply.id) then
return "🔖┇ عـذرا لا اسـتـطـيـع حـظـر الـمـدراء او الادمـنـيـه ⚠️"   
    end
  if not is_silent_user(msg.reply.id, msg.to.id) then
    return "🔖┇ الـعـضـو  : "..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).." \n🔖┇ الايـدي :  "..msg.reply.id.." \n🔖┇انـه بـالـتـأكـيـد تـم الـغـاء كـتـمـه  ☑️┇🔓"
    else
unsilent_user(msg.reply.id, msg.to.id)
    return "🔖┇ الـعـضـو  : "..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).." \n🔖┇ الايـدي :  "..msg.reply.id.." \n🔖┇  تـم الـغـاء كـتـمـه  ☑️┇🔓"
  end
	elseif matches[2] and string.match(matches[2], '@[%a%d_]')  then
   if not resolve_username(matches[2]).result then
   return "🔖┇   الـعـضـو  غـيـر مـوجـود ⚠️"    end
	local User = resolve_username(matches[2]).information
  if not is_silent_user(User.id, msg.to.id) then
    return "🔖┇ الـعـضـو  : @"..check_markdown(User.username).."\n🔖┇ الايـدي :  "..User.id.." \n🔖┇انـه بـالـتـأكـيـد تـم الـغـاء كـتـمـه  ☑️┇🔓"
    else
   unsilent_user(User.id, msg.to.id)
    return "🔖┇ الـعـضـو  : @"..check_markdown(User.username).." \n🔖┇ الايـدي :  "..User.id.." \n🔖┇  تـم الـغـاء كـتـمـه  ☑️┇🔓"
  end
   elseif matches[2] and string.match(matches[2], '^%d+$') then
  if not is_silent_user(tonumber(matches[2]), msg.to.id) then
    return "🔖┇ الـعـضـو  : "..matches[2].." \n🔖┇انـه بـالـتـأكـيـد تـم الـغـاء كـتـمـه  ☑️┇🔓 "
    else
   unsilent_user(matches[2], msg.to.id)
    return "🔖┇ الـعـضـو  : "..matches[2].." \n🔖┇ تـم الـغـاء كـتـمـه  ☑️┇🔓 "
        end
     end
   end
-------------------------Banall-------------------------------------
                   
if matches[1] == 'حظر عام' and is_sudo(msg) then
if msg.reply_id and not matches[2] then
if tonumber(msg.reply.id) == tonumber(our_id) then
return "🔖┇ عذرا لا استطيع حظر عـام لنفسي ⚠️"
end

  if is_gbanned(msg.reply.id) then
    return "🔖┇ الـعـضـو  : "..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).."\n🔖┇ الايـدي :  ["..msg.reply.id.."]\n🔖┇ انـه بـالـتـأكـيـد تـم حـظـره عـام   ☑️┇🔒"
    else
banall_user(("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)), msg.reply.id)
     kick_user(msg.reply.id, msg.to.id) 
    return "🔖┇ الـعـضـو  : "..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).."\n🔖┇ الايـدي :  ["..msg.reply.id.."]\n🔖┇ تـم حـظـره عـام   ☑️┇🔒 "
  end

elseif matches[2] and string.match(matches[2], '@[%a%d_]')  then
   if not resolve_username(matches[2]).result then
return "🔖┇   الـعـضـو  غـيـر مـوجـود ⚠️" 
  end
	local User = resolve_username(matches[2]).information
if tonumber(User.id) == tonumber(our_id) then
   return "🔖┇ عذرا لا استطيع حظر عـام لنفسي ⚠️"
    end
  if is_gbanned(User.id) then
    return "🔖┇ الـعـضـو  : @"..check_markdown(User.username).."\n🔖┇ الايـدي :  "..User.id.." \n🔖┇ انـه بـالـتـأكـيـد تـم حـظـره عـام   ☑️┇🔒"
    else
   banall_user("@"..check_markdown(User.username), User.id)
     kick_user(User.id, msg.to.id) 
return "🔖┇ الـعـضـو  : @"..check_markdown(User.username).."\n🔖┇ الايـدي :  "..User.id.." \n🔖┇ تـم حـظـره عـام   ☑️┇🔒 "
  end
   elseif matches[2] and string.match(matches[2], '^%d+$') then
if tonumber(matches[2]) == tonumber(our_id) then
   return "🔖┇ عذرا لا استطيع حظر عـام لنفسي ⚠️"
    end
  if is_gbanned(tonumber(matches[2])) then
    return "🔖┇ الـعـضـو  :   : "..matches[2].."\n 🔖┇ انـه بـالـتـأكـيـد تـم حـظـره عـام   ☑️┇🔒"
    else
   banall_user('', matches[2])
     kick_user(tonumber(matches[2]), msg.to.id)
    return "🔖┇ الـعـضـو  :   : "..matches[2].." \n🔖┇  تم  حظره عـام  ☑️┇🔒  "
        end
     end
   end
--------------------------Unbanall-------------------------

if matches[1] == 'الغاء العام' and is_sudo(msg) then
if msg.reply_id and not matches[2] then
if tonumber(msg.reply.id) == tonumber(our_id) then
   return "🔖┇ عذرا لا استطيع حظر  نفسي ⚠️"
    end
if is_mod1(msg.to.id, msg.reply.id) then
return "🔖┇ عـذرا لا اسـتـطـيـع حـظـر الـمـدراء او الادمـنـيـه ⚠️"   
    end
  if not is_gbanned(msg.reply.id) then
    return "🔖┇ الـعـضـو  : "..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).." \n🔖┇ الايـدي :  "..msg.reply.id.." \n🔖┇انـه بـالـتـأكـيـد تـم الـغـاء حـظـره الـعـام  ☑️┇🔓"
    else
unbanall_user(msg.reply.id)
    return "🔖┇ الـعـضـو  : "..("@"..check_markdown(msg.reply.username) or escape_markdown(msg.reply.print_name)).." \n🔖┇ الايـدي :  "..msg.reply.id.." \n🔖┇ تـم الـغـاء حـظـره الـعـام   ☑️┇🔓 "
  end
	elseif matches[2] and string.match(matches[2], '@[%a%d_]')  then
   if not resolve_username(matches[2]).result then
   return "🔖┇   الـعـضـو  غـيـر مـوجـود ⚠️"   
   end
	local User = resolve_username(matches[2]).information
  if not is_gbanned(User.id) then
    return "🔖┇ الـعـضـو  : @"..check_markdown(User.username).."\n🔖┇ الايـدي :  "..User.id.." \n🔖┇ انه بالتاكيد تم الغاء  حظره عـام  ☑️┇🔒  "
    else
   unbanall_user(User.id)
    return "🔖┇ الـعـضـو  : @"..check_markdown(User.username).." \n🔖┇ الايـدي :  "..User.id.." \n🔖┇ تـم الـغـاء حـظـره الـعـام   ☑️┇🔓 "
  end
   elseif matches[2] and string.match(matches[2], '^%d+$') then
  if not is_gbanned(tonumber(matches[2])) then
    return "🔖┇ الـعـضـو  : "..matches[2].." \n🔖┇انـه بـالـتـأكـيـد تـم الـغـاء حـظـره الـعـام  ☑️┇🔓 "
    else
   unbanall_user(matches[2])
    return "🔖┇ الـعـضـو  : "..matches[2].." \n🔖┇ تـم الـغـاء حـظـره الـعـام   ☑️┇🔓 "
        end
     end
   end
   -----------------------------------LIST---------------------------
   if matches[1] == 'المحظورين' and is_mod(msg) then
   return banned_list(msg.to.id)
   end
   if matches[1] == 'المكتومين' and is_mod(msg) then
   return silent_users_list(msg.to.id)
   end
   if matches[1] == 'قائمه العام' and is_mod(msg) then
   return gbanned_list(msg)
   end
   -----------
   if matches[1] == "مسح" and not matches[2] and msg.reply_id and is_mod(msg) then
del_msg(msg.to.id, msg.reply_id)
del_msg(msg.to.id, msg.id)
end
if matches[1] == 'مسح' and matches[2] and string.match(matches[2], '^%d+$') and is_mod(msg) then
local num = matches[2]
if 100 < tonumber(num) then
return "🔖┇_حدود المسح ,  يجب ان تكون ما بين _ *[2-100]*"
end
print("🗑¦ تم مسح ["..num.."] رسالة  👮‍♀️")
for i=1,tonumber(num) do
del_msg(msg.to.id,msg.id - i)
end
return"🗑¦ تم مسح `"..num.."` رسالة  👮‍♀️"
end
   ---------------------------clean---------------------------
   if matches[1] == 'مسح' and is_mod(msg) then
       
	if matches[2] == 'المحظورين' then
		if next(data[tostring(msg.to.id)]['banned']) == nil then
   return "🔖┇ عـذرا لا يـوجـد مـسـتـخـدمـيـن مـحـظـوريـن فـي هـذه الـمـجـمـوعـه ⚠️"
		end
		for k,v in pairs(data[tostring(msg.to.id)]['banned']) do
			data[tostring(msg.to.id)]['banned'][tostring(k)] = nil
			save_data(_config.moderation.data, data)
		end
		return "🔖┇ تـم مـسـح جـمـيـع الاعـضـاء الـمـحـظـوريـن فـي هـذ الـمـجــوعـه"
		end
	
	if matches[2] == 'المكتومين' then
		if next(data[tostring(msg.to.id)]['is_silent_users']) == nil then
   return "🔖┇ عـذرا لا يـوجـد مـسـتـخـدمـيـن مـكـتـومـيـن فـي هـذه الـمـجـمـوعـه ⚠️"
		end
		for k,v in pairs(data[tostring(msg.to.id)]['is_silent_users']) do
			data[tostring(msg.to.id)]['is_silent_users'][tostring(k)] = nil
			save_data(_config.moderation.data, data)
		end
		return "🔖┇ تـم مـسـح جـمـيـع الاعـضـاء الـمـكـتـومـيـن فـي هـذه الـمـجــوعـه"
		end
	
	if matches[2] == 'قائمه العام' and is_mod(msg) then
	if next(data['gban_users']) == nil then
   return "🔖┇ عـذرا لا يـوجـد مـسـتـخـدمـيـن مـحـظـوريـن  عـام فـي هـذه الـمـجـمـوعـه ⚠️"
		end
		for k,v in pairs(data['gban_users']) do
			data['gban_users'][tostring(k)] = nil
			save_data(_config.moderation.data, data)
		end
		return "🔖┇ تـم مـسـح جـمـيـع الاعـضـاء الـمـحـظـوريـن عـام فـي هـذ الـمـجــوعـه"
		end
   end

end
return {
			patterns = {
"^(حظر عام) (.*)$", 
"^(حظر عام)$",
"^(الغاء العام) (.*)$", 
"^(الغاء العام)$",
"^(حظر) (@[%a%d%_]+)$",
"^(حظر) (%d+)$",
"^(حظر)$",
"^(الغاء الحظر) (@[%a%d%_]+)$",
"^(الغاء الحظر) (%d+)$",
"^(الغاء الحظر)$",
"^(طرد) (@[%a%d%_]+)$",
"^(طرد) (%d+)$",
"^(طرد)$",
"^(كتم) (@[%a%d%_]+)$",
"^(كتم) (%d+)$",
"^(كتم)$",
"^(الغاء الكتم) (@[%a%d%_]+)$",
"^(الغاء الكتم) (%d+)$",
"^(الغاء الكتم)$",
"^(المحظورين)$",
"^(قائمه العام)$",
"^(المكتومين)$",
"^(مسح)$",
"^(مسح) (.*)$",
	},
	run = moody,

}