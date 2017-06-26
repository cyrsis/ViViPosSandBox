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
[&DWON]${store.branch|center:21}[&DWOFF]
{/if}
{if store.zip != ''}
${store.zip}
{/if}
{if store.telephone1 != ''}${store.telephone1}{/if}{if store.telephone2 != ''}  ${store.telephone2}{/if}[&CR]
{if store.address1 != ''}
${store.address1|left:11}
{/if}
{if order.table_name != ''}
Table:${'#' + order.table_name}
{/if}
[&OSON]NO: ${order.seq|tail:2}[&OSOFF]
Destination: ${order.destination}
   ${today|left:12}  ${time}
------------------------------------------
${'Description'|left:29}${'Qty'|left:5}${'Cost'|right:8}
------------------------------------------
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
${itemTrans.name|left:42}
                            ${'x ' + itemTrans.current_qty|right:4}${item.current_subtotal|right:10}
{elseif item.type == 'discount'}
  ◎${item.name|left:28}${item.current_subtotal|right:10}
{elseif item.type == 'setitem'}
{if order.items[item.index].alt_name2 != ''}
${'→'}${item.current_qty|right:2}${order.items[item.index].alt_name1|left:24}
{else}
${'→'}${item.current_qty|right:2}${order.items[item.index].name|left:24}
{/if}
{elseif item.type == 'condiment'}
{eval}
  if (order.items[item.index].parent_index) {
    condimentName = '' + item.name + '(' + item.current_subtotal + ')';
    firstline = _MODIFIERS['substr'](condimentName, 0, 28);
    secondline = condimentName.substr(firstline.length) || '';
    if (secondline != '') secondline = '' + secondline;
  }
  else {
    condimentName = '' + item.name;
    firstline = _MODIFIERS['substr'](condimentName, 0, 28);
    secondline = condimentName.substr(firstline.length) || '';
    if (secondline != '') secondline = '' + secondline;
  }
{/eval}
  ●${firstline|left:38}
{if secondline != ''}
    ${secondline|left:38}
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
    ${memoStr|left:32}
{/if}
{/if}
{/for}
------------------------------------------
{if order.item_subtotal != order.total}
Subtotal:         ${txn.formatPrice(order.item_subtotal)|right:24}
{if order.discount_subtotal != 0}
discount:         ${txn.formatPrice(order.discount_subtotal)|right:24}
{/if}
{if order.surcharge_subtotal != 0}
surcharge:        ${txn.formatPrice(order.surcharge_subtotal)|right:24}
{/if}
{if order.item_subtotal - order.total + order.discount_subtotal + order.surcharge_subtotal > 0}
promotion:        ${txn.formatPrice((-(order.item_subtotal - order.total + order.discount_subtotal + order.surcharge_subtotal)))|right:24}
{/if}
{if order.tax_subtotal != 0}
Tax:              ${txn.formatPrice(order.tax_subtotal)|right:24}
{/if}
------------------------------------------
{/if}
{eval}
  for (key in order.items_tax_details) {
    tax = order.items_tax_details[key];  
	  }
{/eval}
${'Subtotal：'|left:18}${tax.taxable_amount|viviFormatPrices:true|viviFormatTaxes:true|right:24}
${'Sales Tax：'|left:18}${tax.included_tax_subtotal|viviFormatTaxes:true|right:24}
${'Amount:'|left:18}${txn.formatPrice(order.total)|right:24}
------------------------------------------
${'**** payment ****'|center:42}
{for payment_type in payment_types}
${payment_type.display_name |left:18}${txn.formatPrice(payment_type.amount)|right:24}
{/for}
{if 0 - order.remain > 0}
change:           ${txn.formatPrice(0 - order.remain)|right:24}
{/if}
{if memos.length > 0}
{for memo in memos}
Order Memo：${memo|left:30}
{/for}
{/if}
{if customer != null}
------------------------------------------
Name: ${customer.name + ' (' + customer.customer_id + ')'|left:36}
Tel : ${customer.addr1_tel1|left:36}
Addr: ${customer.addr1_addr1|left:36}
{if customer.addr1_addr2 != null && customer.addr1_addr2 != ''}
    : ${customer.addr1_addr2|left:36}
{/if}
{/if}
Service: ${order.service_clerk_displayname}[&CR]
{if store.country != ''}
${store.country|center:42}
{/if}
[&CR]
[&CR]
[&CR]
[&CR]
[&PC]
[&OPENDRAWER]
{/if}