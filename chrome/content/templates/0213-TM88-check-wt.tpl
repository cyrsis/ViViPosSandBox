{if order.destination == '外送'}
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
  sequence = order.seq.toString();
  if (sequence == null) {
    sequence = '';
  }
  else {
    sequence = sequence.substr(-4);
  }
  now = new Date();
  today = now.toLocaleFormat('%Y/%m/%d');
  time = now.toLocaleFormat('%H:%M:%S');
  terminal = order.terminal_no;
  qty_subtotal = order.qty_subtotal;
  footnote = store.note || '';
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
    else if (payment.name == 'cash') display_name = '現金';

    payment_types.push({
      name: payment.name,
      memo1: payment.memo1,
      display_name: display_name,
      amount: payment.amount
    });

    payment_types_str += display_name + ',';
  }
{/eval}
{if order.destination != null && order.destination != ''}
{/if}
門市：${store.name + store.branch |left:20} [&DWON]${'●' + order.destination|left:6}[&DWOFF]
{if footnote != ''}${footnote|center:36}{/if}
{if store.address1 != ''}${store.address1 + store.address2 |center:36}{/if}
[&QSON]${'單號：' + sequence|center:18}[&QSOFF]
日期：${today|left:16} 時間：${time}
------------------------------------------
${'商品名稱'|left:14} ${'數量'|left:6} ${'金額'|right:8}
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
${itemTrans.name|left:20}${itemTrans.current_qty|left:10}${item.current_subtotal|right:8}
{elseif item.type == 'discount' || item.type == 'surcharge'}
  ◎${item.name|left:30}${item.current_subtotal|right:10}
{elseif item.type == 'setitem'}
${'→'}${item.name|left:26}${item.current_qty|right:6}
{elseif item.type == 'condiment'}
{eval}
  if (order.items[item.index].parent_index) {
    condimentName = '●' + item.name;
    firstline = _MODIFIERS['substr'](condimentName, 0, 28);
    secondline = condimentName.substr(firstline.length) || '';
    if (secondline != '') secondline = '  ' + secondline;
  }
  else {
    condimentName = '●' + item.name;
    firstline = _MODIFIERS['substr'](condimentName, 0, 28);
    secondline = condimentName.substr(firstline.length) || '';
    if (secondline != '') secondline = '  ' + secondline;
  }
{/eval}
  ${firstline|left:30}
{if secondline != ''}
  ${secondline|left:30}
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
    ${memoStr|left:38}
{/if}
{/if}
{/for}
------------------------------------------
原始總金額:      ${order.item_subtotal|right:21}
{if order.discount_subtotal != 0}
折扣總金額:　    ${order.discount_subtotal|right:21}
{/if}
{if order.surcharge_subtotal != 0}
服務費金額:　    ${order.surcharge_subtotal|right:21}
{/if}
{for payment_type in payment_types}
${payment_type.display_name + '付款:'|left:17}${payment_type.amount|viviFormatPrices:true|right:21}
{/for}
{if (0 - order.remain) > 0}
找零:            ${(0 - order.remain)|right:21}
{/if}
------------------------------------------
${'總計:'|left:16}${count|right:3}項           [&DHON]${order.total|right:5}元[&DHOFF]
{if memos.length > 0}
{for memo in memos}
------------------------------------------
[&DHON]訂單備註：${memo}[&DHOFF]
{/for}
{/if}
{if customer != null}
------------------------------------------
名稱: ${customer.name|left:36}
電話: {if customer.telephone != ''} ${customer.telephone|left:42}{else} ${customer.customer_id|left:42}{/if}
地址: ${customer.addr1_addr1}
{if customer.addr1_addr2 != null && customer.addr1_addr2 != ''}
    : ${customer.addr1_addr2|left:36}
{/if}
{if customer.addr1_city != null && customer.addr1_city != ''}
    : ${customer.addr1_city|left:36}
{/if}
{/if}
{if order.annotations != null}
{for ann in order.annotations}
${ann|center:42}
{/for}
{/if}
${'謝謝光臨，歡迎您再度蒞臨'|center:42}
[&CR]
[&CR]
[&OPENDRAWER]
[&PC]
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
  sequence = order.seq.toString();
  if (sequence == null) {
    sequence = '';
  }
  else {
    sequence = sequence.substr(-4);
  }
  now = new Date();
  today = now.toLocaleFormat('%Y/%m/%d');
  time = now.toLocaleFormat('%H:%M:%S');
  terminal = order.terminal_no;
  qty_subtotal = order.qty_subtotal;
  footnote = store.note || '';
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
    else if (payment.name == 'cash') display_name = '現金';

    payment_types.push({
      name: payment.name,
      memo1: payment.memo1,
      display_name: display_name,
      amount: payment.amount
    });

    payment_types_str += display_name + ',';
  }
{/eval}
{if order.destination != null && order.destination != ''}
{/if}
門市：${store.name + store.branch |left:20} [&DWON]${'●' + order.destination|left:6}[&DWOFF]
{if footnote != ''}${footnote|center:36}{/if}
{if store.address1 != ''}${store.address1 + store.address2 |center:36}{/if}
[&QSON]${'單號：' + sequence|center:18}[&QSOFF]
日期：${today|left:16} 時間：${time}
------------------------------------------
${'商品名稱'|left:14} ${'數量'|left:6} ${'金額'|right:8}
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
${itemTrans.name|left:20}${itemTrans.current_qty|left:10}${item.current_subtotal|right:8}
{elseif item.type == 'discount' || item.type == 'surcharge'}
  ◎${item.name|left:30}${item.current_subtotal|right:10}
{elseif item.type == 'setitem'}
${'→'}${item.name|left:26}${item.current_qty|right:6}
{elseif item.type == 'condiment'}
{eval}
  if (order.items[item.index].parent_index) {
    condimentName = '●' + item.name;
    firstline = _MODIFIERS['substr'](condimentName, 0, 28);
    secondline = condimentName.substr(firstline.length) || '';
    if (secondline != '') secondline = '  ' + secondline;
  }
  else {
    condimentName = '●' + item.name;
    firstline = _MODIFIERS['substr'](condimentName, 0, 28);
    secondline = condimentName.substr(firstline.length) || '';
    if (secondline != '') secondline = '  ' + secondline;
  }
{/eval}
  ${firstline|left:30}
{if secondline != ''}
  ${secondline|left:30}
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
    ${memoStr|left:38}
{/if}
{/if}
{/for}
------------------------------------------
原始總金額:      ${order.item_subtotal|right:21}
{if order.discount_subtotal != 0}
折扣總金額:　    ${order.discount_subtotal|right:21}
{/if}
{if order.surcharge_subtotal != 0}
服務費金額:　    ${order.surcharge_subtotal|right:21}
{/if}
{for payment_type in payment_types}
${payment_type.display_name + '付款:'|left:17}${payment_type.amount|viviFormatPrices:true|right:21}
{/for}
{if (0 - order.remain) > 0}
找零:            ${(0 - order.remain)|right:21}
{/if}
------------------------------------------
${'總計:'|left:16}${count|right:3}項           [&DHON]${order.total|right:5}元[&DHOFF]
{if memos.length > 0}
{for memo in memos}
------------------------------------------
[&DHON]訂單備註：${memo}[&DHOFF]
{/for}
{/if}
{if customer != null}
------------------------------------------
名稱: ${customer.name|left:36}
電話: {if customer.telephone != ''} ${customer.telephone|left:42}{else} ${customer.customer_id|left:42}{/if}
地址: ${customer.addr1_addr1}
{if customer.addr1_addr2 != null && customer.addr1_addr2 != ''}
    : ${customer.addr1_addr2|left:36}
{/if}
{if customer.addr1_city != null && customer.addr1_city != ''}
    : ${customer.addr1_city|left:36}
{/if}
{/if}
{if order.annotations != null}
{for ann in order.annotations}
${ann|center:42}
{/for}
{/if}
${'謝謝光臨，歡迎您再度蒞臨'|center:42}
[&CR]
[&CR]
[&OPENDRAWER]
[&PC]
{/if}