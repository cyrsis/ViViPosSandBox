[&INIT]
{eval}
  memo = '';
{/eval}
[&QSON]${'換桌單'|center:21}[&QSOFF]
${'(' + order.seq + ')'|center:42}
[&RESET]
{if store.state != 0}
[&QSON]${'原 ' + order.destination}單號:${sequence|tail:2}[&QSOFF]
[&CR]
{else}
[&QSON]${'原 ' + order.destination}單號:${sequence|tail:3}[&QSOFF]
[&CR]
{/if}
${'桌次:'|left:6}[&DWON]${order.org_table_name + '[' + order.org_table_no + ']'|center:18}[&DWOFF]
      [&DWON]${'換桌至'|center:18}[&DWOFF]
      [&DWON]${order.table_name + '[' + order.table_no + ']'|center:18}[&DWOFF]
------------------------------------------
{for item in order.display_sequences}
{if item.type == 'item' && order.items[item.index] != null && order.items[item.index].linked}
${item.current_qty|right:4} ${item.name|left:37}
{elseif item.type == 'setitem' && order.items[item.index] != null && order.items[item.index].linked}
  ${item.current_qty|right:4} ${item.name|left:35}
{elseif item.type == 'condiment' && (item.index == null || order.items[item.index].linked)}
    ${item.name|left:38}
{elseif item.type == 'memo' && (item.index == null || order.items[item.index] == null || order.items[item.index].linked)}
{if item.index == null || order.items[item.index] == null}
{eval}
if (memo.length == 0)
    memo += ((memo.length == 0) ? '' : '\n') + item.name
{/eval}
{else}
        ${item.name|left:34}
{/if}
{/if}
{/for}
------------------------------------------
{if memo.length > 0}
${memo|left:42}
{/if}
${'列印時間:'|left:10}${(new Date()).toLocaleFormat('%Y-%m-%d  %H:%M:%S')}
${'主機:'|left:5}${order.terminal_no|left:9}   ${'操作人員:'|left:9}${order.service_clerk_displayname|default:''|left:14}
[&CR]
[&CR]
[&CR]
[&CR]
[&PC]
[&CR]
[&CR]
[&CR]
