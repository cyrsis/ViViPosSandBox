{if hasLinkedItems}
[&INIT]
{eval}
  memo = '';
{/eval}
{if duplicate}
[&DWON]${'Kitchen Check Copy'|center:21}[&DWOFF]
{else}
[&DWON]${'Kitchen Check'|center:21}[&DWOFF]
{/if}
[&RESET]${'Printed:'|left:10} ${(new Date()).toLocaleFormat('%Y-%m-%d %H:%M:%S')}
${'Terminal:'|left:10} ${order.terminal_no|left:9} ${'Server:'|left:6} ${order.service_clerk_displayname|default:''|left:14}
${'Check#:'|left:10} ${order.check_no|default:''|left:9} ${'Inv#:'|left:6} ${order.seq}
{if order.table_no != null || order.no_of_customers != null}
[&REDON]${'Table:'|left:10} ${order.table_name|default:''|left:9} ${'#Cust:'|left:6} ${order.no_of_customers|default:''|left:14}
[&REDOFF]
{/if}
--------------------------------------
{for item in order.display_sequences}
{if item.type == 'item' && order.items[item.index] != null && order.items[item.index].linked}
{if item.current_qty<0}
[&REDON]
xx ${item.current_qty|right:4} ${item.alt_name1|left:37}
[&REDOFF]
{else}
 ${item.current_qty|right:4} ${item.alt_name1|left:37}
{/if}
{elseif item.type == 'setitem' && order.items[item.index] != null && order.items[item.index].linked}
  ${item.current_qty|right:4} ${item.alt_name1|left:35}
{elseif item.type == 'condiment' && (item.index == null || order.items[item.index].linked)}
[&REDON]
    ${item.name|left:38}
[&REDOFF]
{elseif item.type == 'memo' && (item.index == null || order.items[item.index] == null || order.items[item.index].linked)}
{if item.index == null || order.items[item.index] == null}
{eval}
if (memo.length == 0)
    memo += ((memo.length == 0) ? '' : '\n') + item.name
{/eval}
{else}
[&REDON]
        ${item.name|left:34}
[&REDOFF]
{/if}
{/if}
{/for}
----------------------------------------
{if memo.length > 0}
[&REDON]
${memo|left:42}
[&REDOFF]
{/if}
[&CR]
[&CR]
[&CR]
[&CR]
[&CR]
[&CR]
[&PC]
[&CR]
[&CR]
[&CR]
{/if}
