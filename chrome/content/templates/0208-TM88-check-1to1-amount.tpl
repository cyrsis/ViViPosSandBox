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
    total += order.items[itemId].current_qty;
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
  for (var i = 0; i < 1; i++) {
    itemLen.push(i);
  }
{/eval}
{for index in itemLen}
{eval}
  header = '第 '+ ++count+' 項/共 '+total+' 項';
{/eval}
{if store.state != ''}
[&QSON]${order.destination}單號:${sequence|tail:2|left:3}[&QSOFF] 時間 ${new Date().toLocaleFormat('%H:%M')}${'*0208'|right:8}
{else}
[&QSON]${order.destination}單號:${sequence|tail:3|left:3}[&QSOFF] 時間 ${new Date().toLocaleFormat('%H:%M')}${'*0208'|right:8}
{/if}
{if order.check_no != ''}
[&QSON]取餐號碼:${order.check_no}[&QSOFF]
{/if}
{if order.table_name != ''}
[&QSON]桌名:${table_name|left:14}[&QSOFF]
{/if}
${'服務人員:'|left:10}${order.service_clerk_displayname|left:16}
------------------------------------------
{if item.current_qty > 0}
[&QSON]${name|left:18}[&QSOFF][&DHON] X${item.current_qty|left:4}[&DHOFF]
{if condStr != ''}
[&QSON] ●${condStr|left:18}[&QSOFF][&CR]
{/if}
{if item.type == 'memo' && (item.index == null || order.items[item.index] == null || order.items[item.index].linked)}
{if item.index == null || order.items[item.index] == null}
------------------------------------------
[&DHON]訂單備註：${item.name}[&DHOFF]
{else}
[&DHON]備註：${item.name}[&DHOFF]
{/if}
{/if}
{else}
[&OSON]退[&OSOFF] [&QSON]${name|left:16}[&QSOFF][&DHON]${Math.abs(item.current_qty)|left:3}[&DHOFF]
{if condStr != ''}
[&QSON] ●${condStr|left:18}[&QSOFF][&CR]
{/if}
{if item.type == 'memo' && (item.index == null || order.items[item.index] == null || order.items[item.index].linked)}
{if item.index == null || order.items[item.index] == null}
------------------------------------------
[&DHON]訂單備註：${item.name}[&DHOFF]
{else}
[&DHON]備註：${item.name}[&DHOFF]
{/if}
{/if}
{/if}
[&CR]
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