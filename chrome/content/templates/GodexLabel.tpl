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
^Q40,3[&CR]
^W50[&CR]
^H8[&CR]
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
AZ1,25,10,2,1,0,0,${sequence}[&CR]
AZ1,120,10,1,1,0,0,${(new Date()).toLocaleFormat('%Y-%m-%d %H:%M:%S')}[&CR]
AZ1,250,250,1,1,0,0,${counter}/${orderTotal}[&CR]
Le,10,31,388,32
AZ1,25,50,1,1,0,0,${item.name}[&CR]
AZ1,25,90,1,1,0,0,${item.alt_language}[&CR]
{eval}
yCoordinate = 150;
yIncrement = 40;
{/eval}
{for cond in conds}
AZ1,25,${yCoordinate},1,1,0,0,${'-' + cond}[&CR]
{eval}
yCoordinate += yIncrement;
{/eval}
{/for}
E[&CR]
{/for}