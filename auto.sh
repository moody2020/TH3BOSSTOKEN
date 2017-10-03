
red() {
  printf '\e[1;31m%s\n\e[0;39;49m' "$@"
}
green() {
  printf '\e[1;32m%s\n\e[0;39;49m' "$@"
}
white() {
  printf '\e[1;37m%s\n\e[0;39;49m' "$@"
}
update() {
	git pull
}

	green " جاري تشغيل سورس الــزعــيــم تــوكــن في وضعيه التشغيل التلقائي  ..."
	while true; do
lua ./bot/bot.lua
	red 'حدث خطا في الــزعــيــم تــوكــن سوف يتم تشغيل البوت بعد ثواني'
sleep 9s
done
