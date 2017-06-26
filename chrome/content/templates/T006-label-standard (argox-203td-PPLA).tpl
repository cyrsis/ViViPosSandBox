{eval}
currentTime = new Date().toString('HH:mm');
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
1;0000100820005${destination|left:4}
191100200820050${currentTime}
191100200820090${sequence}/${orderTotal|left:3}
1;0000100650005${item.name|left:20}
192200100450005${'$' + txn.formatPrice((item.current_subtotal+item.current_discount+item.current_surcharge)/item.current_qty)|right:20}
1;0000100330005${condStr.substr(0,10)}
1;0000100170005${condStr.substr(10,20)}
{if footnote != ''}
1;0000100020005外送專線
{/if}
191100200020055${footnote}
Q${GeckoJS.String.padLeft(item.current_qty, 4, '0')}
E
{/for}
