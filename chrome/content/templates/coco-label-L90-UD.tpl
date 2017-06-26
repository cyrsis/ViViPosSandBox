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
{for index in loopItems}
[0X1B][0X7B][0X01]
[0x1C][0x28][0x4C][0x02][0x00][0x43][0x32]${(order.check_no != null && order.check_no.length > 0 ? ' (' + order.check_no + ')' : '')|left:8}${counter++ + '/' + total|right:5}
[0x1B][0x33][0x08]
${item.name|left:14}[0x1B][0x32]${'$' + txn.formatPrice((item.current_subtotal+item.current_discount+item.current_surcharge)/item.current_qty)|left:8}
[0x1B][0x33][0x18]
${conds|substr:0,24}
${conds|substr:24,24}
{if item.memo != null && item.memo.length > 0}
${'*' + item.memo|left:24}
{/if}
{/for}
{/for}
[0x1C][0x28][0x4C][0x02][0x00][0x41][0x30]
