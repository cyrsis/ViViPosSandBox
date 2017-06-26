[&INIT]
{eval}
  clerk = order.proceeds_clerk_displayname;
  if (clerk == null || clerk == '') {
    clerk = order.service_clerk_displayname;
  }
  if (clerk == null) {
    clerk = '';
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
{eval}
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
{/eval}
{eval} 
  destination_prefix = order.destination_prefix;
{/eval}
{if destination_prefix == 2111 || destination_prefix == 2112 || destination_prefix == 2121 || destination_prefix == 2122 || destination_prefix == 2211 || destination_prefix == 2212 || destination_prefix == 2221 || destination_prefix == 2222}
[&QSON]${store.branch|center:16}[&QSOFF]

{if store.state == 112 || store.state == 122 || store.state == 132 || store.state == 212 || store.state == 222 || store.state == 232 || store.state == 312 || store.state == 322 || store.state == 332}
[&QSON]${order.destination}單號:${sequence|tail:2}[&QSOFF]
{else}
[&QSON]${order.destination}單號:${sequence|tail:3}[&QSOFF]
{/if}
{if order.check_no != ''}
[&QSON]取餐牌號: ${order.check_no}[&QSOFF]
{/if}
{if order.table_name != ''}
[&QSON]桌名:${table_name|left:10}[&QSOFF]
{/if}
日期:${today|left:12}時間:${time}
交易序號: ${order.seq|left:13}
--------------------------------
${'商品名稱'|left:20}${'數量'|left:6}${'價格'|right:6}
--------------------------------
{for item in order.display_sequences}
{if item.type == 'item'}
{eval}
  condStr = '';
  itemTrans = order.items[item.index];
  condiments = itemTrans.condiments;
  count += parseInt(itemTrans.current_qty);
  if (condiments != null) {
    condStr = GeckoJS.BaseObject.getKeys(condiments).join(';');
  }
{/eval}
{eval}
    firstline = _MODIFIERS['substr'](item.name, 0, 24);
    secondline = item.name.substr(firstline.length) || '';
	firstline1 = _MODIFIERS['substr'](order.items[item.index].alt_name1, 0, 24);
    secondline1 = order.items[item.index].alt_name1.substr(firstline1.length) || '';
	itemTrans = order.items[item.index];
	count += parseInt(itemTrans.current_qty);
{/eval}
{if store.state == 312 || store.state == 313 || store.state == 322 || store.state == 323 || store.state == 332 || store.state == 333}
{if itemTrans.alt_name1 != ''}
[&QSON]${firstline1|left:12}[&QSOFF][&DHON]${itemTrans.current_qty|right:3}${item.current_subtotal|right:5}[&DHOFF]
{if secondline1 != ''}
[&QSON]${secondline1|left:12}[&QSOFF]
{/if}
{else}
[&QSON]${firstline|left:12}[&QSOFF][&DHON]${itemTrans.current_qty|right:3}${item.current_subtotal|right:5}[&DHOFF]
{if secondline != ''}
[&QSON]${secondline|left:12}[&QSOFF]
{/if}
{/if}
{elseif store.state == 212 || store.state == 213 || store.state == 222 || store.state == 223 || store.state == 232 || store.state == 233}
{if itemTrans.alt_name1 != ''}
[&DHON]${firstline1|left:24}${itemTrans.current_qty|right:3}${item.current_subtotal|right:5}[&DHOFF]
{if secondline1 != ''}
[&DHON]${secondline1|left:24}[&DHOFF]
{/if}
{else}
[&DHON]${firstline|left:24}${itemTrans.current_qty|right:3}${item.current_subtotal|right:5}[&DHOFF]
{if secondline != ''}
[&DHON]${secondline|left:24}[&DHOFF]
{/if}
{/if}
{else}
{if itemTrans.alt_name1 != ''}
${firstline1|left:24}${itemTrans.current_qty|right:3}${item.current_subtotal|right:5}
{if secondline1 != ''}
${secondline1|left:24}
{/if}
{else}
${firstline|left:24}${itemTrans.current_qty|right:3}${item.current_subtotal|right:5}
{if secondline != ''}
${secondline|left:24}
{/if}
{/if}
{/if}
{elseif item.type == 'discount' || item.type == 'surcharge'}
  ◎${item.name|left:20}${item.current_subtotal|right:7}
{elseif item.type == 'setitem'}
{eval}
    firstline = _MODIFIERS['substr'](item.name, 0, 22);
    secondline = item.name.substr(firstline.length) || '';
	firstline1 = _MODIFIERS['substr'](order.items[item.index].alt_name1, 0, 22);
    secondline1 = order.items[item.index].alt_name1.substr(firstline1.length) || '';
{/eval}
{if store.state == 312 || store.state == 313 || store.state == 322 || store.state == 323 || store.state == 332 || store.state == 333}
{if order.items[item.index].alt_name1 != ''}
[&QSON]${'→'}${firstline1|left:14}[&QSOFF]
{if secondline1 != ''}
[&QSON]  ${secondline1|left:14}[&QSOFF]
{/if}
{else}
[&QSON]${'→'}${firstline|left:14}[&QSOFF]
{if secondline != ''}
[&QSON]  ${secondline|left:14}[&QSOFF]
{/if}
{/if}
{elseif store.state == 212 || store.state == 213 || store.state == 222 || store.state == 223 || store.state == 232 || store.state == 233}
{if order.items[item.index].alt_name1 != ''}
[&DHON]${'→'}${firstline1|left:28}[&DHOFF]
{if secondline1 != ''}
[&DHON]  ${secondline1|left:28}[&DHOFF]
{/if}
{else}
[&DHON]${'→'}${firstline|left:28}[&DHOFF]
{if secondline != ''}
[&DHON]  ${secondline|left:28}[&DHOFF]
{/if}
{/if}
{else}
{if order.items[item.index].alt_name1 != ''}
${'→'}${firstline1|left:28}
{if secondline1 != ''}
  ${secondline1|left:28}
{/if}
{else}
${'→'}${firstline|left:28}
{if secondline != ''}
  ${secondline|left:28}
{/if}
{/if}
{/if}
{elseif item.type == 'condiment'}
{eval}
  if (order.items[item.index].parent_index) {
    condimentName = '●' + item.name;
    firstline = _MODIFIERS['substr'](condimentName, 0, 32);
    secondline = condimentName.substr(firstline.length) || '';
    if (secondline != '') secondline = '' + secondline;
  }
  else {
    condimentName = '●' + item.name;
    firstline = _MODIFIERS['substr'](condimentName, 0, 32);
    secondline = condimentName.substr(firstline.length) || '';
    if (secondline != '') secondline = '' + secondline;
  }
{/eval}
{if store.state == 132 || store.state == 133 || store.state == 232 || store.state == 233 || store.state == 332 || store.state == 333}
[&QSON]${firstline|left:16}[&QSOFF]
{if secondline != ''}
[&QSON]  ${secondline|left:14}[&QSOFF]
{/if}
{elseif store.state == 122 || store.state == 123 || store.state == 222 || store.state == 223 || store.state == 322 || store.state == 323}
[&DHON]${firstline|left:32}[&DHOFF]
{if secondline != ''}
[&DHON]${secondline|left:32}[&DHOFF]
{/if}
{else}
${firstline|left:32}
{if secondline != ''}
${secondline|left:32}
{/if}
{/if}
{elseif item.type == 'memo'}
{eval}
  memoStr = '';
  itemTrans = order.items[item.index];
  if (itemTrans == null) {
      memos.push(item.name);
  }
  else {
    memoStr = item.name;
  }
{/eval}
{if memoStr != ''}
    ${memoStr|left:22}
{/if}
{/if}
{/for}
--------------------------------
{if order.item_subtotal != order.total}
原始總金額：         ${order.item_subtotal|right:10}
{if order.discount_subtotal != 0}
折扣總金額:　        ${order.discount_subtotal|right:10}
{/if}
{if order.surcharge_subtotal != 0}
服務費金額:　        ${order.surcharge_subtotal|right:10}
{/if}
{if order.item_subtotal - order.total + order.discount_subtotal + order.surcharge_subtotal > 0}
促銷總金額:          ${-(order.item_subtotal - order.total + order.discount_subtotal + order.surcharge_subtotal)|right:10}
{/if}
--------------------------------
{/if}
[&DHON]${'總計:'|left:20}${count|right:3}${order.total|right:6}元[&DHOFF]
--------------------------------
{for payment_type in payment_types}
${payment_type.display_name + '付款:'|left:20}${payment_type.amount|right:10}
{/for}
{if (0 - order.remain) > 0}
[&DHON]找零:                ${(0 - order.remain)|right:9}[&DHOFF]
{/if}
{if memos.length > 0}
{for memo in memos}
--------------------------------
[&DHON]訂單備註：${memo|left:21}[&DHOFF]
{/for}
{/if}
{if customer != null}
--------------------------------
名稱: ${customer.name|left:18}
電話: ${customer.telephone|left:18}
地址: ${customer.addr1_addr1}
{if customer.addr1_addr2 != null && customer.addr1_addr2 != ''}
    : ${customer.addr1_addr2|left:18}
{/if}
{if customer.addr1_city != null && customer.addr1_city != ''}
    : ${customer.addr1_city|left:18}
{/if}
{/if}
{if store.state != ''}
    [&QSON]${store.state}[&QSOFF]
{/if}
{if store.county != ''}
    [&QSON]${store.county}[&QSOFF]
{/if}
{if store.city != ''}
    [&QSON]${store.city}[&QSOFF]
{/if}
{if store.zip != ''}
    [&QSON]${store.zip}[&QSOFF]
{/if}
{if store.country != ''}
[&CR]
${store.country|center:32}
{/if}
[&CR]
[&CR]
[&CR]
[&CR]
[&PC]
{/if}