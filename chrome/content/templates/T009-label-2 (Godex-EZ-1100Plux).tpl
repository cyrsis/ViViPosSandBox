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
            var itemCount = order.items[id].current_qty;
            for ( var i = 0; i < itemCount; i++ )
                linkedItems.push(order.items[id]);
            printTotal += itemCount;
        }
    }
    orderTotal += order.items[id].current_qty;
}
counter = 0;
{/eval}
{for item in linkedItems}
{eval}
  counter++;
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
^Q19,3[&CR]
^W48[&CR]
^H10[&CR]
^P1[&CR]
^S4[&CR]
^AD[&CR]
^C1[&CR]
^R0[&CR]
~Q+0[&CR]
^O0[&CR]
^D0[&CR]
^E12[&CR]
~R200[&CR]
^L[&CR]
AC,25,0,2,1,0,0,${sequence}[&CR]
AC,193,0,2,1,0,0,${counter}/${orderTotal}[&CR]
Le,0,31,388,32
AC,25,30,1,1,0,0,${item.name}[&CR]
{eval}
yCoordinate = 60;
yIncrement = 30;
{/eval}
{for cond in conds}
AC,25,${yCoordinate},1,1,0,0,${'-' + cond}[&CR]
{eval}
yCoordinate += yIncrement;
{/eval}
{/for}
E[&CR]
{/for}
