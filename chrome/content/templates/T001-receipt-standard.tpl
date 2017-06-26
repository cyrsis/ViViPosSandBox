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
{/if}
[&ULON][&DWON]${'銷售憑單'|center:21}[&DWOFF][&ULOFF]
單號: ${sequence}
門市: ${store.branch|left:16} 門市編號: ${store.branch_id|left:9}
桌號: ${order.table_no|left:16} 人數: ${order.no_of_customers}
日期: ${today|left:16} 時間: ${time}
機號: ${terminal|left:16} 收銀員: ${clerk}
------------------------------------------
${'序'|left:2} ${'商品名稱'|left:27} ${'數量'|left:4} ${'金額'|right:6}
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
${++index|right:2} ${itemTrans.name|left:39}
   ${condStr|left:27} ${itemTrans.current_qty|right:4} ${item.current_subtotal|right:6}
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
   ${memoStr|left:39}
{/if}
{/if}
{/for}
------------------------------------------
 ${'合計:'|left:29} ${count|right:4} ${order.item_subtotal|viviFormatPrices:true|right:6}
------------------------------------------
 ${'總減項金額:'|left:27} ${order.discount_subtotal + order.revalue_subtotal + order.promotion_subtotal|viviFormatPrices:true|right:13}
 ${'總加項金額:'|left:27} ${order.surcharge_subtotal|viviFormatPrices:true|right:13}
 ${'金額總計:'|left:27} ${order.total|viviFormatPrices:true|right:13}
 ${'已收金額:'|left:27} ${order.payment_subtotal|viviFormatPrices:true|right:13}
{if order.remain > 0}
 ${'應收金額:'|left:27} ${order.remain|viviFormatPrices:true|right:13}
{else}
 ${'找零:'|left:27} ${0 - order.remain|viviFormatPrices:true|right:13}
{/if}
------------------------------------------
{if memos.length > 0}
{for memo in memos}
${memo|left:42}
{/for}
------------------------------------------
{/if}
{if order.annotations != null && GeckoJS.BaseObject.getKeys(order.annotations).length > 0}
{for note in order.annotations}
${note_index|left:42}
  ${note|left:40}
{/for}
------------------------------------------
{/if}
{if order.destination == '外送' && customer != null}
名稱: ${customer.name|left:36}
電話: ${customer.telephone|left:36}
地址: ${customer.addr1_addr1|left:36}
{if customer.addr1_addr2 != null && customer.addr1_addr2 != ''}
    : ${customer.addr1_addr2|left:36}
{/if}
{if customer.addr1_city != null && customer.addr1_city != ''}
    : ${customer.addr1_city|left:36}
{/if}
------------------------------------------
{/if}
[&CR]
[&CR]
[&CR]
[&CR]
[&PC]
