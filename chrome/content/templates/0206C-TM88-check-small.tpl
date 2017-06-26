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
{if duplicate}
[&QSON]${store.branch|center:21}[&QSOFF]
{else}
[&QSON]${store.branch|center:21}[&QSOFF]
{/if}
[&CR]
[&QSON]${order.destination|left:4}:${order.table_name|default:''|left:7} ${'單號'|left:4}:${order.seq|tail:3}[&QSOFF]
${'單據號碼:'|left:10}${order.seq|left:13} ${'服務人員:'|left:10}${order.service_clerk_displayname|left:8}
------------------------------------------
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
    firstline = _MODIFIERS['substr'](itemName, 0, 40);
    secondline = itemName.substr(firstline.length) || '';
{/eval}
[&QSON]${firstline|left:18}x${item.current_qty|right:3}[&QSOFF]
{if secondline != ''}
[&QSON]...${secondline|left:30}[&QSOFF]
{/if}
{elseif item.type == 'setitem' && order.items[item.index] != null && order.items[item.index].linked}
{eval}
    if (item.conds) {
      itemName = item.name + '(' + item.conds + ')';
    } else {
      itemName = item.name;
    }
    firstline = _MODIFIERS['substr'](itemName, 0, 29);
    secondline = itemName.substr(firstline.length) || '';
{/eval}
[&QSON]◎${firstline|left:16}x${order.items[item.index].current_qty|right:3}[&QSOFF]
{if secondline != ''}
...[&QSON]${secondline}[&QSOFF]
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
[&QSON]${'總金額: '|right:13}${order.total|viviFormatPrices|right:9}[&QSOFF]
${'列印時間:'|left:10}${(new Date()).toLocaleFormat('%m-%d %H:%M:%S')}   ${'*0206C'|right:14}
[&CR]
[&CR]
[&CR]
[&OPENDRAWER]
[&PC]
{/if}
{/if}