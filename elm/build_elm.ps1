param([string]$src=".\src\Main.elm")

$js="..\static\elm.js"
$min="..\static\elm.min.js"

elm make --optimize --output=$js $src

uglifyjs $js --compress 'pure_funcs=[F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9],pure_getters,keep_fargs=false,unsafe_comps,unsafe' | uglifyjs --mangle --output $min

$size = (Get-ChildItem $js).Length
echo "Compiled size:`t$size`tbytes ($js)"

$size = (Get-ChildItem $min).Length
echo "Compiled size:`t$size`tbytes ($min)"

$size = (gzip -c (Get-ChildItem $min).FullName).Length
echo "Compiled size:`t$size`tbytes ($min.gz)"
