{eval}
currentTime = new Date().toString('HH:mm');
now = new Date();
today = now.toLocaleFormat('%m/%d');
time = now.toLocaleFormat('%H:%M');
destination = order.destination || '';
footnote = store.note || '';
sequence = order.seq.toString();
sequenceTracksDate = GeckoJS.Configure.read('vivipos.fec.settings.SequenceTracksSalePeriod');
if (sequenceTracksDate) {
    sequenceLength = GeckoJS.Configure.read('vivipos.fec.settings.SequenceNumberLength');
    sequence = sequence.substr(-sequenceLength);
}
else {
    sequence = sequence.substr(-3);
}
condStr = '';
total = 0;
linkedItems = [];
for (id in order.items) {
    if (order.items[id].linked) {
        var taglist = '';
        if (order.items[id].tags != null) {
            taglist = order.items[id].tags.join(',');
        }
        if (taglist.indexOf('nolabel') == -1) {
            linkedItems.push(order.items[id]);
            total += order.items[id].current_qty;
        }
    }
}
counter = '01';
total = GeckoJS.String.padLeft(total, 2, '0');
{/eval}
{for item in linkedItems}
{if counter == 1}
[&STX]KI70
[&STX]c0000
[&STX]f320
{/if}
{eval}
  conds = GeckoJS.BaseObject.getValues(item.condiments);
  lineLimit = 3;
  lineSize = 9; //可定義每行調味每行列印字數
  if (item.memo == null || item.memo.length == 0) {
    lineLimit = 4;
  }
  condMaxLength = lineLimit * lineSize;

  condStr = '';
  conds.forEach(function(cond) {
    condStr += (condStr == '' ? cond.name : (',' + cond.name));
    if ('current_qty' in cond && cond.current_qty > 1) {
      condStr += 'x' + cond.current_qty;
    }
  })
  if (condStr.length > condMaxLength) condStr = condStr.substr(0, condMaxLength);
  condLines = [];
  while (condStr.length > 0) {
    condLines.push(condStr.substr(0, lineSize));
    condStr = condStr.substr(lineSize);
  }
  y = 42 //決定調味第一行，列印高度
  lineHeight = 14; //第二行調味與第一行調味，列印間距。
{/eval}
[&STX]L
C0000
D11
H20
1;0000100800010${destination|left:4}
191100200800037${currentTime}
191100200800068${counter}
+01
191100200800080/${total}
191100200800095/${sequence|tail:3}
1;1200100540005${item.name|left:15}
192300100520005${'$' + txn.formatPrice((item.current_subtotal+item.current_discount+item.current_surcharge)/item.current_qty)|right:20}
{for cond in condLines}
1;0000100${GeckoJS.String.padLeft(y, 2, '0')}0010${cond}[&CR]
{eval}
y -= lineHeight;
{/eval}
{/for}
1;0000100020010${footnote}
Q${GeckoJS.String.padLeft(item.current_qty, 4, '0')}
E
{eval}
counter = GeckoJS.String.padLeft(parseInt(counter, 10) + item.current_qty, 2, '0');
{/eval}
{/for}
