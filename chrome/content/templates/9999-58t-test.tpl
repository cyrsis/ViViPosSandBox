{if hasLinkedItems}
[&INIT]
{eval}
  memo = '';
  count = 0;
  storeContact = GeckoJS.Session.get('storeContact');
  plugroupsById = GeckoJS.Session.get('plugroupsById');
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
{if duplicate}
[&DWON]${'廚房出功能表副本'|center:22}[&DWOFF][&CR]
{else}
[&DWON]${'廚房出功能表'|center:21}[&DWOFF][&CR]
{/if}
[&QSON]${'機號：'|left:6} ${order.terminal_no|left:10}[&QSOFF]
[&QSON]${order.destination}${'單號:'|left:4} ${order.seq|tail:3}[&QSOFF]
{if order.table_no != null || order.no_of_customers != null}
[&QSON]${'桌號'|left:4}：${order.table_no|default:''|left:10}[&QSOFF]
{/if}
[&QSON]${'桌名'|left:4}：${table_name|default:''|left:10}[&QSOFF]
國家: ${storeContact.country}
--------------------------------------------
{eval}
GREUtils.log('#############################');
GREUtils.log('Session Groups By Id Dump:::');
GREUtils.log(GeckoJS.BaseObject.dump(GeckoJS.Session.get('plugroupsById')));
GREUtils.log('=============================');
GREUtils.log('Order Dump:::');
GREUtils.log(GeckoJS.BaseObject.dump(order));
GREUtils.log('=============================');
GREUtils.log('Oreder_display_sequences dump:::');
GREUtils.log(GeckoJS.BaseObject.dump(order.display_sequences));
GREUtils.log('=============================');
GREUtils.log('Oreder_items dump:::');
GREUtils.log(GeckoJS.BaseObject.dump(order.items));
GREUtils.log('=============================');
GREUtils.log('Session Store Contacts Dump:::');
GREUtils.log(GeckoJS.BaseObject.dump(GeckoJS.Session.get('storeContact')));
GREUtils.log('#############################');
{/eval}
{for item in order.display_sequences}
{if item.type == 'item' && order.items[item.index] != null && order.items[item.index].linked}
{eval}
	itemTrans = order.items[item.index];
	count += parseInt(itemTrans.current_qty);
{/eval}
[&QSON]${item.name|left:18}${item.current_qty|right:4}[&QSOFF]
{elseif item.type == 'setitem' && order.items[item.index] != null && order.items[item.index].linked}
  [&DHON]${item.name|left:20}                  ${item.current_qty|right:3}[&DHOFF]
{elseif item.type == 'condiment' && (item.index == null || order.items[item.index].linked)}
      ${item.name|left:32}
{elseif item.type == 'memo' && (item.index == null || order.items[item.index] == null || order.items[item.index].linked)}
{if item.index == null || order.items[item.index] == null}
{eval}
if (memo.length == 0)
    memo += ((memo.length == 0) ? '' : '\n') + item.name
{/eval}
{else}
     備註:${item.name|left:31}
{/if}
{/if}
{/for}
--------------------------------------------
[&QSON]${'品項合計:'|left:14}   ${count|right:4}[&QSOFF]
--------------------------------------------
${'列印時間:'|left:10} ${(new Date()).toLocaleFormat('%Y-%m-%d %H:%M:%S')}
[&CR]
[&CR]
[&CR]
[&CR]
[&CR]
[&CR]
[&CR]
{if memo.length > 0}
${memo|left:42}
[&CR]
[&CR]
{/if}
[&PC]
[&CR]
[&OPENDRAWER]
{/if}
