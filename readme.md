## Суть
Игра. Есть игрок, есть враги, рандомный уровень с преградами, монетки, которые надо собрать.
Фон - черный, монетка - желтая, дерево - зеленое, камень - серый, вода - синяя, враги - красные, игрок - белый.
Движение игрока происходит при нажатии стрелок. Враги двигаются каждый ход игрока.
Игрок погибает когда касается врага. 
Монетка исчезает, когда касается игрока.
В левом верхнем углу - счетчик собранных монет.

## План
1 игрок 2 врага просто шляются. один тип преград:
запретить врагам и игроку выходить за пределы поля
подсмотреть генератор карты
монетки
типы преград
уровни
добавление количества врагов
враги начинают гоняться за игроком, если он близко
преграды не просто квадратики (рисунок деревца, камня, врага, монетки)
вращение монеток, колыханеие деревьев, волнение воды
? 
ходить через лес
утонуть в воде
выход вверх экрана переносит игрока вниз

## Идеи
генерация карты на основе qr-кода
кирка, чтобы продалбывать стены
возможность убивать врагов
предвидение (игрок знает следующий ход врага)
разный цвет камней

## Сделал
###0.6
игрок двигается нормально. правки движения врагов.
###0.5
правки движения игрока. 
###0.4
Внедрил код, который группирует похожие объекты. Деревья - в лес, камни - в гряды, воду - в озера. 
Начал писать движение. Творится какой-то треш
###0.3
Внедрил шум Перлина. Дело было в .f Modulo и curnoise
###0.2
в течение 6 часов пытался приспособить генерацию уровня. в итоге всё свелось к тупому Random
###0.1
http://at02.ru/rogue-pb-start/