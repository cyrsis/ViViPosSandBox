[&INIT]
{if hasLinkedItems}
{eval}
  sequence = order.seq.toString();
  if (sequence == null) {
    sequence = '';
  }
  else {
    sequence = sequence.substr(-3);
  }

  table_no = order.table_no;
  if (table_no != null && table_no.length > 5) {
    table_no = table_no.substr(-5);
  }

  check_no = order.check_no;
  if (check_no != null && check_no.length > 5) {
    check_no = check_no.substr(-5);
  }

  count = 0;
  total = 0;
  for (itemId in order.items) {
    total += order.items[itemId].current_qty;
  }
{/eval}
{for item in order.items}
{if item.linked}
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
  for (var i = 0; i < item.current_qty; i++) {
    itemLen.push(i);
  }
{/eval}
{for index in itemLen}
{eval}
  header = ++count + '/' + total;
{/eval}
{if item.destination == '外帶'}
[&OSON]外:${sequence|left:4} ${header|right:6}[&OSOFF]
{elseif item.destination == '內用'}
[&OSON]內:${sequence|left:4} ${header|right:6}[&OSOFF]
{elseif item.destination == '外送'}
[&OSON]送:${sequence|left:4} ${header|right:6}[&OSOFF]
{/if}
[&CR]
[&QSON]桌號:${table_no|left:5} 牌號:${check_no|left:5}[&CR]
時間:${new Date().toLocaleFormat('%H:%M')}[&QSOFF]
------------------------------------------
[&QSON]${item.current_qty|left:3} [&QSON]${name|left:17}[&QSOFF]
{if condStr != ''}
[&DHON]  ${condStr|left:40}[&DHOFF]
{/if}
[&CR]
[&CR]
[&CR]
[&CR]
[&PC]
{/for}
{/if}
{/for}
[&CR]
[&CR]
[&CR]
{/if}
