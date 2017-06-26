{eval}
total = 0;
linkedItems = [];
for (id in order.items) {
    if (order.items[id].linked && order.items[id].current_qty > 0) {
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
counter = 1;
{/eval}
{for item in linkedItems}
{if counter == 1}[&INIT][0x1C][0x28][0x4C][0x02][0x00][0x43][0x50]{/if}
{eval}
  conds = '';
  for (cond in item.condiments) {
    conds += (conds == '') ? cond : (',' + cond);
  }
  loopItems = [];
  for (var i = 0; i < item.current_qty; i++) {
    loopItems.push(i);
  }
{/eval}
{if order.destination_prefix != 100 || item.memo=='ToGo'}
{for index in loopItems}
[0x1C][0x28][0x4C][0x02][0x00][0x43][0x32]${'Table:' + order.table_name} ${'No#:'+ order.check_no} ${new Date().toLocaleFormat('%H:%M')}${counter++ + '/' + total|right:5}
[0x1B][0x33][0x08]
[0x1D][0x57][0x48][0x02]
${item.name} ${'@$' + txn.formatPrice((item.current_subtotal+item.current_discount+item.current_surcharge)/item.current_qty)}

${item.alt_language}
[0x1B][0x32]${conds|substr:0,24}
[0x1B][0x32]${conds|substr:24,24}
[0x1B][0x32]${store.note|left:18}
{if item.memo != null && item.memo.length > 0}
{/if}
{/for}
{/for}
{/if}
[0x1C][0x28][0x4C][0x02][0x00][0x41][0x30]
