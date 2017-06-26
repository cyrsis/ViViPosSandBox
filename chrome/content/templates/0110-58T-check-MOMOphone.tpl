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
  table_name = order.table_no || '';
  tablesByNo = GeckoJS.Session.get('tablesByNo');
  if (tablesByNo) {
    table = tablesByNo[order.table_no];
    if (table) {
      table_name = table.table_name;
    }
  }
  var sequenceTracksDate = GeckoJS.Configure.read('vivipos.fec.settings.SequenceTracksSalePeriod');
  var sequenceLength = GeckoJS.Configure.read('vivipos.fec.settings.SequenceNumberLength');
  sequence = order.seq.toString();
  if (sequence == null) {
    sequence = '';
  }
  else if (sequenceTracksDate) {
    sequence = sequence.substr(-sequenceLength);
  }
  now = new Date();
  today = now.toLocaleFormat('%Y/%m/%d');
  time = now.toLocaleFormat('%H:%M');
  terminal = order.terminal_no;
  index = 0;
  count = 0;
  memos = [];
{/eval}
{if store.branch != ''}
[&QSON]${store.branch|center:16}[&QSOFF]
[&CR]
{/if}
[&DHON]${'單據號碼:'|left:10}${order.seq|left:13}[&DHOFF]    *0110
{if customer != null}
[&DHON]    客戶姓名: ${customer.name|left:16}[&DHOFF]
{if customer.telephone != ''}
[&DHON]    客戶電話: ${customer.telephone|left:16}[&DHOFF]
{else}
[&DHON]    客戶電話: ${customer.customer_id|left:16}[&DHOFF]
{/if}
{/if}
--------------------------------
${'商品名稱'|left:20}${'數量'|left:6}${'價格'|right:6}
--------------------------------
{for item in order.display_sequences}
{if item.type == 'item' && order.items[item.index] != null && order.items[item.index].linked}
{eval}
    firstline = _MODIFIERS['substr'](item.name, 0, 26);
    secondline = item.name.substr(firstline.length) || '';
    firstline1 = _MODIFIERS['substr'](order.items[item.index].alt_name1, 0, 26);
    secondline1 = order.items[item.index].alt_name1.substr(firstline1.length) || '';
{/eval}
[&DHON]${firstline|left:20}x${order.items[item.index].current_qty|right:3}${item.current_subtotal|right:7}[&DHOFF]
{if secondline != ''}
   ...[&DHON]${secondline|left:22}[&DHOFF]
{/if}
{elseif item.type == 'discount' || item.type == 'surcharge'}
  ◎${item.name|left:20}${item.current_subtotal|right:7}
{elseif item.type == 'condiment' && (item.index == null || order.items[item.index].linked)}
{eval}
  if (order.items[item.index].parent_index) {
    condimentName = '●' + item.name;
    firstline = _MODIFIERS['substr'](condimentName, 0, 30);
    secondline = condimentName.substr(firstline.length) || '';
    if (secondline != '') secondline = '  ' + secondline;
  }
  else {
    condimentName = '●' + item.name;
    firstline = _MODIFIERS['substr'](condimentName, 0, 30);
    secondline = condimentName.substr(firstline.length) || '';
    if (secondline != '') secondline = '  ' + secondline;
  }
{/eval}
{if store.county != ''}
  [&DHON]${firstline|left:30}[&DHOFF]
{if secondline != ''}
  [&DHON]${secondline|left:30}[&DHOFF]
{/if}
{elseif}
  ${firstline|left:30}
{if secondline != ''}
  ${secondline|left:30}
{/if}
{/if}
{elseif item.type == 'memo' && (item.index == null || order.items[item.index] == null || order.items[item.index].linked)}
{if item.index == null || order.items[item.index] == null}
--------------------------------
[&DHON]訂單備註：${item.name}[&DHOFF]
{else}
  [&DHON]●${item.name}[&DHOFF]
{/if}
{/if}
{/for}
--------------------------------
{if order.discount_subtotal != 0}
折扣總金額：         ${order.discount_subtotal|right:10}
{/if}
{if order.surcharge_subtotal != 0}
服務費金額：         ${order.surcharge_subtotal|right:10}
{/if}
{if order.item_subtotal - order.total + order.discount_subtotal + order.surcharge_subtotal > 0}
促銷總金額：         ${-(order.item_subtotal - order.total + order.discount_subtotal + order.surcharge_subtotal)|right:10}
{/if}
[&DHON]${'總計:'|left:20}${order.total|right:9}元[&DHOFF]
${'列印時間:'|left:10}${(new Date()).toLocaleFormat('%Y-%m-%d %H:%M:%S')}
[&CR]
[&CR]
[&CR]
[&PC]
[&OPENDRAWER]
{/if}
{/if}