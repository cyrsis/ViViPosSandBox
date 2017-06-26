{eval}
now = new Date();
currentTime = now.toString('HH:mm');
today = now.toLocaleFormat('%Y/%m/%d');
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
   condStr = condStr.replace(/ /gi,"");
{/eval}
[&STX]L
C0000
D11
H20
1;0000100820005${store.name + store.branch |left:20}
191100200680005${footnote}
1;0000100680063${destination|left:8}
191100200680090${sequence}/${orderTotal|left:5}
1;0000100550005${item.name|left:20}
1;0000100420005${condStr.substr(0,10)}
1;0000100290005${condStr.substr(10,10)}
1;0000100160005${condStr.substr(20,7)}
191100200020005${today}
191100200020062${currentTime}
191200200010090${'$' + txn.formatPrice((item.current_subtotal+item.current_discount+item.current_surcharge)/item.current_qty)|right:6}
Q${GeckoJS.String.padLeft(item.current_qty, 4, '0')}
E
{eval}
counter += item.current_qty;
{/eval}
{/for}
