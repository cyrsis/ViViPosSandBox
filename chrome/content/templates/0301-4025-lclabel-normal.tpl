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
  conds = GeckoJS.BaseObject.getKeys(item.condiments);
  if (conds.length > 0) {
    condStr = conds.join(',');
  } else {
    condStr = '';
  }
  if (item.memo != null && item.memo != '') {
    condStr = item.memo + ',' + condStr;
  }
{/eval}
[&STX]L
C0000
D11
H20
{if table_name != ''}
1;1100200820010${'桌:' + table_name}
{else}
1;0000100820010${destination|left:4}
191100200820045${today}
{/if}
191100200820085${currentTime}
{if store.state != ''}
191100200820120${sequence|tail:2}/${orderTotal|left:3}
{else}
191100200820120${sequence|tail:3}/${orderTotal|left:2}
{/if}
1;1200100520010${item.name|left:20}
192200100520005${'$' + txn.formatPrice((item.current_subtotal+item.current_discount+item.current_surcharge)/item.current_qty)|right:26}
{if store.county != ''}
1;1200100250008${condStr.substr(0,12)}
1;1200100020008${condStr.substr(12,24)}
{else}
1;0000100330005${condStr.substr(0,12)}
1;0000100170005${condStr.substr(12,24)}
1;0000100020010${footnote}
{/if}
Q${GeckoJS.String.padLeft(item.current_qty, 4, '0')}
E
{/if}
{/for}
{/if}