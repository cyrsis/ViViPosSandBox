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
[&QSON]${store.branch|center:21}[&QSOFF]

{if store.state != ''}
[&QSON]${order.destination}單號:${sequence|tail:2}[&QSOFF]
{else}
[&QSON]${order.destination}單號:${sequence|tail:3}[&QSOFF]
{/if}
{if order.check_no != ''}
[&QSON]取餐號碼:${order.check_no}[&QSOFF]
{/if}
{if order.table_name != ''}
[&QSON]桌名:${table_name|left:16}[&QSOFF]
{/if}
日期:${today|left:24}時間:${time}
交易序號: ${order.seq|left:26}${'*0203'|right:9}
----------------------------------------------
${'商品名稱'|left:28} ${'數量'|left:6} ${'金額'|right:8}
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
原始總金額：     ${order.item_subtotal|right:27}
{if order.discount_subtotal != 0}
折扣總金額：     ${order.discount_subtotal|right:27}
{/if}
{if order.surcharge_subtotal != 0}
服務費金額：     ${order.surcharge_subtotal|right:27}
{/if}
{if order.item_subtotal - order.total + order.discount_subtotal + order.surcharge_subtotal > 0}
促銷總金額：     ${-(order.item_subtotal - order.total + order.discount_subtotal + order.surcharge_subtotal)|right:27}
{/if}
----------------------------------------------
{/if}
[&DHON]${'總計:'|left:26} ${count|right:6}[&DHON]${order.total|right:10}元[&DHOFF]
----------------------------------------------
{for payment_type in payment_types}
${payment_type.display_name + '付款：'|left:17}${payment_type.amount|viviFormatPrices:true|right:27}
{/for}
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
[&OPENDRAWER]
[&PC]
{/if}