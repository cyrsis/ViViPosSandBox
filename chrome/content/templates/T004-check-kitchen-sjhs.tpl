[&INIT]
{eval}
  sequence = order.seq.toString();
  if (sequence == null) {
    sequence = '';
  }
  else {
    sequence = sequence.substr(-2);
  }
  count = 0;
  total = 0;
  for (itemId in order.items) {
    total += order.items[itemId].current_qty;
  }
{/eval}
{for item in order.items}
{eval}
  condStr = '';
  condiments = item.condiments;
  if (condiments != null) {
    condStr = GeckoJS.BaseObject.getKeys(condiments).join(';');
  }
  if (defined(item.alt_name1) && item.alt_name1 != '') {
    name = item.alt_name1;
  }
  else {
    name = item.name;
  }
  itemLen = new Array();
  for (var i = 0; i < item.current_qty && i < 1; i++) {
    itemLen.push(i);
  }
{/eval}
{for index in itemLen}
{eval}
  header = ++count + '/' + total;
{/eval}
{if order.destination == '外帶'}
[&QSON]外:${sequence|left:4} ${header|right:6}[&QSOFF]
{else}
[&QSON]內:${order.table_no|left:4} ${header|right:6}[&QSOFF]
{/if}
[&CR]
[&QSON]${name|left:12} ${item.current_qty|right:2}[&QSOFF]
{if condStr != ''}
[&DHON]  ${condStr|left:28}[&DHOFF]
{/if}
[&CR]
[&CR]
[&CR]
[&CR]
[&PC]
{/for}
{/for}
[&CR]
[&CR]
[&CR]
[&CR]
[&CR]
[&CR]
