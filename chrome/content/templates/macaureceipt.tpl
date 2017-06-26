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
[&CR]
[&INIT]
[0x1C][0x70][0x01][0x00]
[&QSON]${'檯號:'+order.table_name|left:20}[&QSOFF]
[&QSON]${store.name|center:20}[&QSOFF]
{if duplicate}
[&QSON]${'顧客重印單據'|center:20}[&QSOFF]
{else}
[&QSON]${'顧客單據'|center:20}[&QSOFF]
{/if}

==========================================
${'檯號:'|left:5}${order.table_name}             ${'人   數:'}${order.no_of_customers}
${'單號:'|left:5}${order.seq}  ${'閞單員工:'}${order.service_clerk_displayname}
${'日期:'|left:5}${(new Date()).toLocaleFormat('%Y-%m-%d')}     ${'時間:'}${(new Date()).toLocaleFormat('%H:%M:%S')}
=========================================
{for item in order.display_sequences}
{if item.type == 'item'}
${item.no|right:4} ${item.name}
${item.alt_language}
                    @${item.current_qty|right:6} ${item.current_subtotal|right:12}
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
[&CR]
[&CR]
[&QSON]${'多謝惠顧'|center:20}[&QSOFF]
[&CR]
[&CR]
[&CR]
[&CR]
[&CR]
[&CR]
[&PC]
{/for}
{if order.destination_prefix == 200}
=========================================
      [&QSON]取餐號碼:${order.seq|tail:4}[&QSOFF]

=========================================
[&CR]
[&CR]
[&CR]
[&CR]
[&CR]
[&CR]
[&PC]
{/if}