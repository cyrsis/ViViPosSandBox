{if hasLinkedItems}
[&INIT]
{eval}
  memo = '';
{/eval}
${'Check#:'|left:10} ${order.check_no|default:''|left:9} ${'Inv#:'|left:6} ${order.seq}
{if order.table_no != null || order.no_of_customers != null}
${'Table:'|left:10} ${order.table_name|default:''|left:9} ${'#Cust:'|left:6} ${order.no_of_customers|default:''|left:14}
{/if}
--------------------------------------
{for item in order.display_sequences}
{if item.type == 'item' && order.items[item.index] != null && order.items[item.index].linked}
${item.current_qty|right:4} ${item.name|left:37}
{elseif item.type == 'setitem' && order.items[item.index] != null && order.items[item.index].linked}
  ${item.current_qty|right:4} ${item.alt_name1|left:35}
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
[&CR]
[&CR]
[&CR]
[&CR]
[&CR]
[&PC]
{/if}
