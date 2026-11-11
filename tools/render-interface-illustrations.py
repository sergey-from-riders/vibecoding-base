"""Render synthetic handbook diagrams; no customer images or screenshots are used.
Requires Pillow and DejaVu Sans. Run from any directory. Output: six WebP assets.
"""
from pathlib import Path
from PIL import Image, ImageDraw, ImageFont
ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'registry/standards/ui/admin-interface/assets'
OUT.mkdir(parents=True,exist_ok=True)
FONT='/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf'
BOLD='/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf'
def font(n=20,b=False):return ImageFont.truetype(BOLD if b else FONT,n)
def render(kind,good):
 im=Image.new('RGB',(1200,840),'#f3f6f4');d=ImageDraw.Draw(im)
 green='#147d50';red='#b34949';ink='#1c3027';muted='#62736a';border='#dce5df'
 def box(x,y,w,h,fill='white',outline=None,r=12):d.rounded_rectangle((x,y,x+w,y+h),radius=r,fill=fill,outline=outline)
 def txt(x,y,s,n=20,c=ink,b=False):d.text((x,y),s,font=font(n,b),fill=c)
 def button(x,y,s,w=175,primary=False):box(x,y,w,43,green if primary else '#eef3ef');txt(x+14,y+10,s,16,'white' if primary else ink,True)
 def photo(x,y,w,h,label=None):
  box(x,y,w,h,'#c6dfdb');d.polygon([(x+4,y+h-4),(x+w*.4,y+h*.2),(x+w*.7,y+h-4)],fill='#7fa69a');d.polygon([(x+w*.32,y+h-4),(x+w*.72,y+h*.32),(x+w-4,y+h-4)],fill='#4f8270')
  if label:box(x+w-40,y+h-25,36,21,'#203e32',r=5);txt(x+w-34,y+h-23,label,13,'white',True)
 accent=green if good else red
 box(0,0,1200,76,'#18392c',r=0);txt(32,20,'УЧЕБНАЯ АДМИНКА',25,'white',True);txt(825,27,'Редактор · вымышленные данные',15,'#d4e4da')
 box(30,99,1140,60,'#e0f0e7' if good else '#f5e6e6');txt(50,116,'ХОРОШО' if good else 'ПЛОХО',22,accent,True)
 titles={'table':'Таблица: найти, сравнить, выбрать','editor':'Запись: изменить, проверить, опубликовать','media':'Медиа: добавить, упорядочить, подписать'}
 txt(50,182,titles[kind],27,b=True)
 if kind=='table':
  if good:
   box(50,235,790,49,outline=border);txt(67,249,'Туры на Камчатку до 50 000 ₽',18);button(860,238,'Столбцы · 5 из 28',260)
   box(50,306,1070,46,'#e8eee9');txt(68,318,'☑',20);txt(112,318,'Тур',18,b=True);txt(620,318,'Цена ↑',18,b=True);txt(820,318,'Статус',18,b=True)
   for i,(name,price) in enumerate([('Маршрут у вулкана','35 000 ₽'),('Побережье и тропы','42 000 ₽'),('Озёра полуострова','49 000 ₽'),('Прогулка по долине','50 000 ₽')]):
    y=352+i*74;box(50,y,1070,72,'#e7f4ed' if i<2 else 'white',r=0);txt(68,y+24,'☑' if i<2 else '□',20,green);photo(112,y+12,50,50,'+4');txt(178,y+25,name,19);txt(620,y+25,price,19);txt(820,y+25,'Активен',17,green)
   txt(50,671,'Загружено 50 из 240 · следующая порция при прокрутке',17,muted)
   box(50,720,1070,68,'#18392c');txt(70,742,'Выбрано 2',20,'white',True);button(440,732,'Изменить статус',205);button(660,732,'Снять выбор',180)
  else:
   for i,s in enumerate(['Регион: выбрать','Цена от: …','Цена до: …','Статус: …']):box(50+i*268,235,248,65,outline=border);txt(63+i*268,257,s,17)
   txt(50,327,'Все свойства · порядок столбцов изменить нельзя',17,red)
   for i,name in enumerate(['Маршрут у вулкана','Побережье и тропы','Озёра полуострова']):
    y=367+i*120;box(50,y,1070,108)
    for j in range(3):photo(65+j*84,y+16,75,75)
    txt(330,y+23,name,18);txt(330,y+57,'Цена внутри карточки',16,muted);button(740,y+32,'Открыть',130);button(884,y+32,'Удалить',130)
   txt(50,759,'Большие фото · нет выбора диапазона · действия в каждой строке',17,red)
 elif kind=='editor':
  if good:
   box(50,235,1070,66,'#fff5d7');txt(70,250,'Черновик сохранён · 2 изменения',20,b=True);txt(70,278,'Редактор А · сегодня, 14:20',14,muted)
   for i,s in enumerate(['Основное · 1','Цены · 1','Медиа','Все свойства']):button(50+i*230,320,s,215,i==0)
   txt(50,392,'⠿  Название',18,b=True);box(50,426,1070,58,outline=border);txt(68,443,'Маршрут у вулкана — 5 дней',20)
   txt(50,496,'Было: «Маршрут у вулкана» · Редактор А, 14:20 · Отменить',16,muted)
   txt(50,553,'⠿  Показывать на главной',18,b=True);box(50,590,62,30,green,r=15);d.ellipse((84,593,109,618),fill='white');txt(127,594,'Включено в черновике',17)
   txt(50,652,'Переместить поле: за ручку или через меню «Во вкладку…»',16,muted)
   box(50,720,1070,68,'#18392c');txt(70,742,'На сайте прежняя версия',18,'white');button(585,732,'Предпросмотр',220);button(825,732,'Опубликовать',270,True)
  else:
   for i,s in enumerate(['Название','property_17','Цена','Описание','Дополнительный текст']):
    y=235+i*90;txt(50,y,s,17);box(50,y+28,1070,45,outline=border);txt(70,y+39,'Маршрут у вулкана' if i==0 else '…',18,muted)
   txt(50,716,'□ active     □ show_main     □ publish',18);button(890,736,'Сохранить',230,True);txt(50,776,'Нет автора, сравнения и состояния черновика',17,red)
 else:
  if good:
   box(50,235,1070,105,'#e6f1eb',green);txt(75,254,'Перетащите фото или вставьте Ctrl / Cmd + V',21,b=True);button(75,288,'Выбрать файлы',215);txt(320,301,'или добавьте прямую ссылку',17,muted)
   names=['Вулкан','Побережье','Тропа']
   for i,name in enumerate(names):
    x=50+i*365;box(x,365,340,283,outline=border);txt(x+16,380,'⠿   '+name,19,b=True);photo(x+16,417,308,135)
    if i==0:box(x+24,425,115,27,green);txt(x+34,429,'Обложка',15,'white',True)
    txt(x+16,565,'Описание фото',14,muted);box(x+16,590,308,40,'#f4f7f4');txt(x+27,600,name+' на маршруте',16)
   txt(50,674,'3 файла добавлены · порядок и подписи сохранены в черновике',16,green)
   box(50,720,1070,68,'#18392c');txt(70,742,'Оригиналы сохранены',18,'white');button(650,732,'Отменить',170);button(840,732,'Опубликовать',250,True)
  else:
   button(50,235,'Выбрать один файл',270)
   for i,name in enumerate(['IMG_2381.jpg','IMG_2382.jpg','IMG_2383.jpg']):
    y=315+i*135;photo(50,y,160,110);txt(236,y+8,name,19);txt(236,y+44,'Сортировка:',16,muted);box(365,y+35,90,40,outline=border);txt(382,y+45,str((i+1)*100),17);txt(490,y+45,'Описание не задано',17,muted);button(905,y+37,'Удалить',170)
   txt(50,759,'Только числовой порядок · нет вставки, подписи и восстановления',17,red)
 im.save(OUT/f'{kind}-{"good" if good else "bad"}.webp',quality=90,method=6)
for kind in ['table','editor','media']:
 for good in [False,True]:render(kind,good)
print('Rendered six synthetic illustrations')
