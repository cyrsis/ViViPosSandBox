{if hasLinkedItems}
{eval}
  cut_count = 0;
  theqty = 0;
  memo = '';
{/eval}
{for item in order.display_sequences}
{if item.type == 'item' || item.type == 'setitem'}
{eval}
  theqty=parseFloat(item.current_qty.replace('X',''));
{/eval}
{/if}
{if theqty>0 && (order.items[item.index] != null && order.items[item.index].linked)}
{if item.type == 'item' && order.items[item.index] != null && order.items[item.index].linked}
{if cut_count != 0}
[&CR]
[&CR]
[&CR]
[&CR]
[&CR]
[&CR]
[&CR]
[&CR]
[&CR]
[&PC]
{else}
[&INIT]
{/if}
[&REDOFF]
{if duplicate}
[&QSON]${'重印廚房單'|center:21}[&QSOFF]
{elseif theqty<0}
[&REDON]
[&QSON]${'取　消　單'|center:21}[&QSOFF]
[&REDOFF]              
{else}
[&QSON]${'廚　房　單'|center:21}[&QSOFF]
{/if}
[&RESET]${'Printed:'|left:10} ${(new Date()).toLocaleFormat('%Y-%m-%d %H:%M:%S')}
${'Terminal:'|left:10} ${order.terminal_no|left:9} ${'Clerk:'|left:6} ${order.proceeds_clerk_displayname|default:''|left:12}
${'Seq:'|left:10} ${order.seq|tail:3|left:9} ${'Txn#:'|left:6} ${order.seq}
[&REDON]
[&QSON]${'單號:'|left:5}${order.check_no|default:''|left:5} {if order.table_no != null}${'檯號:'|left:5}${order.table_no|default:''|left:4}{/if}[&QSOFF]
[&REDOFF]
----------------------------------------
{if theqty<0}[&REDON]{/if}
[&QSON]{if theqty<0}${'取消＊'}{/if}{if item.destination != null}${item.destination|right:2}{/if} ${item.current_qty|right:3} ${item.alt_name2|left:12}[&QSOFF]
{elseif item.type == 'setitem' && order.items[item.index] != null && order.items[item.index].linked}
{if theqty<0}
    [&QSON]${'>'+ item.name|left:15}[&QSOFF]
    {else}
    [&QSON]${'>'+ order.items[item.index].alt_name2|left:15}[&QSOFF]
{/if}
{elseif item.type == 'condiment' && (item.index == null || order.items[item.index].linked)}
      [&QSON]${'  '+item.name|left:15}[&QSOFF]
{elseif item.type == 'memo' && (item.index == null || order.items[item.index] == null || order.items[item.index].linked)}
{if item.index == null || order.items[item.index] == null}
{eval}
if (memo.length == 0)
    memo += ((memo.length == 0) ? '' : '\n') + item.alt_name2
{/eval}
{else}
        ${item.alt_name2|left:34}
{/if}
{/if}
{if order.batchCount == order.items[item.index].batch}
{eval}
cut_count++;
{/eval}
{/if}
{/if}
{/for}
{if cut_count > 0}
----------------------------------------
{if memo.length > 0}
${memo|left:42}
{/if}
[&CR]
[&CR]
[&CR]
[&CR]
[&CR]
[&CR]
[&CR]
[&CR]
[&CR]
[&PC]
{/if}
{/if}
