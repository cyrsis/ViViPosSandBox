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
  today = now.toLocaleFormat('%m/%d/%Y');
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
{if store.branch != ''}
[&QSON]${store.branch|center:16}[&QSOFF]
{/if}
{if store.address1 != ''}
{eval}
    infor = store.zip + '  ' + store.address1;
    firstline = _MODIFIERS['substr'](infor, 0, 32);
    secondline = infor.substr(firstline.length) || '';
{/eval}
${firstline|left:32}
{if secondline != ''}
${secondline|left:32}
{/if}
{/if}
{if store.telephone1 != ''}${store.telephone1}{/if}{if store.telephone2 != ''}  ${store.telephone2}{/if}[&CR]
--------------------------------
${today + '  ' + time|center:32}
{if order.table_name != ''}
Table:${'#' + order.table_name}
{/if}
[&DWON]NO:${order.seq|tail:2}[&DWOFF]       ${order.destination}
Order No: ${order.seq|left:13}
Service: ${order.service_clerk_displayname}
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
${itemTrans.name|left:32}
{if itemTrans.alt_name1 != ''}
${itemTrans.alt_name1|left:20}${'x ' + itemTrans.current_qty|right:4}${item.price_level1|right:8}
{else}
                    ${'x ' + itemTrans.current_qty|right:4}${txn.formatPrice(itemTrans.current_price)|right:8}
{/if}
{elseif item.type == 'discount'}
  ◎${item.name|left:20}
{elseif item.type == 'setitem'}
{if order.items[item.index].alt_name2 != ''}
${'→'}${item.current_qty|right:2}${order.items[item.index].alt_name1|left:20}
{else}
${'→'}${item.current_qty|right:2}${order.items[item.index].name|left:20}
{/if}
{elseif item.type == 'condiment'}
${'●' + item.name + '(' + item.current_qty + ')'|left:25}{if item.current_price != 0}${item.current_price|right:7}{/if}[&CR]
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
{eval}
   nottaxtotal = order.item_subtotal - order.tax_subtotal
{/eval}
subtotal:         ${txn.formatPrice(order.item_subtotal)|right:14}
${'GST 5%'|left:18}${txn.formatPrice(order.item_subtotal * 0.05)|right:14}
${'PST 7%'|left:18}${txn.formatPrice(order.item_subtotal * 0.07)|right:14}
{if order.discount_subtotal != 0}
discount:         ${txn.formatPrice(order.discount_subtotal * 1.12)|right:14}
{/if}
{if order.surcharge_subtotal != 0}
surcharge:        ${txn.formatPrice(order.surcharge_subtotal) * 1.12|right:14}
{/if}
{if order.item_subtotal - order.total + order.discount_subtotal + order.surcharge_subtotal > 0}
promotion:        ${txn.formatPrice((-(order.item_subtotal - order.total + order.discount_subtotal + order.surcharge_subtotal))) * 1.12|right:14}
{/if}
${'Total:'|left:18}${txn.formatPrice(order.total)|right:14}
--------------------------------
{for payment_type in payment_types}
${payment_type.display_name |left:18}${txn.formatPrice(payment_type.amount)|right:14}
{/for}
{if 0 - order.remain > 0}
change:           ${txn.formatPrice(0 - order.remain)|right:14}
{/if}
{if memos.length > 0}
{for memo in memos}
Order Memo：${memo|left:19}
{/for}
{/if}
{if customer != null}
--------------------------------
Name: ${customer.name|left:26}
      ${customer.customer_id|left:26}
Tel : ${customer.addr1_tel1|left:26}
Addr: ${customer.addr1_addr1|left:26}
{if customer.addr1_addr2 != null && customer.addr1_addr2 != ''}
    : ${customer.addr1_addr2|left:26}
{/if}
{/if}
{eval}
    firstline = _MODIFIERS['substr'](store.country, 0, 32);
    secondline = store.country.substr(firstline.length) || '';
{/eval}
{if store.country != ''}
[&CR]
${firstline|center:32}
{if secondline != ''}
${secondline|center:32}
{/if}
{/if}
[&CR]
[&CR]
[&CR]
[&PC]
[&OPENDRAWER]
{/if}