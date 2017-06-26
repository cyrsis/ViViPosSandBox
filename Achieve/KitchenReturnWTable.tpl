[&INIT]
[&QSON]${'Return Item'|center:21}[&QSOFF]
[&CR]
[&RESET]${'Printed:'|left:10} ${(new Date()).toLocaleFormat('%Y-%m-%d %H:%M:%S')}
${'Terminal:'|left:10} ${order.terminal_no|left:9} ${'Clerk:'|left:6} ${order.service_clerk_displayname|default:''|left:14}
${'Check:'|left:10} ${order.check_no|default:''|left:9} ${'Seq:'|left:6} ${order.seq|tail:3}
[&CR]
[&QSON]${'Table:' + order.table_name} ${'No#:'+ order.check_no}
------------------------------------------
{for item in order.return_cart_items}
${item.current_qty|right:4} ${item.name|left:37}
{if item.condiments_string}
      ${item.condiments_string|left:40}
{/if}
{/for}
------------------------------------------
[&CR]
[&CR]
[&CR]
[&CR]
[&PC]
[&CR]
[&CR]
[&CR]
