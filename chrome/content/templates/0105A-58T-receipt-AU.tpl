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
  today = now.toLocaleFormat('%d/%m/%Y');
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
    if (payment.name == 'creditcard'){
	display_name = payment.memo1 + ' (+3%)';
	payment.amount = payment.amount * 103 /100;
	}
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
${store.branch}
{elseif}
請於商店資料分店名輸入此欄位
{/if}
{if store.zip != ''}
${store.zip}
{elseif}
請於商店資料郵遞區號輸入此欄位
{/if}
{if store.telephone1 != ''}${store.telephone1}{/if}{if store.telephone2 != ''}  ${store.telephone2}{/if}[&CR]
{if store.address1 != ''}
${store.address1|left:11}
{/if}
Table:${'#' + order.table_name}
Transaction No:${order.seq|left:13}
Destination:${order.destination}
${today|left:12}  ${time}
Customer No:{if order.no_of_customers > 0}${order.no_of_customers}{/if}[&CR]
--------------------------------
${'Qty'|left:6}${'Description'|left:18}${'Cost'|right:7}
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
{if itemTrans.alt_name1 != ''}
${itemTrans.current_qty|left:4}${itemTrans.alt_name1|left:18} ${item.current_subtotal|right:8}
{else}
${itemTrans.current_qty|left:4}${itemTrans.name|left:18} ${item.current_subtotal|right:8}
{/if}
{elseif item.type == 'discount'}
  ◎${item.name|left:20}${item.current_subtotal|right:7}
{elseif item.type == 'setitem'}
{if order.items[item.index].alt_name2 != ''}
${'→'}${item.current_qty|right:2}${order.items[item.index].alt_name1|left:20}
{else}
${'→'}${item.current_qty|right:2}${order.items[item.index].name|left:20}
{/if}
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
  ${firstline|left:30}
{if secondline != ''}
  ${secondline|left:30}
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
${'Amount:'|left:18} ${txn.formatPrice(order.total)|right:12}
--------------------------------
${'**** payment ****'|center:32}
{for payment_type in payment_types}
${payment_type.display_name |left:20}${txn.formatPrice(payment_type.amount)|right:11}
{if payment_type.name == 'cash'}
GST:${txn.formatPrice((order.total)/11)|right:27}
{/if}
{/for}
{if 0 - order.remain > 0}
change:              ${txn.formatPrice(0 - order.remain)|right:10}
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
Tel : ${customer.telephone|left:26}
Addr: ${customer.addr1_addr1|left:26}
{if customer.addr1_addr2 != null && customer.addr1_addr2 != ''}
    : ${customer.addr1_addr2|left:26}
{/if}
{/if}
{if store.country != ''}
[&CR]
${store.country}
{/if}
[&CR]
[&CR]
[&CR]
[&CR]
[&CR]
[&CR]
[&PC]
[&OPENDRAWER]
{/if}