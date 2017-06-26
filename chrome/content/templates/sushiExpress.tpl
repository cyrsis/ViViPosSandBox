[&INIT]
[0x1C][0x70][0x01][0x30]
{if duplicate}
[&QSON]${'<重印>'|center:22}[&QSOFF][&CR]
{/if}
{if order.status == -2}
[&QSON]${'<作廢>'|center:22}[&QSOFF][&CR]
{/if}
${store.address1|center}
${'店別:' + store.branch|left:24}${'電話:' + store.telephone1|right:15}
[&CR]
${'員工:' + order.service_clerk_displayname}
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
    else if (payment.name == 'octopus') display_name = '八達通';
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

日期:${today|left:24}時間:${time}
交易序號: ${order.seq|left:26}
----------------------------------------------
${'名稱'|left:28} ${'數量'|left:6} ${'金額'|right:8}
----------------------------------------------
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
[&DHON]${itemTrans.name|left:27}${itemTrans.current_qty|right:6}${item.current_subtotal|right:11}[&DHOFF]
{elseif item.type == 'discount' || item.type == 'surcharge'}
  ◎${item.name|left:30}${item.current_subtotal|right:10}
{elseif item.type == 'setitem'}
[&DHON]${'→'}${order.items[item.index].name|left:26}[&DHOFF]${item.current_qty|right:6}
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
    ${memoStr|left:38}
{/if}
{/if}
{/for}
----------------------------------------------
{if order.item_subtotal != order.total}
金額：     ${order.item_subtotal|viviFormatPrices:true|right:33}
{if order.surcharge_subtotal != 0}
加一服務：         ${(order.item_subtotal*0.1).toFixed(1)|right:26}
{/if}
{if order.discount_subtotal != 0}
折扣總金額：     ${order.discount_subtotal|right:27}
{/if}
{if order.item_subtotal - order.total + order.discount_subtotal + order.surcharge_subtotal > 0}
促銷總金額：     ${-(order.item_subtotal - order.total + order.discount_subtotal + order.surcharge_subtotal)|right:27}
{/if}
----------------------------------------------
{/if}
[&DHON]${'總計:'|left:26} ${count|right:6}[&DHON]${order.total|viviFormatPrices:true|right:10}元[&DHOFF]
----------------------------------------------
{for payment_type in payment_types}
${payment_type.display_name + '付款：'|left:17}${payment_type.amount|viviFormatPrices:true|right:27}
{/for}
[&CR]
${'加一服務費'}
${'不足整數將四捨五入'}
{if (0 - order.remain) > 0}
[&DHON]找零：${(0 - order.remain)|right:38}[&DHOFF]
{/if}
{if memos.length > 0}
{for memo in memos}
----------------------------------------------
[&DHON]訂單備註：${memo|left:36}[&DHOFF]
{/for}
{/if}
{if customer != null}
----------------------------------------------
名稱: ${customer.name|left:36}
    : ${customer.customer_id|left:36}
電話: ${customer.telephone|left:36}
地址: ${customer.addr1_addr1}
{if customer.addr1_addr2 != null && customer.addr1_addr2 != ''}
    : ${customer.addr1_addr2|left:36}
{/if}
{/if}
{if store.country != ''}
[&CR]
${store.country|center:42}
{/if}
[&CR]
[&CR]
[&CR]
[&CR]
[&CR]
[&PC]