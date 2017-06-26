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
{if order.destination != null && order.destination != ''}
[${order.destination}:${sequence}]
[&CR]
{/if}
[&DWON]${'銷售憑單'|center:16}[&DWOFF]
單號: ${sequence}
桌號: ${order.table_no|left:16} 
日期: ${today|left:16}
時間: ${time}
------------------------
${'序'|left:2} ${'商品名稱'|left:14} ${'數量'|left:2} ${'金額'|right:7}
------------------------
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
${++index|right:2} ${itemTrans.name|left:20}
             ${itemTrans.current_qty|right:4} ${item.current_subtotal|right:6}
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
------------------------
${'合計:'|left:14} ${count|right:3} ${order.item_subtotal|right:6}
------------------------
總減項金額:　     ${order.discount_subtotal|right:9}
總加項金額:　     ${order.surcharge_subtotal|right:9}
金額總計:        ${order.total|right:9}
已收金額:        ${order.payment_subtotal|right:9}
{if order.remain > 0}
應收金額:        ${order.remain|right:9}
{else}
找零:           ${0 - order.remain|right:9}
{/if}
------------------------
{if memos.length > 0}
{for memo in memos}
${memo|left:24}
{/for}
------------------------
{/if}
{if order.destination == '外送' && customer != null}
名稱: ${customer.name|left:18}
電話: ${customer.telephone|left:18}
地址: ${customer.addr1_addr1|left:18}
{if customer.addr1_addr2 != null && customer.addr1_addr2 != ''}
    : ${customer.addr1_addr2|left:18}
{/if}
{if customer.addr1_city != null && customer.addr1_city != ''}
    : ${customer.addr1_city|left:18}
{/if}
------------------------
{/if}
[&CR]
[&CR]
[&CR]
[&CR]
[&CR]
[&CR]
[&CR]
[&CR]
[&CR]
[&CR]
[&CR]
[&PC]
