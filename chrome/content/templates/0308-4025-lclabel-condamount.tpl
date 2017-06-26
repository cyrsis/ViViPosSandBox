{if order.destination_prefix == 1121 || order.destination_prefix == 1122 || order.destination_prefix == 1221 || order.destination_prefix == 1222 || order.destination_prefix == 2121 || order.destination_prefix == 2122 || order.destination_prefix == 2221 || order.destination_prefix == 2222}
{eval}
  table_name = order.table_no || '';
  tablesByNo = GeckoJS.Session.get('tablesByNo');
  if (tablesByNo) {
    table = tablesByNo[order.table_no];
    if (table) {
      table_name = table.table_name;
    }
  }
{/eval}
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
printTotal = 0;
orderTotal = 0;
linkedItems = [];
for (id in order.items) {
    if (order.items[id].linked) {
        var taglist = '';
        if (order.items[id].tags != null) {
            taglist = order.items[id].tags.join(',');
        }
        if (taglist.indexOf('nolabel') == -1) {
            linkedItems.push(order.items[id]);
            printTotal += order.items[id].current_qty;
        }
    }
    orderTotal += order.items[id].current_qty;
}
counter = 1;
{/eval}
{for item in linkedItems}
{if item.current_qty > 0}
{if counter == 1}
[&STX]KI70
[&STX]c0000
[&STX]f320
{/if}
{eval}
  conds = GeckoJS.BaseObject.getValues(item.condiments);
  lineLimit = 3;
  lineSize = 34; //可定義每行調味每行列印字數
  if (item.memo == null || item.memo.length == 0) {
    lineLimit = 4;
  }
  condMaxLength = lineLimit * lineSize;

  condStr = '';
  conds.forEach(function(cond) {
    condStr += (condStr == '' ? cond.name : (', ' + cond.name));
    if ('current_qty' in cond && cond.current_qty > 1) {
      condStr += ' x ' + cond.current_qty;
    }
  })
  if (condStr.length > condMaxLength) condStr = condStr.substr(0, condMaxLength);
  condLines = [];
  while (condStr.length > 0) {
    condLines.push(condStr.substr(0, lineSize));
    condStr = condStr.substr(lineSize);
  }
  y = 45 //決定調味第一行，列印高度
  lineHeight = 12; //第二行調味與第一行調味，列印間距。
{/eval}
[&STX]L
C0000
D11
H20
{if table_name != ''}
1;1100200820010${'桌:' + table_name}
{else}
191100200820010${destination|left:12}
{/if}
{if store.state != ''}
191100200820065${sequence|tail:2}/${orderTotal|left:3}
{else}
191100200820065${sequence|tail:3}/${orderTotal|left:3}
{/if}
191100200820190${currentTime}
{eval}
    firstline = _MODIFIERS['substr'](item.name, 0, 30);
    secondline = item.name.substr(firstline.length) || '';
{/eval}
191200100580010${firstline|left:32}
{if secondline != ''}
192100200440010${'-'|left:18}
191200100400017${secondline|left:18}
{/if}
192200100760005${'$' + txn.formatPrice((item.current_subtotal+item.current_discount+item.current_surcharge)/item.current_qty)|right:26}
{for cond in condLines}
191100100${GeckoJS.String.padLeft(y, 2, '0')}0010${cond}[&CR]
{eval}
y -= lineHeight;
{/eval}
{/for}
191100200020010${footnote|center:28}
Q${GeckoJS.String.padLeft(item.current_qty, 4, '0')}
E
{/if}
{/for}
{/if}
