param([string]$src=".\src\Main.elm")

$js="..\static\main.js"
$min="..\static\main.min.js"
$zip="..\static\main.min.js.gz"

elm make --optimize --output=$js $src

uglifyjs $js --compress 'pure_funcs=[F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9],pure_getters,keep_fargs=false,unsafe_comps,unsafe' | uglifyjs --mangle --output $min



$size = (Get-ChildItem $js).Length
echo "Compiled size:`t$size`tbytes ($js)"

$size = (Get-ChildItem $min).Length
echo "Compiled size:`t$size`tbytes ($min)"

gzip -c (Get-ChildItem $min).FullName > $zip
$size = (Get-ChildItem $zip).Length
echo "Compiled size:`t$size`tbytes ($zip)"
