{if order.destination_prefix == 2111 || order.destination_prefix == 2112 || order.destination_prefix == 2121 || order.destination_prefix == 2122 || order.destination_prefix == 2211 || order.destination_prefix == 2212 || order.destination_prefix == 2221 || order.destination_prefix == 2222}
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
    if (payment.name == 'creditcard') display_name = 'creditcard';
    else if (payment.name == 'giftcard') display_name = 'giftcard';
    else if (payment.name == 'coupon') display_name = 'coupon';
    else if (payment.name == 'check') display_name = 'check';
    else display_name = 'cash';

    payment_types.push({
      name: payment.name,
      memo1: payment.memo1,
      display_name: display_name,
      amount: payment.amount
    });

    payment_types_str += display_name + ',';
  }
{/eval}
[&QSON]${store.branch|center:16}[&QSOFF]

{if store.state != ''}
[&DHON]${order.destination}[&DHOFF] [&QSON]No:${sequence|tail:2}[&QSOFF]
{else}
[&DHON]${order.destination}[&DHOFF] [&QSON]No:${sequence|tail:3}[&QSOFF]
{/if}
{if order.check_no != ''}
[&QSON]Take No: ${order.check_no}[&QSOFF]
{/if}
{if order.table_name != ''}
[&QSON]Table:${table_name|left:10}[&QSOFF]
{/if}
Date:${today|left:12} Time:${time}
Order NO: ${order.seq|left:13}    *0105
--------------------------------
${'Products'|left:19}${'Amount'|left:7}${'Price'|right:5}
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
[&DHON]${itemTrans.alt_name2|left:20}${itemTrans.current_qty|right:3}${item.current_subtotal|right:8}[&DHOFF]
{elseif item.type == 'discount'}
  ◎${item.name|left:20}${item.current_subtotal|right:7}
{elseif item.type == 'setitem'}
[&DHON]${'→'}${order.items[item.index].alt_name2|left:19}[&DHOFF]${item.current_qty|right:3}
{elseif item.type == 'condiment'}
{eval}
  if (order.items[item.index].parent_index) {
    condimentName = '' + item.name;
    firstline = _MODIFIERS['substr'](condimentName, 0, 30);
    secondline = condimentName.substr(firstline.length) || '';
    if (secondline != '') secondline = '' + secondline;
  }
  else {
    condimentName = '' + item.name;
    firstline = _MODIFIERS['substr'](condimentName, 0, 30);
    secondline = condimentName.substr(firstline.length) || '';
    if (secondline != '') secondline = '' + secondline;
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
    ${memoStr|left:21}
{/if}
{/if}
{/for}
--------------------------------
{if order.item_subtotal != order.total}
subtotal:            ${order.item_subtotal|right:10}
{if order.discount_subtotal != 0}
discount:            ${order.discount_subtotal|right:10}
{/if}
{if order.surcharge_subtotal != 0}
surcharge:           ${order.surcharge_subtotal|right:10}
{/if}
{if order.item_subtotal - order.total + order.discount_subtotal + order.surcharge_subtotal > 0}
promotion:           ${-(order.item_subtotal - order.total + order.discount_subtotal + order.surcharge_subtotal)|right:10}
{/if}
--------------------------------
{/if}
[&DHON]${'Amount:'|left:18} ${count|right:4}${txn.formatPrice(order.total)|right:8}[&DHOFF]
--------------------------------
{for payment_type in payment_types}
${payment_type.display_name + ' pay:'|left:21}${txn.formatPrice(payment_type.amount)|right:10}
{/for}
{if 0 - order.remain > 0}
[&DHON]change:              ${txn.formatPrice(0 - order.remain)|right:10}[&DHOFF]
{/if}
{if memos.length > 0}
{for memo in memos}
--------------------------------
[&DHON]Order Memo：${memo|left:19}[&DHOFF]
{/for}
{/if}
{if customer != null}
--------------------------------
Name: ${customer.name|left:26}
      ${customer.customer_id|left:26}
Tel : ${customer.telephone|left:26}
Addr: ${customer.addr1_addr1|left:26}
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