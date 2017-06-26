{if order.destination_prefix == 1211 || order.destination_prefix == 1212 || order.destination_prefix == 1221 || order.destination_prefix == 1222 || order.destination_prefix == 2211 || order.destination_prefix == 2212 || order.destination_prefix == 2221 || order.destination_prefix == 2222}
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
{eval}
  total = 0;
  newItems = {};
  for (itemKey in order.display_sequences) {
    item = order.display_sequences[itemKey]
    conds = '';
    memo = '';
    if ((item.type == 'item' || item.type == 'setitem') && order.items[item.index] != null && order.items[item.index].linked) {
      for (condKey in order.items[item.index].collapsedCondiments) {
        conds = condKey;
      }
      memo = order.items[item.index].memo;
    
      key = order.items[item.index].no + conds + memo;
      if (newItems[key] && (newItems[key].conds == conds) && (newItems[key].memo == memo)) {
        newItems[key].current_qty += order.items[item.index].current_qty;
      } else {
        newItems[key] = GREUtils.extend({}, order.items[item.index]);
        newItems[key].conds = conds;
      }
      total += order.items[item.index].current_qty;
    } else if (order.items[item.index] == null) {
      newItems[item.index] = GREUtils.extend({}, item);
    }
  }
{/eval}
[&QSON]${store.branch|center:16}[&QSOFF]
[&CR]
[&QSON]${order.destination}單號:${order.seq|tail:3}[&QSOFF]
${'單據號碼:'|left:10}${order.seq|left:13}   *0108B
${'點單人員:'|left:10}${order.service_clerk_displayname}
--------------------------------
{for item in newItems}
{if item.type == 'item' && order.items[item.index] != null && order.items[item.index].linked}
{eval}
    if (item.conds) {
      itemName = item.name + '(' + item.conds + ')';
    } else {
      itemName = item.name;
    }
    if (item.memo) {
      itemName += '<' + item.memo + '>';
    }
    firstline = _MODIFIERS['substr'](itemName, 0, 28);
    secondline = itemName.substr(firstline.length) || '';
{/eval}
[&DHON]${firstline|left:28}x${item.current_qty|right:3}[&DHOFF]
{if secondline != ''}
[&DHON]..${secondline|left:30}[&DHOFF]
{/if}
{elseif item.type == 'setitem' && order.items[item.index] != null && order.items[item.index].linked}
{eval}
    if (item.conds) {
      itemName = item.name + '(' + item.conds + ')';
    } else {
      itemName = item.name;
    }
    firstline = _MODIFIERS['substr'](itemName, 0, 24);
    secondline = itemName.substr(firstline.length) || '';
{/eval}
  [&DHON]◎${firstline|left:24}x${order.items[item.index].current_qty|right:3}[&DHOFF]
{if secondline != ''}
  ...[&DHON]${secondline|left:26}[&DHOFF]
{/if}
{elseif item.type == 'memo' && (item.index == null || order.items[item.index] == null || order.items[item.index].linked)}
{if item.index == null || order.items[item.index] == null}
--------------------------------
[&DHON]訂單備註：${item.name}[&DHOFF]
{else}
[&DHON]備註：${item.name}[&DHOFF]
{/if}
{/if}
{/for}
--------------------------------
[&DWON]${'總金額: '|left:8}${order.total|viviFormatPrices|right:6}元[&DWOFF]
${'列印時間:'|left:10}${(new Date()).toLocaleFormat('%Y-%m-%d %H:%M:%S')}
[&CR]
[&CR]
[&CR]
[&PC]
[&OPENDRAWER]
{/if}
{/if}