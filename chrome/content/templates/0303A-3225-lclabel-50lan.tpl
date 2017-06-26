{if order.destination_prefix == 1121 || order.destination_prefix == 1122 || order.destination_prefix == 1221 || order.destination_prefix == 1222 || order.destination_prefix == 2121 || order.destination_prefix == 2122 || order.destination_prefix == 2221 || order.destination_prefix == 2222}
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
{if order.table_name != ''}
1;1100200820010${'桌:' + order.table_name}
{else}
1;0000100820010${destination|left:4}
191100200820045${currentTime}
{/if}
{if store.state != ''}
191100200820080${sequence|tail:2}/${orderTotal|left:3}
{else}
191100200820080${sequence|tail:3}/${orderTotal|left:2}
{/if}
1;1100100520006${item.name|left:20}
191100200600009${'$' + txn.formatPrice((item.current_subtotal+item.current_discount+item.current_surcharge)/item.current_qty)|right:28}
1;0000100330005${condStr.substr(0,10)}
1;0000100170005${condStr.substr(10,20)}
1;0000100020010${'電話:'}
191100200020045${footnote}
Q${GeckoJS.String.padLeft(item.current_qty, 4, '0')}
E
{/for}
{/if}