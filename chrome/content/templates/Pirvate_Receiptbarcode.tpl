{eval}
  sequence = order.seq.toString();
  if (sequence == null) {
    sequence = '';
  }
  else {
    sequence = sequence.substr(-2);
  }
  count = 0;
  total = 0;
{/eval}
{if order.split_payments}
{eval}
splitPayments=[];
for (tp in order.trans_payments) {
   splitPayments.push( order.trans_payments[tp].amount);
}
{/eval}
{else}
{eval}
splitPayments=[order.payment_subtotal];
{/eval}
{/if}
{for receivePayment in splitPayments}
[&QSON]${store.name|center:20}[&QSOFF]
       
{if duplicate}
[&QSON]${'重印收據'|center:20}[&QSOFF]
{/if}
[&CR]
[&INIT]
${'單號:'|left:5}${order.seq}
${'印單時間: '|left:9}${(new Date()).toLocaleFormat('%Y-%m-%d')|left:15}${(new Date()).toLocaleFormat('%H:%M:%S')}

[&QSON]${'單號:'+sequence|center:20}[&QSOFF]

數量   食品          單價           銀碼
-----------------------------------------
{for item in order.display_sequences}
{if item.type == 'item'}
${item.current_qty|right:4} ${item.name|left:12} @${item.current_price|right:6} ${item.current_subtotal|right:12}
{elseif item.type == 'condiment'}
    {if item.current_price != null && item.current_price != 0}
    ${item.name|left:12} @${item.current_price|right:6}
    {else}
    ${item.name|left:36}
    {/if}
{elseif item.type == 'setitem'}
    {if item.current_price != null && item.current_price != 0}
    ${item.name|left:12} @${item.current_price|right:6}
    {else}
    ${item.name|left:36}
    {/if}
{elseif item.type == 'memo'}
        ${item.name|left:32}
{elseif item.type == 'discount' || item.type == 'surcharge'}
     ${item.name|left:20} ${item.current_subtotal|right:12}
{elseif item.type == 'tray'}
     ${item.name|left:20} ${item.current_subtotal|right:12}
{/if}
{/for}
__________________________________________
${'小計:'|left:15}${(order.total)|viviFormatPrices:true|right:24}
[&CR]
${'付款方式:'|left:15}
{for payment in order.trans_payments}
{eval}
{/eval}
{if payment.name == 'cash'}
  [&QSON]${'現金:'|left:5}           ${payment.amount|viviFormatPrices:true}[&QSOFF]
{else}
   ${payment.memo1 + ':'|left:15} ${payment.amount|viviFormatPrices:true|right:22}
{/if}
{/for}
[&CR]
{if order.trans_discount_subtotal != 0 || order.trans_surcharge_subtotal != 0 || order.revalue_subtotal != 0 || order.promotion_subtotal != 0}
{if order.trans_discount_subtotal != 0}${'优惠折扣:'|left:15} ${order.trans_discount_subtotal|viviFormatPrices:true|right:24}
{/if}
{if order.trans_surcharge_subtotal != 0}${'服務費:'|left:15} ${order.trans_surcharge_subtotal|viviFormatPrices:true|right:24}
{/if}
{if order.revalue_subtotal != 0}${'Order Revalue:'|left:15} ${order.revalue_subtotal|viviFormatPrices:true|right:24}
{/if}
{if order.promotion_subtotal != 0}${'促销活动:'|left:15} ${order.promotion_subtotal|viviFormatPrices:true|right:24}
{/if}
{/if}
[&DWON]${'應付金額:'|left:5}           ${order.total|viviFormatPrices:true}[&DWOFF]
${'已收金額:'|left:15} ${receivePayment|viviFormatPrices:true|right:24}
${'找零:'|left:15} ${order.remain|viviFormatPrices:true|right:24}

----------------------------------------
{if  customer != null}
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
${'電話:' + store.telephone1|center:40}
${'地址:' + store.address1|center:40}
${'多謝光臨'|center:40}
[&CR]
[&CR]
[&CR]
[0x1B][0x40][0x1D][0x77][0x02][0x1B][0x61][0x01][0x1D][0x68][0x5A][0x1D][0x6B][0x48][0x0B]${order.seq}
[&CR]
[&CR]
[&CR]
[&PC]
{/for}