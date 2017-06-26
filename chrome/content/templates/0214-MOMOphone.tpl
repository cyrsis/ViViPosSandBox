{if hasLinkedItems}
[&INIT]
{eval}
  if (order.check_no == null || order.check_no == '') {
    check_no = '';
  }
  else {
    check_no = (order.check_no || '').toString();
    check_no = GeckoJS.String.padLeft(check_no.substring(-3), 3, '0');
  }
{/eval}
{if store.branch != ''}
[&QSON]${store.branch|center:21}[&QSOFF]
{/if}
[&DHON]$${'單據號碼:'|left:10}${order.seq|left:13}[&DHOFF]
{if customer != ''}
[&DHON]客戶姓名: ${customer.name|left:16}[&DHOFF]
[&DHON]客戶電話: ${customer.telephone|left:18}[&DHOFF]
{/if}
------------------------------------------
{for item in order.display_sequences}
{if item.type == 'item' && order.items[item.index] != null && order.items[item.index].linked}
{eval}
    firstline = _MODIFIERS['substr'](item.name, 0, 32);
    secondline = item.name.substr(firstline.length) || '';
{/eval}
{if order.items[item.index].destination == '內用'}
     [&DHON]${firstline|left:32} x${order.items[item.index].current_qty|right:3}[&DHOFF]
{else}
[&DHON]${order.items[item.index].destination|default:''|left:4} ${firstline|left:32} x${order.items[item.index].current_qty|right:3}[&DHOFF]
{/if}
{if secondline != ''}
     ....${secondline|left:30}
{/if}
{elseif item.type == 'setitem' && order.items[item.index] != null && order.items[item.index].linked}
{eval}
    firstline = _MODIFIERS['substr'](item.name, 0, 29);
    secondline = item.name.substr(firstline.length) || '';
{/eval}
     [&DHON]◎${firstline|left:29} x${order.items[item.index].current_qty|right:3}[&DHOFF]
{if secondline != ''}
     ...[&DHON]${secondline|left:28}[&DHOFF]
{/if}
{elseif item.type == 'condiment' && (item.index == null || order.items[item.index].linked)}
{eval}
  if (order.items[item.index].parent_index) {
    condimentName = '      ●' + item.name;
    firstline = _MODIFIERS['substr'](condimentName, 0, 42);
    secondline = condimentName.substr(firstline.length) || '';
    if (secondline != '') secondline = '         ..' + secondline;
  }
  else {
    condimentName = '      ●' + item.name;
    firstline = _MODIFIERS['substr'](condimentName, 0, 42);
    secondline = condimentName.substr(firstline.length) || '';
    if (secondline != '') secondline = '       ..' + secondline;
  }
{/eval}
[&DHON]${firstline|left:42}[&DHOFF]
{if secondline != ''}
[&DHON]${secondline|left:42}[&DHOFF]
{/if}
{elseif item.type == 'memo' && (item.index == null || order.items[item.index] == null || order.items[item.index].linked)}
{if item.index == null || order.items[item.index] == null}
------------------------------------------
[&DHON]訂單備註：${item.name}[&DHOFF]
{else}
[&DHON]備註：${item.name}[&DHOFF]
{/if}
{/if}
{/for}
------------------------------------------
[&DWON]${'總金額: '|right:13}${order.total|viviFormatPrices|right:6}元[&DWOFF]
${'列印時間:'|left:10}${(new Date()).toLocaleFormat('%Y-%m-%d %H:%M:%S')}
[&CR]
[&CR]
[&CR]
[&OPENDRAWER]
[&PC]
{/if}
