{if order.destination_prefix == 1211 || order.destination_prefix == 1212 || order.destination_prefix == 1221 || order.destination_prefix == 1222 || order.destination_prefix == 2211 || order.destination_prefix == 2212 || order.destination_prefix == 2221 || order.destination_prefix == 2222}
{if hasLinkedItems}
[&INIT]
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
    total += Math.abs(order.items[itemId].current_qty);
  }
{/eval}
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
  for (var i = 0; i < Math.abs(item.current_qty); i++) {
    itemLen.push(i);
  }
{/eval}
{for index in itemLen}
{eval}
  header = '此次列印第 '+ ++count+' 張/共 '+total+' 張';
{/eval}
{if order.destination == '內用'}
[&OSON]單${sequence|tail:3} ${'桌' + table_name|left:7}[&OSOFF]
{elseif order.destination == '桌外帶'}
[&OSON]單${sequence|tail:3} ${'桌' + table_name}外帶[&OSOFF]
{elseif order.destination == '外用'}
[&OSON]單${sequence|tail:3} ${'外用'}[&OSOFF]
{elseif order.destination == '外帶'}
[&OSON]單${sequence|tail:3} ${'外帶'}[&OSOFF]
{else}
[&OSON]單${sequence|tail:3}  ${order.destination}[&OSOFF]
{/if}
{if order.check_no != ''}
[&QSON]取餐號碼:${order.check_no}[&QSOFF]
{/if}
------------------------------------------
{if item.current_qty > 0}
[&OSON]${name + 'x1'|right:16}[&OSOFF]
{if condStr != ''}
[&QSON] ${condStr|right:18}[&QSOFF]
{/if}
{elseif item.current_qty < 0}
[&OSON]退[&OSOFF] [&QSON]${name|left:16}[&QSOFF][&DHON]1[&DHOFF]
{if condStr != ''}
[&QSON] ${condStr|right:18}[&QSOFF]
{/if}
{/if}
[&CR]
[&CR]
[&CR]
[&CR]
[&PC]
[&OPENDRAWER]
{/for}
{/if}
{/for}
{/if}
{/if}