{if order.destination_prefix == 1112 || order.destination_prefix == 1122 || order.destination_prefix == 1212 || order.destination_prefix == 1222 || order.destination_prefix == 2112 || order.destination_prefix == 2122 || order.destination_prefix == 2212 || order.destination_prefix == 2222}
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
payment_types = [];
payment_types_str = '';
for (key in order.trans_payments) {
    payment = order.trans_payments[key];
    if (payment.name == 'creditcard') display_name = '信用卡';
    else if (payment.name == 'giftcard') display_name = '禮券';
    else if (payment.name == 'coupon') display_name = '折價券';
    else if (payment.name == 'check') display_name = '支票';
    else display_name = '現金';

    payment_types.push({
      name: payment.name,
      memo1: payment.memo1,
      display_name: display_name,
      amount: payment.amount
    });

    payment_types_str += display_name + ',';
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
[&QSON]${store.branch|center:16}[&QSOFF]
[&CR]
{if store.state != ''}
[&QSON]${order.destination}單號:${sequence|tail:2}[&QSOFF]
{if order.table_name != ''}
[&QSON]桌名:${table_name}[&QSOFF]
{/if}
{else}
[&QSON]${order.destination}單號:${sequence|tail:3}[&QSOFF]
{if order.table_name != ''}
[&QSON]桌名:${table_name}[&QSOFF]
{/if}
{/if}
${'單據號碼:'|left:10}${order.seq|left:13}   *0108C
${'服務人員:'|left:10}${order.service_clerk_displayname|left:8}
--------------------------------
${'商品名稱'|left:20}${'數量'|left:6}${'價格'|right:6}
--------------------------------
{for item in order.display_sequences}
{if item.type == 'item' && order.items[item.index] != null && order.items[item.index].linked}
{eval}
    firstline = _MODIFIERS['substr'](item.name, 0, 20);
    secondline = item.name.substr(firstline.length) || '';
	itemTrans = order.items[item.index];
	count += parseInt(itemTrans.current_qty);
{/eval}
${firstline|left:20}x${order.items[item.index].current_qty|right:3}${item.current_subtotal|right:7}
{if secondline != ''}
..${secondline|left:20}
{/if}
{elseif item.type == 'setitem' && order.items[item.index] != null && order.items[item.index].linked}
{eval}
    firstline = _MODIFIERS['substr'](item.name, 0, 18);
    secondline = item.name.substr(firstline.length) || '';
{/eval}
→${firstline|left:18}x${order.items[item.index].current_qty|right:3}${item.current_subtotal|right:7}
{if secondline != ''}
  ..${secondline|left:18}
{/if}
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
${firstline|left:30}
{if secondline != ''}
  ${secondline|left:28}
{/if}
{elseif item.type == 'memo' && (item.index == null || order.items[item.index] == null || order.items[item.index].linked)}
{if item.index == null || order.items[item.index] == null}
--------------------------------
訂單備註：${item.name}
{else}
${item.name}
{/if}
{/if}
{/for}
--------------------------------
[&DHON]${'總計:'|left:20}${count|right:3}${order.total|right:6}元[&DHOFF]
{for payment_type in payment_types}
{/for}
{if 0 - order.remain > 0}
[&DHON]找零:                ${0 - order.remain|right:9}[&DHOFF]
{/if}
{if customer != null}
--------------------------------
名稱: ${customer.name|left:26}
      ${customer.customer_id|left:26}
電話: ${customer.telephone|left:26}
地址: ${customer.addr1_addr1|left:26}
{if customer.addr1_addr2 != null && customer.addr1_addr2 != ''}
    : ${customer.addr1_addr2|left:26}
{/if}
{/if}
{if store.country != ''}
[&CR]
${store.country|center:32}
{/if}
[&CR]
[&CR]
[&CR]
[&PC]
[&OPENDRAWER]
{/if}
{/if}