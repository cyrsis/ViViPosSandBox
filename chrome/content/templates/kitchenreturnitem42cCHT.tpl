[&INIT]
[&QSON]${'退菜單'|center:21}[&QSOFF]
[&RESET]

{if store.state != 0}
[&QSON]${'原 ' + order.destination}單號:${sequence|tail:2}[&QSOFF]
{else}
[&QSON]${'原 ' + order.destination}單號:${sequence|tail:3}[&QSOFF]
{/if}
 ${'(' + order.seq + ')'|left:36}
------------------------------------------
{for item in order.return_cart_items}
${item.current_qty|right:4} ${item.name|left:37}
{if item.condiments_string}
      ${item.condiments_string|left:40}
{/if}
{if item.memo != 0}
     ${'Return Memo:'|left:15} ${item.memo|left:34}
{/if}
{/for}
------------------------------------------
${'列印時間:'|left:10}${(new Date()).toLocaleFormat('%Y-%m-%d  %H:%M:%S')}
${'主機:'|left:5}${order.terminal_no|left:9} ${'操作人員:'|left:9}${order.service_clerk_displayname|default:''|left:14}
[&CR]
[&CR]
[&CR]
[&CR]
[&PC]
[&CR]
[&CR]
[&CR]
